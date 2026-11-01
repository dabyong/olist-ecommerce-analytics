
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

# Fixed import configurations
tables = {
    "stg_order_items": {
        "file": "olist_order_items_dataset.csv",
        "expected_rows": 112650,
        "columns": [
            "order_id",
            "order_item_id",
            "product_id",
            "seller_id",
            "shipping_limit_date",
            "price",
            "freight_value"
        ]
    },
    "stg_order_payments": {
        "file": "olist_order_payments_dataset.csv",
        "expected_rows": 103886,
        "columns": [
            "order_id",
            "payment_sequential",
            "payment_type",
            "payment_installments",
            "payment_value"
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
    # Both imports share one transaction
    for table_name, config in tables.items():
        file_path = RAW / config["file"]
        columns = config["columns"]

        column_sql = ", ".join(columns)
        placeholders = ", ".join(["%s"] * len(columns))

        insert_sql = (
            f"INSERT INTO {table_name} "
            f"({column_sql}) VALUES ({placeholders})"
        )

        # Clear staging records for repeatable loading
        cursor.execute(f"DELETE FROM {table_name}")

        total = 0
        batch = []

        with open(
            file_path, newline="", encoding="utf-8-sig"
        ) as file:

            reader = csv.DictReader(file)

            if reader.fieldnames != columns:
                raise ValueError(
                    f"Unexpected columns in {file_path.name}"
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

        # Verify the import before committing
        cursor.execute(
            f"SELECT COUNT(*) FROM {table_name}"
        )
        db_count = cursor.fetchone()[0]

        if total != db_count:
            raise ValueError(
                f"Row count mismatch in {table_name}"
            )

        if total != config["expected_rows"]:
            raise ValueError(
                f"Unexpected source count in {table_name}"
            )

        print(f"\n{table_name}")
        print(f"CSV rows: {total:,}")
        print(f"MySQL rows: {db_count:,}")
        print("Validation passed!")

    connection.commit()
    print("\nBoth imports completed successfully!")

except Exception:
    connection.rollback()
    print("Import failed. Transaction rolled back.")
    raise

finally:
    cursor.close()
    connection.close()
