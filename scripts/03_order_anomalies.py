
from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parent.parent
RAW = ROOT / "data" / "raw"
REPORTS = ROOT / "reports"
REPORTS.mkdir(exist_ok=True)

orders = pd.read_csv(
    RAW / "olist_orders_dataset.csv"
)

# Convert timestamp columns to datetime
date_columns = [
    "order_purchase_timestamp",
    "order_approved_at",
    "order_delivered_carrier_date",
    "order_delivered_customer_date",
    "order_estimated_delivery_date"
]

for col in date_columns:
    orders[col] = pd.to_datetime(
        orders[col], errors="coerce"
    )

# Check potentially inconsistent order records
checks = {
    "delivered_without_delivery_date": (
        orders["order_status"].eq("delivered")
        & orders["order_delivered_customer_date"].isna()
    ),
    "delivered_without_approval_date": (
        orders["order_status"].eq("delivered")
        & orders["order_approved_at"].isna()
    ),
    "delivered_without_carrier_date": (
        orders["order_status"].eq("delivered")
        & orders["order_delivered_carrier_date"].isna()
    ),
    "canceled_with_delivery_date": (
        orders["order_status"].eq("canceled")
        & orders["order_delivered_customer_date"].notna()
    ),
    "delivery_before_purchase": (
        orders["order_delivered_customer_date"]
        < orders["order_purchase_timestamp"]
    ),
    "carrier_after_delivery": (
        orders["order_delivered_carrier_date"]
        > orders["order_delivered_customer_date"]
    )
}

flags = pd.DataFrame(checks)

# Count flagged records for each rule
summary = pd.DataFrame({
    "issue": flags.columns,
    "affected_rows": flags.sum().values
})

summary.to_csv(
    REPORTS / "order_anomaly_summary.csv",
    index=False
)

# Save records with at least one issue
exceptions = orders.loc[flags.any(axis=1)].copy()

exceptions["issues"] = flags.loc[
    exceptions.index
].apply(
    lambda row: ", ".join(row.index[row]),
    axis=1
)

exceptions.to_csv(
    REPORTS / "order_anomalies.csv",
    index=False
)

print("\nORDER ANOMALY SUMMARY")
print(summary.to_string(index=False))

print(
    f"\nUnique flagged orders: {len(exceptions)}"
)
print("Audit completed. Raw data was not changed.")
