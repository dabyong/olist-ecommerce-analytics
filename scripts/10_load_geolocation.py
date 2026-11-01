
from pathlib import Path
import csv
import os

import mysql.connector
from dotenv import load_dotenv

ROOT = Path(__file__).resolve().parent.parent
RAW = ROOT / "data" / "raw"

load_dotenv(ROOT / ".env")

CSV_FILE = RAW / "olist_geolocation_dataset.csv"
EXPECTED_ROWS = 1_000_163
BATCH_SIZE = 2000

password = os.getenv("DB_PASSWORD")

if not password:
    raise RuntimeError("DB_PASSWORD is missing from .env")

connection = mysql.connector.connect(
    host=os.getenv("DB_HOST", "127.0.0.1"),
    port=int(os.getenv("DB_PORT", "3307")),
    user=os.getenv("DB_USER", "root"),
    password=password,
    database=os.getenv("DB_NAME", "olist_ecommerce"),
    charset="utf8mb4"
)

cursor = connection.cursor()

columns = [
    "geolocation_zip_code_prefix",
    "geolocation_lat",
    "geolocation_lng",
    "geolocation_city",
    "geolocation_state"
]

insert_sql = """
INSERT INTO stg_geolocation (
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
)
VALUES (%s, %s, %s, %s, %s)
"""

try:
    total = 0
    batch = []

    # Clear previous staging records.
    # This is part of the transaction.
    cursor.execute("DELETE FROM stg_geolocation")

    with open(
        CSV_FILE,
        newline="",
        encoding="utf-8-sig"
    ) as file:

        reader = csv.DictReader(file)

        if reader.fieldnames != columns:
            raise ValueError(
                "Unexpected geolocation CSV columns"
            )

        for row in reader:

            # Standardize postal prefixes to 5 characters
            zip_prefix = (
                row["geolocation_zip_code_prefix"]
                .strip()
                .zfill(5)
            )

            values = (
                zip_prefix,
                float(row["geolocation_lat"]),
                float(row["geolocation_lng"]),
                row["geolocation_city"],
                row["geolocation_state"]
            )

            batch.append(values)

            if len(batch) >= BATCH_SIZE:
                cursor.executemany(insert_sql, batch)
                total += len(batch)
                batch.clear()

                if total % 100000 == 0:
                    print(f"Processed {total:,} rows")

        if batch:
            cursor.executemany(insert_sql, batch)
            total += len(batch)

    # Validate the imported dataset
    cursor.execute(
        "SELECT COUNT(*) FROM stg_geolocation"
    )

    db_count = cursor.fetchone()[0]

    if total != db_count or total != EXPECTED_ROWS:
        raise ValueError(
            f"Validation failed: "
            f"CSV={total}, MySQL={db_count}"
        )

    connection.commit()

    print("\nGEOLOCATION IMPORT SUCCESSFUL")
    print(f"CSV rows: {total:,}")
    print(f"MySQL rows: {db_count:,}")
    print("Validation passed!")

except Exception:
    connection.rollback()
    print("Import failed. Transaction rolled back.")
    raise

finally:
    cursor.close()
    connection.close()
