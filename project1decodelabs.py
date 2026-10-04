
from pathlib import Path
from datetime import datetime
from copy import copy
import argparse

import numpy as np
import pandas as pd

DEFAULT_INPUT = Path(r"C:\Users\srine\Downloads\Dataset for Data Analytics.xlsx")
DEFAULT_OUTPUT = Path(r"C:\Users\srine\Downloads\DecodeLabs_Project1_Output")

EXPECTED_COLUMNS = [
    "OrderID", "Date", "CustomerID", "Product", "Quantity", "UnitPrice",
    "ShippingAddress", "PaymentMethod", "OrderStatus", "TrackingNumber",
    "ItemsInCart", "CouponCode", "ReferralSource", "TotalPrice",
]

NUMERIC_COLUMNS = ["Quantity", "UnitPrice", "ItemsInCart", "TotalPrice"]

ID_PATTERNS = {
    "OrderID": r"ORD\d{6}",
    "CustomerID": r"C\d{5}",
    "TrackingNumber": r"TRK\d{8}",
}

PRICE_COLUMNS = ["UnitPrice", "TotalPrice"]


def load_data(file_path):
    if not file_path.exists():
        raise FileNotFoundError(f"Input file not found:\n{file_path}")

    df = pd.read_excel(file_path, sheet_name=0)
    df.columns = df.columns.astype(str).str.strip()

    missing_cols = [c for c in EXPECTED_COLUMNS if c not in df.columns]
    if missing_cols:
        raise ValueError("Missing expected columns:\n" + "\n".join(missing_cols))

    return df[EXPECTED_COLUMNS].copy()


def clean_data(df):
    df = df.copy()
    changes = []

    text_cols = df.select_dtypes(include=["object", "string"]).columns
    whitespace_fixed = 0

    for col in text_cols:
        before = df[col].copy()
        df[col] = df[col].where(df[col].isna(), df[col].astype(str).str.strip())
        whitespace_fixed += int((before.fillna("<NA>") != df[col].fillna("<NA>")).sum())

    changes.append({
        "Change ID": "CL001",
        "Description": "Trimmed leading/trailing whitespace.",
        "Affected": whitespace_fixed,
        "Reason": "Removes formatting inconsistencies from text fields.",
    })


    no_coupon = df["CouponCode"].isna() | df["CouponCode"].eq("")
    coupon_count = int(no_coupon.sum())
    df.loc[no_coupon, "CouponCode"] = "NO_COUPON"

    changes.append({
        "Change ID": "CL002",
        "Description": "Replaced missing CouponCode with 'NO_COUPON'.",
        "Affected": coupon_count,
        "Reason": "Preserves valid orders where no coupon was recorded.",
    })

    original_dates = df["Date"].copy()
    parsed_dates = pd.to_datetime(df["Date"], errors="coerce")

    bad_dates = int((original_dates.notna() & parsed_dates.isna()).sum())
    if bad_dates:

        raise ValueError(f"{bad_dates} invalid date values found.")

    dates_changed = int(
        (original_dates.fillna(pd.Timestamp("1900-01-01"))
         != parsed_dates.fillna(pd.Timestamp("1900-01-01"))).sum()
    )
    df["Date"] = parsed_dates

    changes.append({
        "Change ID": "CL003",
        "Description": "Validated and standardized Date values.",
        "Affected": dates_changed,
        "Reason": "Ensures consistent date handling for analysis.",
    })

    numeric_fixed = 0
    for col in NUMERIC_COLUMNS:
        before = df[col].copy()
        converted = pd.to_numeric(df[col], errors="coerce")

        broke_conversion = before.notna() & converted.isna()
        if broke_conversion.any():
            raise ValueError(f"{int(broke_conversion.sum())} invalid numeric values found in {col}.")

        numeric_fixed += int((before.fillna(-999999999) != converted.fillna(-999999999)).sum())
        df[col] = converted

    changes.append({
        "Change ID": "CL004",
        "Description": "Validated numeric columns.",
        "Affected": numeric_fixed,
        "Reason": "Prevents text-formatted numbers from affecting calculations.",
    })

    dupe_count = int(df.duplicated().sum())
    if dupe_count:
        df = df.drop_duplicates().reset_index(drop=True)

    changes.append({
        "Change ID": "CL005",
        "Description": "Removed exact duplicate records.",
        "Affected": dupe_count,
        "Reason": "Prevents duplicate transactions from inflating results.",
    })

    return df, changes


def validate_data(df):
    checks = []

    def add(category, check, result, note=""):
        checks.append({
            "Category": category,
            "Check": check,
            "Result": result,
            "Status": "PASS" if result == 0 else "FAIL",
            "Notes": note,
        })

    add("Completeness", "Missing values after cleaning", int(df.isna().sum().sum()), "Expected 0.")
    add("Duplicates", "Exact duplicate rows", int(df.duplicated().sum()), "Expected 0.")

    add("Identifiers", "Duplicate OrderID", int(df["OrderID"].duplicated().sum()), "OrderID must be unique.")

    for col, pattern in ID_PATTERNS.items():
        note = "Repeated customers are valid." if col == "CustomerID" else "Expected 0."
        bad = int((~df[col].astype(str).str.fullmatch(pattern)).sum())
        add("Identifiers", f"Invalid {col} format", bad, f"Expected pattern: {pattern}. {note}")

    add("Identifiers", "Duplicate TrackingNumber", int(df["TrackingNumber"].duplicated().sum()), "Expected 0.")

    add("Dates", "Invalid dates", int(pd.to_datetime(df["Date"], errors="coerce").isna().sum()), "Expected 0.")

    for col in NUMERIC_COLUMNS:
        bad = int((df[col].isna() | (df[col] <= 0)).sum())
        add("Numeric Validation", f"Invalid {col}", bad, "Expected positive numeric values.")

    expected_total = df["Quantity"] * df["UnitPrice"]
    mismatches = int((~np.isclose(df["TotalPrice"], expected_total, rtol=1e-9, atol=1e-8)).sum())
    add("Business Rule", "TotalPrice reconciliation", mismatches, "Expected TotalPrice = Quantity × UnitPrice.")

    return pd.DataFrame(checks)


