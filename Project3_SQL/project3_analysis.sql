-- ============================================================
-- PROJECT 3: SQL DATA ANALYSIS
-- DecodeLabs | E-Commerce Dataset
-- ============================================================


-- ============================================================
-- 1. DATA QUALITY CHECKS
-- ============================================================


-- Check for duplicate orders

SELECT
    OrderID,
    COUNT(*) AS DuplicateCount
FROM dbo.DecodeLabs
GROUP BY OrderID
HAVING COUNT(*) > 1;


-- Check missing values in important columns

SELECT
    SUM(CASE WHEN OrderID IS NULL THEN 1 ELSE 0 END) AS MissingOrderID,
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS MissingCustomerID,
    SUM(CASE WHEN Product IS NULL THEN 1 ELSE 0 END) AS MissingProduct,
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS MissingDate,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS MissingQuantity,
    SUM(CASE WHEN UnitPrice IS NULL THEN 1 ELSE 0 END) AS MissingUnitPrice,
    SUM(CASE WHEN TotalPrice IS NULL THEN 1 ELSE 0 END) AS MissingTotalPrice
FROM dbo.DecodeLabs;
 

-- Check whether order totals match Quantity × UnitPrice

SELECT
    OrderID,
    Quantity,
    UnitPrice,
    TotalPrice,
    ROUND(Quantity * UnitPrice, 2) AS ExpectedTotal
FROM dbo.DecodeLabs
WHERE ABS(TotalPrice - (Quantity * UnitPrice)) > 0.01;



-- ============================================================
-- 2. BASIC BUSINESS OVERVIEW
-- ============================================================


-- View a sample of the orders

SELECT TOP 10
    OrderID,
    Date,
    Product,
    Quantity,
    UnitPrice,
    TotalPrice
FROM dbo.DecodeLabs;


-- Overall business performance

SELECT
    COUNT(*) AS [Total Orders],
    COUNT(DISTINCT CustomerID) AS [Unique Customers],
    COUNT(DISTINCT Product) AS [Products],
    SUM(Quantity) AS [Units Sold],
    ROUND(SUM(TotalPrice), 2) AS [Total Order Value],
    ROUND(AVG(TotalPrice), 2) AS [Avg Order Value]
FROM dbo.DecodeLabs;


-- Highest-value delivered orders

SELECT TOP 10
    OrderID,
    Date,
    Product,
    Quantity,
    TotalPrice
FROM dbo.DecodeLabs
WHERE OrderStatus = 'Delivered'
ORDER BY TotalPrice DESC;



-- ============================================================
-- 3. PRODUCT ANALYSIS
-- ============================================================


-- Product performance

SELECT
    Product,
    COUNT(*) AS [Orders],
    SUM(Quantity) AS [Units Sold],
    ROUND(SUM(TotalPrice), 2) AS [Revenue],
    ROUND(AVG(TotalPrice), 2) AS [Avg Order Value]
FROM dbo.DecodeLabs
GROUP BY Product
ORDER BY [Revenue] DESC;


-- Product contribution to total order value

SELECT
    Product,
    ROUND(SUM(TotalPrice), 2) AS [Revenue],
    ROUND(
        100.0 * SUM(TotalPrice) /
        (SELECT SUM(TotalPrice)
         FROM dbo.DecodeLabs),
        2
    ) AS [Revenue %]
FROM dbo.DecodeLabs
GROUP BY Product
ORDER BY [Revenue %] DESC;


-- Rank products by revenue

SELECT
    Product,
    ROUND(SUM(TotalPrice), 2) AS [Revenue],
    RANK() OVER (
        ORDER BY SUM(TotalPrice) DESC
    ) AS [Revenue Rank]
FROM dbo.DecodeLabs
GROUP BY Product
ORDER BY [Revenue Rank];


-- Which product has the highest average order value?

SELECT TOP 1
    Product,
    ROUND(AVG(TotalPrice), 2) AS [Avg Order Value]
FROM dbo.DecodeLabs
GROUP BY Product
ORDER BY [Avg Order Value] DESC;



-- ============================================================
-- 4. ORDER STATUS ANALYSIS
-- ============================================================


-- Orders and order value by status

SELECT
    OrderStatus,
    COUNT(*) AS [Orders],
    ROUND(SUM(TotalPrice), 2) AS [Order Value],
    ROUND(AVG(TotalPrice), 2) AS [Avg Order Value]
FROM dbo.DecodeLabs
GROUP BY OrderStatus
ORDER BY [Orders] DESC;


-- What percentage of orders are cancelled or returned?

SELECT
    COUNT(*) AS [Total Orders],

    SUM(
        CASE
            WHEN OrderStatus IN ('Cancelled', 'Returned')
            THEN 1
            ELSE 0
        END
    ) AS [Cancelled or Returned],

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN OrderStatus IN ('Cancelled', 'Returned')
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS [Loss Rate %]

