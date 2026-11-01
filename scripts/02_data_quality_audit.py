
from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parent.parent
RAW = ROOT / "data" / "raw"
REPORTS = ROOT / "reports"
REPORTS.mkdir(exist_ok=True)

# Load only columns needed for the audit
files = {
    "customers": ("olist_customers_dataset.csv",
                  ["customer_id"]),
    "orders": ("olist_orders_dataset.csv",
               ["order_id", "customer_id", "order_status",
                "order_approved_at",
                "order_delivered_carrier_date",
                "order_delivered_customer_date"]),
    "items": ("olist_order_items_dataset.csv",
              ["order_id", "order_item_id",
               "product_id", "seller_id"]),
    "payments": ("olist_order_payments_dataset.csv",
                 ["order_id", "payment_sequential"]),
    "reviews": ("olist_order_reviews_dataset.csv",
                ["order_id"]),
    "products": ("olist_products_dataset.csv",
                 ["product_id"]),
    "sellers": ("olist_sellers_dataset.csv",
                ["seller_id"])
}

data = {
    name: pd.read_csv(RAW / filename, usecols=columns)
    for name, (filename, columns) in files.items()
}

# 1. Check keys expected to be unique
keys = {
    "customers": ["customer_id"],
    "orders": ["order_id"],
    "items": ["order_id", "order_item_id"],
    "payments": ["order_id", "payment_sequential"],
    "products": ["product_id"],
    "sellers": ["seller_id"]
}

key_results = []

for name, columns in keys.items():
    df = data[name]

    key_results.append({
        "table": name,
        "key_columns": ", ".join(columns),
        "duplicate_key_rows": int(
            df.duplicated(subset=columns).sum()
        ),
        "rows_with_null_keys": int(
            df[columns].isna().any(axis=1).sum()
        )
    })

pd.DataFrame(key_results).to_csv(
    REPORTS / "data_quality_keys.csv",
    index=False
)

# 2. Check relationships between tables
relationships = [
    ("orders", "customer_id", "customers", "customer_id"),
    ("items", "order_id", "orders", "order_id"),
    ("payments", "order_id", "orders", "order_id"),
    ("reviews", "order_id", "orders", "order_id"),
    ("items", "product_id", "products", "product_id"),
    ("items", "seller_id", "sellers", "seller_id")
]

relationship_results = []

for child, child_key, parent, parent_key in relationships:
    child_values = data[child][child_key]
    parent_values = data[parent][parent_key]

    orphan_mask = (
        child_values.notna()
        & ~child_values.isin(parent_values.dropna())
    )

    relationship_results.append({
        "child_table": child,
        "parent_table": parent,
        "join_column": child_key,
        "orphan_rows": int(orphan_mask.sum())
    })

pd.DataFrame(relationship_results).to_csv(
    REPORTS / "data_quality_relationships.csv",
    index=False
)

# 3. Investigate missing order timestamps by status
orders = data["orders"]

status_report = orders.groupby(
    "order_status", dropna=False
).agg(
    total_orders=("order_id", "size"),
    missing_approval=(
        "order_approved_at",
        lambda x: x.isna().sum()
    ),
    missing_carrier_date=(
        "order_delivered_carrier_date",
        lambda x: x.isna().sum()
    ),
    missing_delivery_date=(
        "order_delivered_customer_date",
        lambda x: x.isna().sum()
    )
).reset_index()

status_report.to_csv(
    REPORTS / "orders_missing_by_status.csv",
    index=False
)

print("Data quality audit completed!")
print("\nDuplicate key checks:")
print(pd.DataFrame(key_results).to_string(index=False))

print("\nRelationship checks:")
print(pd.DataFrame(relationship_results).to_string(index=False))

print("\nOrder status report:")
print(status_report.to_string(index=False))
