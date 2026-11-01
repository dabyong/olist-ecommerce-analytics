
from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parent.parent
RAW = ROOT / "data" / "raw"
PROCESSED = ROOT / "data" / "processed"
REPORTS = ROOT / "reports"

PROCESSED.mkdir(parents=True, exist_ok=True)
REPORTS.mkdir(parents=True, exist_ok=True)

# Load original orders without modifying the raw CSV
orders = pd.read_csv(
    RAW / "olist_orders_dataset.csv"
)

original_rows = len(orders)

# Standardize order statuses
orders["order_status"] = (
    orders["order_status"]
    .astype("string")
    .str.strip()
    .str.lower()
)

# Convert dates to a consistent datetime format
date_columns = [
    "order_purchase_timestamp",
    "order_approved_at",
    "order_delivered_carrier_date",
    "order_delivered_customer_date",
    "order_estimated_delivery_date"
]

for col in date_columns:
    orders[col] = pd.to_datetime(
        orders[col], errors="raise"
    )

purchase = orders["order_purchase_timestamp"]
approval = orders["order_approved_at"]
carrier = orders["order_delivered_carrier_date"]
delivery = orders["order_delivered_customer_date"]
delivered = orders["order_status"].eq("delivered").fillna(False)

# Record data quality problems
flags = pd.DataFrame(index=orders.index)

flags["delivered_without_delivery_date"] = (
    delivered & delivery.isna()
)
flags["delivered_without_approval_date"] = (
    delivered & approval.isna()
)
flags["delivered_without_carrier_date"] = (
    delivered & carrier.isna()
)
flags["canceled_with_delivery_date"] = (
    orders["order_status"].eq("canceled").fillna(False)
    & delivery.notna()
)
flags["delivery_before_purchase"] = delivery < purchase
flags["carrier_after_delivery"] = carrier > delivery

orders["quality_issues"] = flags.apply(
    lambda row: ", ".join(row.index[row]),
    axis=1
)

orders["has_quality_issue"] = (
    flags.any(axis=1).astype(int)
)

# Eligibility for customer delivery KPIs
valid_delivery = (
    delivered
    & purchase.notna()
    & delivery.notna()
    & (delivery >= purchase)
)

orders["eligible_delivery_kpi"] = valid_delivery.astype(int)

# Eligibility for full shipping timeline analysis
valid_shipping = (
    valid_delivery
    & carrier.notna()
    & (carrier >= purchase)
    & (carrier <= delivery)
)

orders["eligible_shipping_timeline"] = (
    valid_shipping.astype(int)
)

# Preserve all orders and validate identifiers
assert len(orders) == original_rows
assert orders["order_id"].notna().all()
assert orders["order_id"].is_unique

# Save analytics-ready orders
orders.to_csv(
    PROCESSED / "orders_prepared.csv",
    index=False,
    date_format="%Y-%m-%d %H:%M:%S"
)

# Generate verification report
summary = pd.DataFrame({
    "metric": [
        "original_orders",
        "prepared_orders",
        "flagged_orders",
        "eligible_delivery_kpi",
        "eligible_shipping_timeline"
    ],
    "count": [
        original_rows,
        len(orders),
        int(orders["has_quality_issue"].sum()),
        int(orders["eligible_delivery_kpi"].sum()),
        int(orders["eligible_shipping_timeline"].sum())
    ]
})

summary.to_csv(
    REPORTS / "orders_preparation_summary.csv",
    index=False
)

print("\nORDER PREPARATION RESULTS")
print(summary.to_string(index=False))
print("\nPreparation completed. No orders deleted.")
