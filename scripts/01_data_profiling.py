
from pathlib import Path
import pandas as pd

# Locate the project and its raw data
PROJECT_ROOT = Path(__file__).resolve().parent.parent
DATA_PATH = PROJECT_ROOT / "data" / "raw"
REPORT_PATH = PROJECT_ROOT / "reports"

REPORT_PATH.mkdir(exist_ok=True)

summary = []
missing_report = []

csv_files = sorted(DATA_PATH.glob("*.csv"))

if len(csv_files) != 9:
    raise SystemExit(
        f"Expected 9 CSV files, found {len(csv_files)} "
        f"in {DATA_PATH}"
    )

for file in csv_files:
    row_count = 0
    column_names = []
    missing_counts = None

    # Read in chunks to reduce memory usage
    for chunk in pd.read_csv(file, chunksize=50000):
        row_count += len(chunk)
        column_names = list(chunk.columns)

        chunk_missing = chunk.isna().sum()

        if missing_counts is None:
            missing_counts = chunk_missing
        else:
            missing_counts = missing_counts.add(
                chunk_missing, fill_value=0
            )

    total_columns = len(column_names)
    missing_cells = int(missing_counts.sum())
    total_cells = row_count * total_columns

    missing_pct = (
        (missing_cells / total_cells) * 100
        if total_cells else 0
    )

    summary.append({
        "dataset": file.name,
        "rows": row_count,
        "columns": total_columns,
        "missing_cells": missing_cells,
        "missing_percentage": round(missing_pct, 2)
    })

    for column in column_names:
        missing = int(missing_counts[column])
        missing_report.append({
            "dataset": file.name,
            "column": column,
            "missing_count": missing,
            "missing_percentage": round(
                missing / row_count * 100, 2
            ) if row_count else 0
        })

    print(f"{file.name}: {row_count:,} rows")

# Export profiling results
pd.DataFrame(summary).to_csv(
    REPORT_PATH / "data_profile_summary.csv",
    index=False
)

pd.DataFrame(missing_report).to_csv(
    REPORT_PATH / "missing_values_report.csv",
    index=False
)

print("\nData profiling completed!")
print(f"Processed {len(csv_files)} datasets.")
print("Reports saved in the reports folder.")
