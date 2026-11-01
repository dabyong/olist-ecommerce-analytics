
from pathlib import Path
import csv
import os

import mysql.connector
from dotenv import load_dotenv

ROOT = Path(__file__).resolve().parent.parent
RAW = ROOT / "data" / "raw"

load_dotenv(ROOT / ".env")

password = os.getenv("DB_PASSWORD")

if not password:
    raise RuntimeError("DB_PASSWORD is missing from .env")

# Dataset configurations
tables = {
    "stg_products": {
        "file": "olist_products_dataset.csv",
        "columns": [
            "product_id",
            "product_category_name",
            "product_name_lenght",
            "product_description_lenght",
            "product_photos_qty",
            "product_weight_g",
            "product_length_cm",
            "product_height_cm",
            "product_width_cm"
        ]
    },
    "stg_sellers": {
        "file": "olist_sellers_dataset.csv",
        "columns": [
            "seller_id",
            "seller_zip_code_prefix",
            "seller_city",
            "seller_state"
        ]
    }
}

connection = mysql.connector.connect(
    host=os.getenv("DB_HOST", "127.0.0.1"),
    port=int(os.getenv("DB_PORT", "3307")),
    user=os.getenv("DB_USER", "root"),
    password=password,
    database=os.getenv("DB_NAME", "olist_ecommerce"),
    charset="utf8mb4"
)

cursor = connection.cursor()

try:
    for table_name, config in tables.items():
        file_path = RAW / config["file"]
        columns = config["columns"]

        column_sql = ", ".join(columns)
        placeholders = ", ".join(["%s"] * len(columns))

        insert_sql = (
            f"INSERT INTO {table_name} "
            f"({column_sql}) "
            f"VALUES ({placeholders})"
        )

        total = 0
        batch = []

        try:
            # Replace previous staging rows safely
            cursor.execute(f"DELETE FROM {table_name}")

            with open(
                file_path,
                newline="",
                encoding="utf-8-sig"
            ) as file:

                reader = csv.DictReader(file)

                if reader.fieldnames != columns:
                    raise ValueError(
                        f"Unexpected columns in {config['file']}"
                    )

                for row in reader:
                    values = tuple(
                        row[col] if row[col] != "" else None
                        for col in columns
                    )

                    batch.append(values)

                    if len(batch) >= 2000:
                        cursor.executemany(insert_sql, batch)
                        total += len(batch)
                        batch.clear()

                if batch:
                    cursor.executemany(insert_sql, batch)
                    total += len(batch)

            cursor.execute(
                f"SELECT COUNT(*) FROM {table_name}"
            )
            db_count = cursor.fetchone()[0]

            if total != db_count:
                raise ValueError(
                    f"Row count mismatch in {table_name}"
                )

            connection.commit()

            print(f"\n{table_name}")
            print(f"CSV rows: {total:,}")
            print(f"MySQL rows: {db_count:,}")
            print("Import successful!")

        except Exception:
            connection.rollback()
            raise

finally:
    cursor.close()
    connection.close()

print("\nAll requested imports completed!")
