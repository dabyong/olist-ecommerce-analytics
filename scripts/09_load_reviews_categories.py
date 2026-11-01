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
    raise RuntimeError("DB_PASSWORD is missing")

tables = {
    "stg_reviews": {
        "file": "olist_order_reviews_dataset.csv",
        "expected": 99224,
        "columns": [
            "review_id",
            "order_id",
            "review_score",
            "review_comment_title",
            "review_comment_message",
            "review_creation_date",
            "review_answer_timestamp"
        ]
    },
    "stg_category_translation": {
        "file": "product_category_name_translation.csv",
        "expected": 71,
        "columns": [
            "product_category_name",
            "product_category_name_english"
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
    for table, config in tables.items():
        columns = config["columns"]
        file_path = RAW / config["file"]

        placeholders = ", ".join(["%s"] * len(columns))
        column_sql = ", ".join(columns)

        sql = (
            f"INSERT INTO {table} ({column_sql}) "
            f"VALUES ({placeholders})"
        )

        cursor.execute(f"DELETE FROM {table}")

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

                if len(batch) >= 1000:
                    cursor.executemany(sql, batch)
                    total += len(batch)
                    batch.clear()

            if batch:
                cursor.executemany(sql, batch)
                total += len(batch)

        cursor.execute(f"SELECT COUNT(*) FROM {table}")
        db_count = cursor.fetchone()[0]

        if total != db_count or total != config["expected"]:
            raise ValueError(
                f"Validation failed: {table}, "
                f"CSV={total}, MySQL={db_count}"
            )

        print(f"{table}: {db_count:,} rows validated")

    connection.commit()
    print("\nBoth imports completed successfully!")

except Exception:
    connection.rollback()
    raise

finally:
    cursor.close()
    connection.close()
