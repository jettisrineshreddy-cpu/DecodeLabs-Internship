# DecodeLabs – Data Analytics Internship

This repository contains the projects I completed as part of the DecodeLabs Data Analytics Industrial Training Program.

The projects are based on an e-commerce dataset and focus on preparing the data, exploring it, and extracting useful observations from it.

## Projects

### Project 1 – Data Cleaning & Preparation

The first project focused on making the raw dataset reliable enough for further analysis.

#### What I worked on

- Checked the dataset structure and data types
- Identified missing values
- Handled missing `CouponCode` values
- Checked and removed exact duplicate records
- Validated `OrderID`, `CustomerID`, and `TrackingNumber`
- Standardized the date column
- Validated numerical columns
- Checked for invalid or non-positive values
- Verified the relationship between `Quantity`, `UnitPrice`, and `TotalPrice`
- Created a data quality report and change log

One important decision during cleaning was not to remove repeated `CustomerID` values. A customer can place multiple orders, so repeated customer IDs are valid in this dataset.

#### Tools Used

- Python
- Pandas
- NumPy
- Excel
- Jupyter Notebook / VS Code

---

### Project 2 – Exploratory Data Analysis

The second project focused on understanding the cleaned dataset and finding patterns, trends, distributions, and unusual observations.

#### Analysis covered

- Descriptive statistics
- Mean, median, count, minimum and maximum
- Distribution analysis
- Mean vs. median comparison
- Product-level analysis
- Payment method analysis
- Order status analysis
- Referral source analysis
- Monthly order and revenue trends
- Outlier detection using the IQR method
- Investigation of high-value orders
- Correlation analysis
- Relationship between quantity, unit price, items in cart, and total price
- Group-level comparisons
- Statistical testing
- Business-oriented interpretation of findings

The analysis was not limited to generating charts. I also looked at what the results actually meant and whether unusual values represented errors or valid business cases.

For example, eight `TotalPrice` values were identified as statistical outliers using the IQR method. They were retained because the corresponding orders were internally consistent and there was no evidence that they were data-entry errors.

## Key Findings

Some of the observations from the EDA include:

- `TotalPrice` is right-skewed, with the mean higher than the median.
- Unit price has the strongest linear relationship with total price among the main numerical variables.
- Quantity also has a noticeable relationship with total price.
- Product categories show differences in order volume and total revenue.
- Order status has a significant effect on the interpretation of revenue because cancelled and returned orders should not be treated in the same way as completed orders.
- A small number of high-value orders have a noticeable effect on the overall distribution.

The analysis also highlights an important point: correlation shows association between variables, but it does not by itself establish causation.

## Project Structure

```text
DecodeLabs-Data-Analytics/
│
├── Project_1/
│   ├── project1decodelabs.py
│   ├── Dataset for Data Analytics.xlsx
│   ├── DecodeLabs_Project1_Cleaned.xlsx
│   ├── DecodeLabs_Project1_Quality_Report.xlsx
│   └── DecodeLabs_Project1_Change_Log.xlsx
│
├── Project_2/
│   ├── Project_2_EDA.ipynb
│   └── figures/
│
└── README.md
