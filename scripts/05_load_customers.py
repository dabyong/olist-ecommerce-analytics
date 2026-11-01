
from pathlib import Path
import csv
import os

import mysql.connector
from dotenv import load_dotenv

ROOT = Path(__file__).resolve().parent.parent
CSV_FILE = ROOT / "data" / "raw" / "olist_customers_dataset.csv"

# Load database connection settings
load_dotenv(ROOT / ".env")

password = os.getenv("DB_PASSWORD")
if not password:
    raise RuntimeError("DB_PASSWORD is missing from .env")

# Establish connection to MySQL
connection = mysql.connector.connect(
    host=os.getenv("DB_HOST", "127.0.0.1"),
    port=int(os.getenv("DB_PORT", "3307")),
    user=os.getenv("DB_USER", "root"),
    password=password,
    database=os.getenv("DB_NAME", "olist_ecommerce")
)

cursor = connection.cursor()

columns = [
    "customer_id",
    "customer_unique_id",
    "customer_zip_code_prefix",
    "customer_city",
    "customer_state"
]

insert_sql = """
INSERT INTO stg_customers (
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
)
VALUES (%s, %s, %s, %s, %s)
"""

try:
    # Keep the import transactional and repeatable
    with open(CSV_FILE, newline="", encoding="utf-8") as file:
        reader = csv.DictReader(file)

        if reader.fieldnames != columns:
            raise ValueError("Unexpected customer CSV columns")

        cursor.execute("DELETE FROM stg_customers")

        batch = []
        total = 0

        for row in reader:
            batch.append(tuple(row[col] for col in columns))

            if len(batch) >= 2000:
                cursor.executemany(insert_sql, batch)
                total += len(batch)
                batch.clear()

        if batch:
            cursor.executemany(insert_sql, batch)
            total += len(batch)

    cursor.execute("SELECT COUNT(*) FROM stg_customers")
    db_count = cursor.fetchone()[0]

    if total != db_count:
        raise ValueError(
            f"Row mismatch: CSV={total}, MySQL={db_count}"
        )

    connection.commit()

    print("MySQL connection successful!")
    print(f"CSV rows loaded: {total:,}")
    print(f"MySQL row count: {db_count:,}")
    print("Import completed successfully!")

except Exception:
    connection.rollback()
    raise

finally:
    cursor.close()
    connection.close()