def create_profile(raw, cleaned):
    """Quick before/after summary for each column - mostly useful for spot-checking."""
    rows = []
    for col in raw.columns:
        rows.append({
            "Column": col,
            "Data Type": str(cleaned[col].dtype),
            "Missing Before": int(raw[col].isna().sum()),
            "Missing After": int(cleaned[col].isna().sum()),
            "Unique Values": int(cleaned[col].nunique(dropna=True)),
        })
    return pd.DataFrame(rows)


def safe_path(path):

    if not path.exists():
        return path

    stamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    return path.with_name(f"{path.stem}_{stamp}{path.suffix}")


def format_sheet(writer, sheet_name):
    ws = writer.sheets[sheet_name]
    ws.freeze_panes = "A2"
    ws.auto_filter.ref = ws.dimensions

    for cell in ws[1]:
        cell.font = copy(cell.font)
        cell.font = cell.font.copy(bold=True)

    for column in ws.columns:
        lengths = [len(str(cell.value)) for cell in column[:100] if cell.value is not None]
        width = min(max(max(lengths, default=12) + 2, 12), 45)
        ws.column_dimensions[column[0].column_letter].width = width


def save_results(raw, cleaned, quality, changes, output_dir):
    output_dir.mkdir(parents=True, exist_ok=True)

    cleaned_path = safe_path(output_dir / "DecodeLabs_Project1_Cleaned.xlsx")
    quality_path = safe_path(output_dir / "DecodeLabs_Project1_Quality_Report.xlsx")
    change_path = safe_path(output_dir / "DecodeLabs_Project1_Change_Log.xlsx")

    with pd.ExcelWriter(cleaned_path, engine="openpyxl", date_format="yyyy-mm-dd") as writer:
        cleaned.to_excel(writer, sheet_name="Cleaned_Data", index=False)
        format_sheet(writer, "Cleaned_Data")
        ws = writer.sheets["Cleaned_Data"]

        date_col = cleaned.columns.get_loc("Date") + 1
        for row in ws.iter_rows(min_row=2, min_col=date_col, max_col=date_col):
            row[0].number_format = "yyyy-mm-dd"

        for col in PRICE_COLUMNS:
            col_num = cleaned.columns.get_loc(col) + 1
            for row in ws.iter_rows(min_row=2, min_col=col_num, max_col=col_num):
                row[0].number_format = "0.00"

    profile = create_profile(raw, cleaned)
    overall_status = "PASS" if not (quality["Status"] == "FAIL").any() else "FAIL"

    summary = pd.DataFrame([
        ["Source Rows", len(raw)],
        ["Cleaned Rows", len(cleaned)],
        ["Rows Removed", len(raw) - len(cleaned)],
        ["Missing Cells After Cleaning", int(cleaned.isna().sum().sum())],
        ["Duplicate OrderID", int(cleaned["OrderID"].duplicated().sum())],
        ["Duplicate TrackingNumber", int(cleaned["TrackingNumber"].duplicated().sum())],
        ["Overall Quality Gate", overall_status],
    ], columns=["Metric", "Value"])

    with pd.ExcelWriter(quality_path, engine="openpyxl") as writer:
        summary.to_excel(writer, sheet_name="Summary", index=False)
        quality.to_excel(writer, sheet_name="Quality_Checks", index=False)
        profile.to_excel(writer, sheet_name="Column_Profile", index=False)

        format_sheet(writer, "Summary")
        format_sheet(writer, "Quality_Checks")
        format_sheet(writer, "Column_Profile")

    pd.DataFrame(changes).to_excel(change_path, sheet_name="Change_Log", index=False)

    print("\nFiles created:")
    print(f"  {cleaned_path}")
    print(f"  {quality_path}")
    print(f"  {change_path}")


def main():
    parser = argparse.ArgumentParser(description="DecodeLabs Project 1 data cleaning pipeline")
    parser.add_argument("input_file", nargs="?", default=str(DEFAULT_INPUT))
    parser.add_argument("--output-dir", default=str(DEFAULT_OUTPUT))
    args = parser.parse_args()

    input_file = Path(args.input_file)
    output_dir = Path(args.output_dir)

    print("DecodeLabs Project 1")
    print("Data Cleaning & Preparation")
    print(f"\nInput file:\n{input_file}")

    raw = load_data(input_file)
    print(f"\nLoaded: {len(raw):,} rows x {raw.shape[1]} columns")

    cleaned, changes = clean_data(raw)
    quality = validate_data(cleaned)
    save_results(raw, cleaned, quality, changes, output_dir)

    print("FINAL QUALITY CHECK")
    print(quality[["Check", "Result", "Status"]].to_string(index=False))

    failed = quality[quality["Status"] == "FAIL"]
    if failed.empty:
        print("OVERALL STATUS: PASS")
        print("Dataset is ready for submission.")
    else:
        print("OVERALL STATUS: FAIL")
        print("Review the quality report.")


if __name__ == "__main__":
    main()