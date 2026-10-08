# Project 2 — Exploratory Data Analysis

This is the second project I completed as part of the **DecodeLabs Data Analytics Industrial Training Program — Batch 2026**.

For this project, I explored an e-commerce dataset to understand what was happening in the orders before moving on to deeper analysis.

I looked at distributions, product performance, trends, outliers, correlations and differences between groups. The main goal was not just to create charts, but to ask **"What does this actually tell us?"**

## Dataset

The dataset contains **1,200 e-commerce orders and 14 columns**, covering the period from **January 2023 to June 2025**.

Some of the main columns are:

- Order ID
- Date
- Customer ID
- Product
- Quantity
- Unit Price
- Total Price
- Payment Method
- Order Status
- Items in Cart
- Coupon Code
- Referral Source
- Shipping Address
- Tracking Number

The cleaned dataset from **Project 1** was used as the starting point for this analysis.

## Tools Used

- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- SciPy
- Jupyter Notebook

## What I Did

### 1. Data Understanding and Quality Checks

I started by checking the structure of the dataset, data types, missing values and duplicates.

There were **309 blank CouponCode values**. Instead of treating these as missing information, I interpreted them as orders where no coupon was used and labelled them as `No Coupon`.

After this:

- No missing values remained
- No duplicate rows were found
- No duplicate Order IDs were found
- `TotalPrice = Quantity × UnitPrice` for every order
- `ItemsInCart >= Quantity` for every order

These checks were important because some of the relationships found later are directly affected by how these columns are defined.

## 2. Descriptive Statistics

I calculated statistics such as:

- Count
- Mean
- Median
- Minimum
- Maximum
- Quartiles
- Standard deviation
- Skewness

One of the main observations was that `TotalPrice` is right-skewed.

The:

- Mean order value was about **₹1,054**
- Median order value was about **₹824**

This means the average is being pulled upward by higher-value orders, so the median gives a better idea of what a typical order looks like.

## 3. Distribution Analysis

I used histograms to look at:

- Quantity
- Unit Price
- Items in Cart
- Total Price

Quantity and cart size were fairly evenly distributed, while Total Price had a noticeable right tail.

One useful thing I found here was that the TotalPrice distribution is partly explained by the way the data is constructed:

`TotalPrice = Quantity × UnitPrice`

So the strong relationships between these variables should not automatically be treated as a business discovery.

## 4. Categorical Analysis

I compared the distribution of:

- Products
- Payment Methods
- Order Status
- Coupon Codes
- Referral Sources

Most categories were fairly evenly distributed.

The main exception was Order Status:

**Cancelled + Returned orders made up 41.4% of all orders.**

That became one of the main areas I looked at more closely later in the analysis.

## 5. Time Analysis

I grouped the orders by month and looked at both order count and order value.

Some of the main observations were:

- June was the strongest month in the dataset.
- January–June contributed around **61% of total order value**.
- The second half of the year was generally weaker.
- Comparing January–June across years showed that H1 order value declined from roughly **₹286k in 2023 → ₹257k in 2024 → ₹232k in 2025**.

Since 2025 only contains data up to June, I compared January–June across the years instead of comparing incomplete 2025 data with full-year figures.

With only about 2.5 years of data, I treat this as a pattern worth investigating rather than calling it a confirmed seasonal cycle.

## 6. Outlier Analysis

I used the **IQR method** to identify unusually high-value orders.

There were **8 high-value outliers** above the upper IQR limit.

After checking them, I found that they were not obvious data errors. They were all orders with:

- Quantity = 5
- Unit Price around ₹667–₹691

The values were consistent with the rest of the dataset, so I kept them instead of removing them.

One interesting observation was that **4 of these 8 high-value orders were Cancelled or Returned**.

## 7. Correlation Analysis

I used a correlation matrix and scatter plots to study relationships between numerical variables.

Some of the correlations were:

- Unit Price ↔ Total Price: **0.717**
- Quantity ↔ Total Price: **0.615**
- Quantity ↔ Items in Cart: **0.650**
- Items in Cart ↔ Total Price: **0.393**
- Unit Price ↔ Quantity: **0.015**

The important part here was not simply finding a high correlation.

Since:

`TotalPrice = Quantity × UnitPrice`

the correlation between Unit Price, Quantity and Total Price is partly mechanical.

The more interesting result was that **Unit Price and Quantity were almost uncorrelated (r ≈ 0.02)** in this dataset.

## 8. Relationship and Group Analysis

I compared order value across:

- Products
- Payment Methods
- Order Status
- Coupon usage
- Referral Sources

I also used ANOVA to check whether differences between groups were statistically significant.

### Product

Chair and Printer were almost tied for the highest total order value.

- Chair: approximately **₹195.6k**
- Printer: approximately **₹195.6k**

However, the ANOVA result gave **p = 0.62**, so the differences in average order value between products were not statistically significant.

### Payment Method

Credit Card had the highest average order value at around **₹1,128**, while Debit Card was around **₹1,002**.

However, the ANOVA result gave **p = 0.49**, so payment method did not meaningfully explain order value in this dataset.

### Order Status

This was the strongest business finding.

The dataset contains about **₹1.265M in gross order value**, but:

- Around **₹519.7k (41%)** was in Cancelled or Returned orders
- Around **₹488.8k (39%)** was in Delivered or Shipped orders
- Around **₹256.3k (20%)** was Pending

The cancellation/return issue was not limited to one product. Every product had a cancellation/return rate above roughly 39%.

This suggests that the issue may be related to the wider ordering, fulfilment or returns process rather than one specific product.

### Coupons and Referral Sources

Coupon users and non-coupon users had fairly similar average order values.

The dataset does not contain discount amounts, so I cannot calculate the actual cost or profitability of the coupon campaigns.

Instagram had the highest order count and order value among the referral sources, but the differences in average order value were not statistically significant.

## Key Takeaways

The main things I took away from the analysis were:

1. **Cancelled and Returned orders are a major issue**, representing about 41% of gross order value.
2. **The average order value is higher than the median**, so high-value orders are pulling the average upward.
3. The high-value outliers appear to be **valid orders rather than data errors**, but some of them were also Cancelled or Returned.
4. **June is the strongest month**, while the second half of the year is generally weaker.
5. **H1 order value declined across the three years** when comparing January–June on a like-for-like basis.
6. Product differences exist in total order value, but the statistical test did not show a significant difference in average order value.
7. Payment method, coupon usage and referral source did not show statistically significant differences in average order value.
8. Some strong correlations in the data are mechanical because of how `TotalPrice` and `ItemsInCart` are defined.
9. No single product dominates the business; product shares are relatively close to each other.
10. The analysis shows that understanding **how a metric is constructed** is just as important as calculating the metric itself.

## Business Recommendations

Based on what the analysis showed, I would focus on:

- Investigating why such a large share of orders are Cancelled or Returned.
- Looking at the checkout, fulfilment and returns process rather than blaming one particular product.
- Tracking cancellation reasons in future datasets, since the current dataset does not contain a reason column.
- Using median order value along with the mean when reporting typical customer spending.
- Planning inventory and promotions around the stronger first half of the year while investigating the H1 decline.
- Testing pricing, quantity or bundle strategies rather than assuming that one product or channel is automatically better.
- Evaluating coupon campaigns using discount cost and order status, not just coupon usage.
- Using controlled tests before moving significant marketing or business resources based on small group differences.

## Project Files

```text
Project2_EDA/
│
├── README.md
├── Project2_EDA.ipynb
├── visualizations/
└── documentation/
    └── Project2_EDA_Report.pdf