FROM dbo.DecodeLabs;


-- Product-level cancellation and return rate

SELECT
    Product,
    COUNT(*) AS [Orders],

    SUM(
        CASE
            WHEN OrderStatus IN ('Cancelled', 'Returned')
            THEN 1
            ELSE 0
        END
    ) AS [Cancelled or Returned],

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN OrderStatus IN ('Cancelled', 'Returned')
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS [Loss Rate %]

FROM dbo.DecodeLabs
GROUP BY Product
ORDER BY [Loss Rate %] DESC;


-- Order value from shipped and delivered orders

SELECT
    Product,
    COUNT(*) AS [Orders],
    ROUND(SUM(TotalPrice), 2) AS [Fulfilled Order Value]
FROM dbo.DecodeLabs
WHERE OrderStatus IN ('Shipped', 'Delivered')
GROUP BY Product
ORDER BY [Fulfilled Order Value] DESC;



-- ============================================================
-- 5. TIME ANALYSIS
-- ============================================================


-- Yearly performance

SELECT
    YEAR(Date) AS [Year],
    COUNT(*) AS [Orders],
    ROUND(SUM(TotalPrice), 2) AS [Order Value],
    ROUND(AVG(TotalPrice), 2) AS [Avg Order Value]
FROM dbo.DecodeLabs
GROUP BY YEAR(Date)
ORDER BY [Year];


-- Monthly performance

SELECT
    YEAR(Date) AS [Year],
    MONTH(Date) AS [Month],
    COUNT(*) AS [Orders],
    ROUND(SUM(TotalPrice), 2) AS [Order Value]
FROM dbo.DecodeLabs
GROUP BY
    YEAR(Date),
    MONTH(Date)
ORDER BY
    [Year],
    [Month];


-- Highest revenue month

SELECT TOP 1
    YEAR(Date) AS [Year],
    MONTH(Date) AS [Month],
    COUNT(*) AS [Orders],
    ROUND(SUM(TotalPrice), 2) AS [Revenue]
FROM dbo.DecodeLabs
GROUP BY
    YEAR(Date),
    MONTH(Date)
ORDER BY [Revenue] DESC;


-- Cumulative order value by month

WITH MonthlySales AS
(
    SELECT
        YEAR(Date) AS [Year],
        MONTH(Date) AS [Month],
        SUM(TotalPrice) AS Revenue
    FROM dbo.DecodeLabs
    GROUP BY
        YEAR(Date),
        MONTH(Date)
)
SELECT
    [Year],
    [Month],
    ROUND(Revenue, 2) AS [Monthly Revenue],
    ROUND(
        SUM(Revenue) OVER (
            ORDER BY [Year], [Month]
        ),
        2
    ) AS [Cumulative Revenue]
FROM MonthlySales
ORDER BY
    [Year],
    [Month];



-- ============================================================
-- 6. CUSTOMER ANALYSIS
-- ============================================================


-- Top customers by spending

SELECT TOP 10
    CustomerID,
    COUNT(*) AS [Orders],
    ROUND(SUM(TotalPrice), 2) AS [Total Spent],
    ROUND(AVG(TotalPrice), 2) AS [Avg Order Value]
FROM dbo.DecodeLabs
GROUP BY CustomerID
ORDER BY [Total Spent] DESC;


-- Customers with more than one order

SELECT
    CustomerID,
    COUNT(*) AS [Orders],
    ROUND(SUM(TotalPrice), 2) AS [Total Spent]
FROM dbo.DecodeLabs
GROUP BY CustomerID
HAVING COUNT(*) > 1
ORDER BY [Total Spent] DESC;


-- Revenue contribution from repeat customers

WITH CustomerOrders AS
(
    SELECT
        CustomerID,
        COUNT(*) AS Orders,
        SUM(TotalPrice) AS TotalSpent
    FROM dbo.DecodeLabs
    GROUP BY CustomerID
)
SELECT
    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN Orders > 1 THEN TotalSpent
                ELSE 0
            END
        ) / SUM(TotalSpent),
        2
    ) AS [Repeat Customer Revenue %]
FROM CustomerOrders;



-- ============================================================
-- 7. PAYMENT & REFERRAL ANALYSIS
-- ============================================================


-- Payment method performance

SELECT
    PaymentMethod,
    COUNT(*) AS [Orders],
    ROUND(SUM(TotalPrice), 2) AS [Revenue],
    ROUND(AVG(TotalPrice), 2) AS [Avg Order Value]
FROM dbo.DecodeLabs
GROUP BY PaymentMethod
ORDER BY [Revenue] DESC;


-- Referral source performance

SELECT
    ReferralSource,
    COUNT(*) AS [Orders],
    ROUND(SUM(TotalPrice), 2) AS [Revenue],
    ROUND(AVG(TotalPrice), 2) AS [Avg Order Value]
