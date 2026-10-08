# Project 3 — SQL Data Analysis

This is the third project of my **DecodeLabs Data Analytics Industrial Training Program – Batch 2026**.

In this project, I used SQL Server to analyze an e-commerce dataset and find useful information about orders, products, customers, order status, payments, referrals and sales trends.

The main idea was to take the transaction data and use SQL queries to answer simple business questions instead of just looking at the raw data.

## Objective

The main objectives of this project were to:

- Check the quality of the data before analysis
- Understand the overall order performance
- Compare products and their order values
- Analyze cancelled and returned orders
- Look at monthly and yearly trends
- Identify high-value and repeat customers
- Compare payment methods and referral sources
- Analyze coupon usage
- Understand order and basket patterns

## Dataset

The dataset contains e-commerce order information including:

- Order ID
- Date
- Customer ID
- Product
- Quantity
- Unit Price
- Total Price
- Payment Method
- Order Status
- Tracking Number
- Items in Cart
- Coupon Code
- Referral Source
- Shipping Address

There are **1,200 orders**, **1,189 unique customers**, and **7 products** in the dataset.

## Tools Used

- SQL Server
- SQL Server Management Studio (SSMS)

## What I Analyzed

### Data Quality

Before starting the analysis, I checked the dataset for:

- Duplicate Order IDs
- Missing values in important columns
- Differences between `Quantity × UnitPrice` and `TotalPrice`

The checks did not find duplicate orders, missing values in the checked fields, or mismatched order totals.

### Overall Business Performance

I calculated the main numbers such as:

- Total orders
- Unique customers
- Total units sold
- Total order value
- Average order value

### Product Analysis

I compared the products based on:

- Number of orders
- Units sold
- Total order value
- Average order value
- Percentage contribution to total order value
- Revenue ranking

### Order Status

I looked at the different order statuses and calculated:

- Number of orders
- Order value
- Average order value
- Cancellation and return rates
- Product-level cancellation/return rates
- Fulfilled order value

### Time Analysis

I analyzed the data by year and month to find:

- Yearly order value
- Monthly order value
- Highest-value month
- Cumulative order value

### Customer Analysis

I used SQL to find:

- Top customers by order value
- Customers with more than one order
- Contribution from repeat customers

### Payment and Referral Analysis

I compared different payment methods and referral sources based on their order value and number of orders.

### Coupon Analysis

I analyzed coupon usage and compared the average order value of different coupon groups.

### Order Value Analysis

I divided orders into different value groups:

- Low Value
- Medium Value
- High Value
- Very High Value

This helped me understand how much of the total order value came from higher-value orders.

### Yearly Product Performance

I used window functions to find the highest-value product for each year.

### Basket Analysis

I compared the purchased quantity with the number of items recorded in the cart to understand some basic basket patterns.

## Key Findings

Some of the main findings from the SQL analysis were:

- There are **1,200 orders from 1,189 unique customers** across 7 products.
- Total order value is **₹12,64,761.96** and the average order value is **₹1,053.97**.
- **Chair** had the highest overall order value at **₹1,95,620.11**, closely followed by Printer.
- **41.42% of orders were Cancelled or Returned**, which stood out as one of the main issues in the analysis.
- **Monitor** had the highest cancellation/return rate at **43.56%**, followed by Tablet at **43.02%**.
- **June 2024** was the highest-value month, with **₹68,068.54** from 53 orders.
- Repeat customers contributed **1.54% of total order value**, showing that there is room to improve repeat purchases.
- **Instagram** generated the highest order value among the referral sources at **₹2,75,285.45**.
- **FREESHIP** was the most-used coupon, with **313 orders**.
- There were **94 Very High Value orders**, contributing approximately **₹2,69,712.94**.
- The top product changed across the years: **Printer in 2023, Chair in 2024, and Desk in 2025**.
- **200 orders (16.67%)** had the purchased quantity equal to the recorded number of items in the cart.

## Business Recommendations

Based on the results, a few areas that could be looked at further are:

1. Find out why such a large number of orders were cancelled or returned.
2. Investigate the high cancellation/return rates of products such as Monitor and Tablet.
3. Focus on strategies that encourage existing customers to make repeat purchases.
4. Compare referral sources not only by order value but also by order quality and cancellation/return behavior.
5. Use the yearly product trends when planning inventory and promotions.
6. Identify high-value customers and consider personalized offers or cross-selling.
7. Evaluate coupon campaigns based on their overall order performance rather than just the number of times they were used.

## SQL Concepts Used

During this project, I worked with:

- `SELECT`
- `WHERE`
- `ORDER BY`
- `GROUP BY`
- `HAVING`
- `COUNT()`
- `SUM()`
- `AVG()`
- `CASE`
- Subqueries
- CTEs
- Window Functions
- `RANK()`
- `ROW_NUMBER()`
- Date-based analysis

## Project Files

```text
Project3_SQL/
│
├── README.md
├── project3_analysis.sql
├── Project3_All_Query_Results.rpt
├── Project3_SQL_Report.pdf
└── screenshots/
