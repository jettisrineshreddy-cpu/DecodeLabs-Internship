# Project 2 — Exploratory Data Analysis

This is the second project I completed as part of the **DecodeLabs Data Analytics Industrial Training Program – Batch 2026**.

In this project, I explored the e-commerce dataset to understand how the data was distributed, how different products performed, how order values changed over time, and whether there were any noticeable patterns or unusual values.

The main focus was not just creating charts, but trying to understand what the numbers were saying.

## Objective

The main objectives of this project were to:

- Understand the structure of the dataset
- Calculate basic descriptive statistics
- Study the distribution of important numerical variables
- Compare products and their performance
- Analyze order trends over time
- Identify unusual values and outliers
- Study relationships between numerical variables
- Compare different groups in the dataset
- Find useful observations from the analysis
- Convert the findings into simple business recommendations

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

The dataset contains **1,200 orders** across **7 products**.

The cleaned dataset from Project 1 was used as the starting point for this analysis.

## Tools Used

- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- Jupyter Notebook

## Analysis Performed

### 1. Descriptive Statistics

I calculated basic statistics such as:

- Count
- Mean
- Median
- Minimum
- Maximum
- Standard deviation
- Quartiles

These helped me understand the general characteristics of the numerical columns.

### 2. Distribution Analysis

I looked at the distributions of important numerical variables such as:

- Quantity
- Unit Price
- Total Price
- Items in Cart

This helped identify how the values were spread and whether they were skewed.

### 3. Product Analysis

I compared the products based on:

- Number of orders
- Total order value
- Average order value
- Order contribution

This helped identify which products were contributing more to the overall order value.

### 4. Order Status Analysis

I compared the different order statuses to understand how orders were distributed across:

- Delivered
- Shipped
- Pending
- Cancelled
- Returned

This also helped identify the importance of cancelled and returned orders in the dataset.

### 5. Monthly Trend Analysis

I grouped the data by month to see how order value changed over time.

The analysis helped identify stronger and weaker periods and provided a better understanding of the overall trend in the dataset.

### 6. Outlier Analysis

I used the **Interquartile Range (IQR)** method to identify potential outliers.

The outliers were then reviewed rather than automatically removed. Values that represented legitimate orders were retained because an unusual value does not necessarily mean that the data is incorrect.

### 7. Correlation Analysis

I checked the relationships between numerical variables to understand how they were related.

Some of the relationships observed included:

- Unit Price and Total Price
- Quantity and Total Price
- Items in Cart and Total Price
- Quantity and Items in Cart

### 8. Group Comparisons

I compared order values across different groups in the dataset to understand whether there were noticeable differences between them.

### 9. Statistical Analysis

ANOVA was also used to check whether differences between selected groups were statistically meaningful.

The statistical results were interpreted along with the actual business context rather than looking at the numbers in isolation.

## Key Findings

Some of the main observations from the analysis were:

- The average order value was approximately **₹1,053.97**, while the median was approximately **₹823.62**.
- The order value distribution was **right-skewed**, meaning a smaller number of high-value orders increased the average.
- **Chair** had the highest total order value at approximately **₹1,95,620.11**.
- **Printer** was very close to Chair, with approximately **₹1,95,612.61** in order value.
- Quantity and Total Price showed a positive relationship, with a correlation of approximately **0.615**.
- Unit Price and Total Price had a stronger positive relationship, with a correlation of approximately **0.717**.
- Quantity and Items in Cart also showed a noticeable positive relationship, with a correlation of approximately **0.650**.
- Items in Cart and Total Price had a weaker positive relationship of approximately **0.393**.
- The IQR analysis identified some high-value orders as statistical outliers, but these were reviewed and retained because they appeared to be valid transactions.
- The analysis showed differences in order values across products and order-related groups, which provided areas for further investigation.

## Business Observations

Based on the EDA, a few areas stood out:

1. High-value orders have a noticeable effect on the overall average order value, so the median should also be considered when describing typical customer orders.
2. Product-level performance is relatively different, with Chair and Printer contributing the highest order values.
3. The relationship between quantity and total order value suggests that larger purchases generally contribute to higher order values.
4. The strong relationship between Unit Price and Total Price is expected because unit price directly contributes to the total order value.
5. Outliers should not automatically be removed. Some unusually large orders can represent genuine customer purchases.
6. The differences between groups can be investigated further using statistical tests such as ANOVA.

## Recommendations

Based on the analysis, the following actions could be considered:

- Monitor high-value orders separately when evaluating typical customer spending.
- Study the reasons behind strong performance of products such as Chair and Printer.
- Use product-level performance when planning inventory and promotions.
- Investigate the characteristics of high-value orders to understand what drives larger purchases.
- Continue monitoring unusual transactions while avoiding unnecessary removal of valid data.
- Combine EDA results with customer and order-status analysis for deeper business insights.

## What I Learned

This project helped me understand that EDA is more than calculating averages and creating graphs.

I learned how to:

- Explore a dataset before making conclusions
- Use descriptive statistics to understand data
- Create and interpret visualizations
- Identify and investigate outliers
- Study relationships using correlation
- Compare different groups
- Use statistical tests such as ANOVA
- Connect numerical findings with business questions

## Project Files

```text
Project2_EDA/
│
├── README.md
├── Project2_EDA.ipynb
├── visualizations/
└── documentation/
    └── Project2_EDA_Report.pdf
