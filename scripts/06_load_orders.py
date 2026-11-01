
from pathlib import Path
import csv
import os

import mysql.connector
from dotenv import load_dotenv

# Project directories
ROOT = Path(__file__).resolve().parent.parent
CSV_FILE = ROOT / "data" / "processed" / "orders_prepared.csv"

# Load MySQL credentials
load_dotenv(ROOT / ".env")

password = os.getenv("DB_PASSWORD")

if not password:
    raise RuntimeError("DB_PASSWORD is missing from .env")

# Connect to MySQL
connection = mysql.connector.connect(
    host=os.getenv("DB_HOST", "127.0.0.1"),
    port=int(os.getenv("DB_PORT", "3307")),
    user=os.getenv("DB_USER", "root"),
    password=password,
    database=os.getenv("DB_NAME", "olist_ecommerce")
)

cursor = connection.cursor()

columns = [
    "order_id",
    "customer_id",
    "order_status",
    "order_purchase_timestamp",
    "order_approved_at",
    "order_delivered_carrier_date",
    "order_delivered_customer_date",
    "order_estimated_delivery_date",
    "quality_issues",
    "has_quality_issue",
    "eligible_delivery_kpi",
    "eligible_shipping_timeline"
]

insert_sql = """
INSERT INTO stg_orders (
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    quality_issues,
    has_quality_issue,
    eligible_delivery_kpi,
    eligible_shipping_timeline
)
VALUES (%s, %s, %s, %s, %s, %s,
        %s, %s, %s, %s, %s, %s)
"""

try:
    total = 0
    batch = []

    with open(CSV_FILE, newline="", encoding="utf-8") as file:
        reader = csv.DictReader(file)

        if reader.fieldnames != columns:
            raise ValueError("Unexpected orders CSV columns")

        # Clear previous staging records
        # within the same transaction
        cursor.execute("DELETE FROM stg_orders")

        for row in reader:
            values = []

            for col in columns:
                value = row[col]

                # Convert empty CSV values into SQL NULL
                if value == "":
                    value = None

                # Convert quality flags to integers
                if col in [
                    "has_quality_issue",
                    "eligible_delivery_kpi",
                    "eligible_shipping_timeline"
                ] and value is not None:
                    value = int(value)

                values.append(value)

            batch.append(tuple(values))

            if len(batch) >= 2000:
                cursor.executemany(insert_sql, batch)
                total += len(batch)
                batch.clear()

        if batch:
            cursor.executemany(insert_sql, batch)
            total += len(batch)

    # Validate the imported records
    cursor.execute("SELECT COUNT(*) FROM stg_orders")
    db_count = cursor.fetchone()[0]

    if total != db_count or total != 99441:
        raise ValueError(
            f"Import validation failed: "
            f"CSV={total}, MySQL={db_count}"
        )

    connection.commit()

    print("MySQL connection successful!")
    print(f"Orders imported: {total:,}")
    print(f"MySQL records: {db_count:,}")
    print("Import completed successfully!")

except Exception:
    connection.rollback()
    raise

finally:
    cursor.close()
    connection.close()