FROM dbo.DecodeLabs
GROUP BY ReferralSource
ORDER BY [Revenue] DESC;


-- Revenue contribution by referral source

SELECT
    ReferralSource,
    ROUND(SUM(TotalPrice), 2) AS [Revenue],
    ROUND(
        100.0 * SUM(TotalPrice) /
        (SELECT SUM(TotalPrice)
         FROM dbo.DecodeLabs),
        2
    ) AS [Revenue %]
FROM dbo.DecodeLabs
GROUP BY ReferralSource
ORDER BY [Revenue %] DESC;



-- ============================================================
-- 8. COUPON ANALYSIS
-- ============================================================


-- Coupon performance

SELECT
    CouponCode,
    COUNT(*) AS [Orders],
    ROUND(SUM(TotalPrice), 2) AS [Revenue],
    ROUND(AVG(TotalPrice), 2) AS [Avg Order Value]
FROM dbo.DecodeLabs
GROUP BY CouponCode
ORDER BY [Orders] DESC;


-- Compare coupon groups with the overall average order value

SELECT
    CouponCode,
    COUNT(*) AS [Orders],
    ROUND(AVG(TotalPrice), 2) AS [Avg Order Value]
FROM dbo.DecodeLabs
GROUP BY CouponCode
HAVING AVG(TotalPrice) >
       (SELECT AVG(TotalPrice)
        FROM dbo.DecodeLabs)
ORDER BY [Avg Order Value] DESC;



-- ============================================================
-- 9. CUSTOMER / ORDER VALUE ANALYSIS
-- ============================================================


-- Group orders by order value

SELECT
    CASE
        WHEN TotalPrice < 500 THEN 'Low Value'
        WHEN TotalPrice < 1500 THEN 'Medium Value'
        WHEN TotalPrice < 2500 THEN 'High Value'
        ELSE 'Very High Value'
    END AS [Order Category],

    COUNT(*) AS [Orders],
    ROUND(SUM(TotalPrice), 2) AS [Revenue],
    ROUND(AVG(TotalPrice), 2) AS [Avg Order Value]

FROM dbo.DecodeLabs

GROUP BY
    CASE
        WHEN TotalPrice < 500 THEN 'Low Value'
        WHEN TotalPrice < 1500 THEN 'Medium Value'
        WHEN TotalPrice < 2500 THEN 'High Value'
        ELSE 'Very High Value'
    END

ORDER BY [Orders] DESC;



-- ============================================================
-- 10. PRODUCT PERFORMANCE BY YEAR
-- ============================================================


-- Highest-revenue product in each year

WITH ProductSales AS
(
    SELECT
        YEAR(Date) AS [Year],
        Product,
        SUM(TotalPrice) AS Revenue
    FROM dbo.DecodeLabs
    GROUP BY
        YEAR(Date),
        Product
),
RankedProducts AS
(
    SELECT
        [Year],
        Product,
        Revenue,
        ROW_NUMBER() OVER (
            PARTITION BY [Year]
            ORDER BY Revenue DESC
        ) AS ProductRank
    FROM ProductSales
)
SELECT
    [Year],
    Product,
    ROUND(Revenue, 2) AS [Revenue]
FROM RankedProducts
WHERE ProductRank = 1
ORDER BY [Year];



-- ============================================================
-- 11. BASKET ANALYSIS
-- ============================================================


-- Compare quantity ordered with items already in the cart

SELECT
    Product,
    COUNT(*) AS [Orders],
    ROUND(AVG(CAST(Quantity AS FLOAT)), 2) AS [Avg Quantity],
    ROUND(AVG(CAST(ItemsInCart AS FLOAT)), 2) AS [Avg Items In Cart]
FROM dbo.DecodeLabs
GROUP BY Product
ORDER BY [Avg Items In Cart] DESC;


-- Orders where the customer purchased all items in the cart

SELECT
    COUNT(*) AS [Orders],
    ROUND(
        100.0 * COUNT(*) /
        (SELECT COUNT(*) FROM dbo.DecodeLabs),
        2
    ) AS [Percentage]
FROM dbo.DecodeLabs
WHERE Quantity = ItemsInCart;



-- ============================================================
-- 12. FINAL SUMMARY
-- ============================================================


-- Overall project summary

SELECT
    COUNT(*) AS [Orders],
    COUNT(DISTINCT CustomerID) AS [Customers],
    COUNT(DISTINCT Product) AS [Products],
    SUM(Quantity) AS [Units Sold],
    ROUND(SUM(TotalPrice), 2) AS [Total Order Value],
    ROUND(AVG(TotalPrice), 2) AS [Avg Order Value],
    ROUND(MIN(TotalPrice), 2) AS [Min Order Value],
    ROUND(MAX(TotalPrice), 2) AS [Max Order Value]
FROM dbo.DecodeLabs;