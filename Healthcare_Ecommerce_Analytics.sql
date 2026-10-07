-- ============================================================
-- APOLLO HEALTHCARE & E-PHARMACY SALES ANALYTICS
-- ============================================================
-- Tools: MySQL
-- Dataset: Synthetic / Simulated Healthcare E-Commerce Data
-- Records: 8,000 Transactions
-- Period: 2024-01-01 to 2025-12-31
--
-- Project Purpose:
-- Data validation, transformation, KPI analysis,
-- customer analysis, product/category analysis,
-- order-risk analysis and final validation.
--
-- Note:
-- This project is created for educational and portfolio purposes.
-- It does not contain real Apollo customer or business data.
-- ============================================================
-- 01. DATABASE & TABLE SETUP
-- ============================================================

CREATE DATABASE APOLLO_HEALTHCARE;
USE APOLLO_HEALTHCARE;
SELECT DATABASE ();
CREATE TABLE apollo_healthcare (
    Order_ID VARCHAR(20),
    Order_Date DATE,
    Customer_ID VARCHAR(20),
    City VARCHAR(100),
    State VARCHAR(100),
    Pincode INT,
    Medicine_ID VARCHAR(20),
    Medicine_Name VARCHAR(150),
    Category VARCHAR(100),
    Brand VARCHAR(100),
    Prescription_Required VARCHAR(10),
    Quantity INT,
    Unit_Price DECIMAL(10,2),
    Discount_Pct DECIMAL(5,2),
    Tax_Pct DECIMAL(5,2),
    Payment_Mode VARCHAR(50),
    Order_Status VARCHAR(30)
);

-- CHECK DATA TYPE --
DESCRIBE APOLLO_HEALTHCARE;

SELECT COUNT(*) AS total_rows
FROM apollo_healthcare;

-- DATA VERIFICATION--
SELECT *
FROM apollo_healthcare
LIMIT 10;

-- DATE RANGE CHECK --
SELECT
    MIN(Order_Date) AS first_order_date,
    MAX(Order_Date) AS last_order_date
FROM apollo_healthcare;

-- DUPLICATE ORDER ID CHECK --
SELECT
    Order_ID,
    COUNT(*) AS row_count
FROM apollo_healthcare
GROUP BY Order_ID
HAVING COUNT(*) > 1
ORDER BY row_count DESC;

-- DUPLICATE ORDER ID DETAILED CHECK --
SELECT
    Order_ID,
    COUNT(*) AS row_count,
    COUNT(DISTINCT Customer_ID) AS unique_customers,
    COUNT(DISTINCT Order_Date) AS unique_dates,
    COUNT(DISTINCT Medicine_ID) AS unique_medicines
FROM apollo_healthcare
GROUP BY Order_ID
HAVING COUNT(*) > 1
ORDER BY row_count DESC
LIMIT 20;

-- NULL VALUE AUDIT --
SELECT
    SUM(Order_ID IS NULL) AS null_order_id,
    SUM(Order_Date IS NULL) AS null_order_date,
    SUM(Customer_ID IS NULL) AS null_customer_id,
    SUM(City IS NULL) AS null_city,
    SUM(State IS NULL) AS null_state,
    SUM(Pincode IS NULL) AS null_pincode,
    SUM(Medicine_ID IS NULL) AS null_medicine_id,
    SUM(Medicine_Name IS NULL) AS null_medicine_name,
    SUM(Category IS NULL) AS null_category,
    SUM(Brand IS NULL) AS null_brand,
    SUM(Prescription_Required IS NULL) AS null_prescription,
    SUM(Quantity IS NULL) AS null_quantity,
    SUM(Unit_Price IS NULL) AS null_unit_price,
    SUM(Discount_Pct IS NULL) AS null_discount,
    SUM(Tax_Pct IS NULL) AS null_tax,
    SUM(Payment_Mode IS NULL) AS null_payment_mode,
    SUM(Order_Status IS NULL) AS null_order_status
FROM apollo_healthcare;

-- BLANK VALUE AUDIT --
SELECT
    SUM(TRIM(Order_ID) = '') AS blank_order_id,
    SUM(TRIM(Customer_ID) = '') AS blank_customer_id,
    SUM(TRIM(City) = '') AS blank_city,
    SUM(TRIM(State) = '') AS blank_state,
    SUM(TRIM(Medicine_Name) = '') AS blank_medicine_name,
    SUM(TRIM(Category) = '') AS blank_category,
    SUM(TRIM(Brand) = '') AS blank_brand,
    SUM(TRIM(Payment_Mode) = '') AS blank_payment_mode,
    SUM(TRIM(Order_Status) = '') AS blank_order_status
FROM apollo_healthcare;

-- QUANTITY AUDIT --
SELECT
    MIN(Quantity) AS min_quantity,
    MAX(Quantity) AS max_quantity,
    AVG(Quantity) AS avg_quantity
FROM apollo_healthcare;

-- INVALID QUANTITY CHECK --
SELECT *
FROM apollo_healthcare
WHERE Quantity <= 0;

-- UNIT PRICE AUDIT --
SELECT
    MIN(Unit_Price) AS min_price,
    MAX(Unit_Price) AS max_price,
    AVG(Unit_Price) AS avg_price
FROM apollo_healthcare;

-- INVALID PRICE CHECK --
SELECT *
FROM apollo_healthcare
WHERE Unit_Price <= 0;

-- DISCOUNT AUDIT --
SELECT
    MIN(Discount_Pct) AS min_discount,
    MAX(Discount_Pct) AS max_discount
FROM apollo_healthcare;

-- INVALID DISCOUNT CHECK --
SELECT *
FROM apollo_healthcare
WHERE Discount_Pct < 0
   OR Discount_Pct > 100;
   
   -- TAX AUDIT --
   SELECT
    MIN(Tax_Pct) AS min_tax,
    MAX(Tax_Pct) AS max_tax
FROM apollo_healthcare;

-- INVALID TAX CHECK --
SELECT *
FROM apollo_healthcare
WHERE Tax_Pct < 0
   OR Tax_Pct > 100;
 
 -- ORDER STATUS AUDIT --
 SELECT
    Order_Status,
    COUNT(*) AS transactions
FROM apollo_healthcare
GROUP BY Order_Status
ORDER BY transactions DESC;

-- CATEGORY AUDIT --
SELECT
    Category,
    COUNT(*) AS transactions
FROM apollo_healthcare
GROUP BY Category
ORDER BY transactions DESC;

-- PAYMENT MODE AUDIT --
SELECT
    Payment_Mode,
    COUNT(*) AS transactions
FROM apollo_healthcare
GROUP BY Payment_Mode
ORDER BY transactions DESC;

-- PRESCRIPTION AUDIT --
SELECT
    Prescription_Required,
    COUNT(*) AS transactions
FROM apollo_healthcare
GROUP BY Prescription_Required
ORDER BY transactions DESC;

-- MEDICINE ID CONSISTENCY CHECK --
SELECT
    Medicine_ID,
    COUNT(DISTINCT Medicine_Name) AS medicine_names,
    COUNT(DISTINCT Category) AS categories,
    COUNT(DISTINCT Brand) AS brands
FROM apollo_healthcare
GROUP BY Medicine_ID
HAVING COUNT(DISTINCT Medicine_Name) > 1
    OR COUNT(DISTINCT Category) > 1
    OR COUNT(DISTINCT Brand) > 1;
    
-- CITY/STATE CONSISTENCY CHECK --
SELECT
    City,
    COUNT(DISTINCT State) AS unique_states
FROM apollo_healthcare
GROUP BY City
HAVING COUNT(DISTINCT State) > 1
ORDER BY unique_states DESC;

-- PINCODE CONSISTENCY CHECK --
SELECT
    Pincode,
    COUNT(DISTINCT State) AS unique_states,
    COUNT(DISTINCT City) AS unique_cities
FROM apollo_healthcare
GROUP BY Pincode
HAVING COUNT(DISTINCT State) > 1
    OR COUNT(DISTINCT City) > 1
ORDER BY unique_states DESC, unique_cities DESC;

-- CHECK DUPLICATE ORDER IDS IN DETAIL --
SELECT *
FROM apollo_healthcare
WHERE Order_ID = 'ORD105634';

-- CHECK WHETHER ROW-LEVEL COMBINATION IS UNIQUE --
SELECT
    Order_ID,
    Order_Date,
    Customer_ID,
    Medicine_ID,
    COUNT(*) AS duplicate_count
FROM apollo_healthcare
GROUP BY
    Order_ID,
    Order_Date,
    Customer_ID,
    Medicine_ID
HAVING COUNT(*) > 1;

-- CREATE UNIQUE TRANSACTION ID --
ALTER TABLE apollo_healthcare
ADD COLUMN Transaction_ID VARCHAR(100);

-- POPULATE TRANSACTION ID --
UPDATE apollo_healthcare
SET Transaction_ID = CONCAT(
    Order_ID, '_',
    DATE_FORMAT(Order_Date, '%Y%m%d'), '_',
    Customer_ID, '_',
    Medicine_ID
);

-- TRANSACTION ID VERIFICATION --
SELECT
    COUNT(*) AS total_rows,
    COUNT(Transaction_ID) AS transaction_ids,
    COUNT(DISTINCT Transaction_ID) AS unique_transaction_ids
FROM apollo_healthcare;

-- GROSS AMOUNT CHECK --
SELECT
    Transaction_ID,
    Quantity,
    Unit_Price,
    ROUND(Quantity * Unit_Price, 2) AS Gross_Amount
FROM apollo_healthcare
LIMIT 10;

-- ADD GROSS AMOUNT COLUMN --
ALTER TABLE apollo_healthcare
ADD COLUMN Gross_Amount DECIMAL(12,2);

-- POPULATE GROSS AMOUNT --
UPDATE apollo_healthcare
SET Gross_Amount = ROUND(Quantity * Unit_Price, 2);

-- VERIFY GROSS AMOUNT --
SELECT
    COUNT(*) AS total_rows,
    COUNT(Gross_Amount) AS gross_amount_filled,
    MIN(Gross_Amount) AS min_gross_amount,
    MAX(Gross_Amount) AS max_gross_amount
FROM apollo_healthcare;

-- ADD DISCOUNT AMOUNT COLUMN --
ALTER TABLE apollo_healthcare
ADD COLUMN Discount_Amount DECIMAL(12,2);

-- CALCULATE DISCOUNT AMOUNT --
UPDATE apollo_healthcare
SET Discount_Amount = ROUND(
    Gross_Amount * Discount_Pct / 100,
    2
);

-- VERIFY DISCOUNT AMOUNT --
SELECT
    COUNT(*) AS total_rows,
    COUNT(Discount_Amount) AS discount_filled,
    MIN(Discount_Amount) AS min_discount,
    MAX(Discount_Amount) AS max_discount
FROM apollo_healthcare;

-- CREATE NET AMOUNT BEFORE TAX --
ALTER TABLE apollo_healthcare
ADD COLUMN Net_Amount_Before_Tax DECIMAL(12,2);

-- CALCULATE NET AMOUNT BEFORE TAX --
UPDATE apollo_healthcare
SET Net_Amount_Before_Tax = ROUND(
    Gross_Amount - Discount_Amount,
    2
);

-- VERIFY NET AMOUNT BEFORE TAX --
SELECT
    COUNT(*) AS total_rows,
    COUNT(Net_Amount_Before_Tax) AS net_amount_filled,
    MIN(Net_Amount_Before_Tax) AS min_net_amount,
    MAX(Net_Amount_Before_Tax) AS max_net_amount
FROM apollo_healthcare;

-- CREATE TAX AMOUNT COLUMN --
ALTER TABLE apollo_healthcare
ADD COLUMN Tax_Amount DECIMAL(12,2);

-- CALCULATE TAX AMOUNT --
UPDATE apollo_healthcare
SET Tax_Amount = ROUND(
    Net_Amount_Before_Tax * Tax_Pct / 100,
    2
);

-- VERIFY TAX AMOUNT --
SELECT
    COUNT(*) AS total_rows,
    COUNT(Tax_Amount) AS tax_filled,
    MIN(Tax_Amount) AS min_tax,
    MAX(Tax_Amount) AS max_tax
FROM apollo_healthcare;

-- CREATE FINAL AMOUNT  CHECK --
ALTER TABLE apollo_healthcare
ADD COLUMN Final_Amount DECIMAL(12,2);

-- CALCULATE FINAL AMOUNT --
UPDATE apollo_healthcare
SET Final_Amount = ROUND(
    Net_Amount_Before_Tax + Tax_Amount,
    2
);

-- VERIFICATION OFF ALL CALCULATED AMOUNTS --
SELECT
    COUNT(*) AS total_rows,
    COUNT(Gross_Amount) AS gross_filled,
    COUNT(Discount_Amount) AS discount_filled,
    COUNT(Net_Amount_Before_Tax) AS net_filled,
    COUNT(Tax_Amount) AS tax_filled,
    COUNT(Final_Amount) AS final_filled
FROM apollo_healthcare;

-- SQL BUSINESS ANALYSIS --
-- OVERALL SALES SUMMARY --
SELECT
    COUNT(*) AS Total_Transactions,
    COUNT(DISTINCT Customer_ID) AS Total_Customers,
    SUM(Quantity) AS Total_Units_Sold,
    ROUND(SUM(Gross_Amount), 2) AS Total_Gross_Sales,
    ROUND(SUM(Discount_Amount), 2) AS Total_Discount,
    ROUND(SUM(Net_Amount_Before_Tax), 2) AS Net_Sales_Before_Tax,
    ROUND(SUM(Tax_Amount), 2) AS Total_Tax,
    ROUND(SUM(Final_Amount), 2) AS Total_Final_Sales,
    ROUND(AVG(Final_Amount), 2) AS Average_Transaction_Value
FROM apollo_healthcare;

-- REVENUE BY ORDER STATUS --
SELECT
    Order_Status,
    COUNT(*) AS Transactions,
    SUM(Quantity) AS Units_Sold,
    ROUND(SUM(Final_Amount), 2) AS Total_Sales,
    ROUND(AVG(Final_Amount), 2) AS Average_Transaction_Value
FROM apollo_healthcare
GROUP BY Order_Status
ORDER BY Total_Sales DESC;

-- DELIVERED REVENUE --
SELECT
    COUNT(*) AS Delivered_Transactions,
    SUM(Quantity) AS Delivered_Units,
    ROUND(SUM(Gross_Amount), 2) AS Delivered_Gross_Sales,
    ROUND(SUM(Discount_Amount), 2) AS Delivered_Discount,
    ROUND(SUM(Net_Amount_Before_Tax), 2) AS Delivered_Net_Sales,
    ROUND(SUM(Tax_Amount), 2) AS Delivered_Tax,
    ROUND(SUM(Final_Amount), 2) AS Delivered_Final_Sales,
    ROUND(AVG(Final_Amount), 2) AS Delivered_Average_Value
FROM apollo_healthcare
WHERE Order_Status = 'Delivered';

-- CATEGORY PERFORMANCE --
SELECT
    Category,
    COUNT(*) AS Delivered_Transactions,
    SUM(Quantity) AS Units_Sold,
    ROUND(SUM(Final_Amount), 2) AS Delivered_Sales,
    ROUND(AVG(Final_Amount), 2) AS Average_Transaction_Value
FROM apollo_healthcare
WHERE Order_Status = 'Delivered'
GROUP BY Category
ORDER BY Delivered_Sales DESC;

-- TOP 10 MEDICINES BY DELIVERED SALES --
SELECT
    Medicine_Name,
    Category,
    Brand,
    SUM(Quantity) AS Units_Sold,
    COUNT(*) AS Delivered_Transactions,
    ROUND(SUM(Final_Amount), 2) AS Delivered_Sales
FROM apollo_healthcare
WHERE Order_Status = 'Delivered'
GROUP BY
    Medicine_Name,
    Category,
    Brand
ORDER BY Delivered_Sales DESC
LIMIT 10;

-- SALES BY PAYMENT MODE --
SELECT
    Payment_Mode,
    COUNT(*) AS Delivered_Transactions,
    SUM(Quantity) AS Units_Sold,
    ROUND(SUM(Final_Amount), 2) AS Delivered_Sales,
    ROUND(AVG(Final_Amount), 2) AS Average_Transaction_Value
FROM apollo_healthcare
WHERE Order_Status = 'Delivered'
GROUP BY Payment_Mode
ORDER BY Delivered_Sales DESC;

-- SALES BY STATE --
SELECT
    State,
    COUNT(*) AS Delivered_Transactions,
    SUM(Quantity) AS Units_Sold,
    ROUND(SUM(Final_Amount), 2) AS Delivered_Sales,
    ROUND(AVG(Final_Amount), 2) AS Average_Transaction_Value
FROM apollo_healthcare
WHERE Order_Status = 'Delivered'
GROUP BY State
ORDER BY Delivered_Sales DESC;

-- MONTHLY SALES TREND --
SELECT
    DATE_FORMAT(Order_Date, '%Y-%m') AS Sales_Month,
    COUNT(*) AS Delivered_Transactions,
    SUM(Quantity) AS Units_Sold,
    ROUND(SUM(Final_Amount), 2) AS Delivered_Sales
FROM apollo_healthcare
WHERE Order_Status = 'Delivered'
GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
ORDER BY Sales_Month;

-- YEAR-OVER-YEAR PERFORMANCE --
SELECT
    YEAR(Order_Date) AS Sales_Year,
    COUNT(*) AS Delivered_Transactions,
    SUM(Quantity) AS Units_Sold,
    ROUND(SUM(Final_Amount), 2) AS Delivered_Sales,
    ROUND(AVG(Final_Amount), 2) AS Average_Transaction_Value
FROM apollo_healthcare
WHERE Order_Status = 'Delivered'
GROUP BY YEAR(Order_Date)
ORDER BY Sales_Year;

-- CALCULATE YOY GROWTH% --
SELECT
    ROUND(
        (
            SUM(CASE WHEN YEAR(Order_Date) = 2025 THEN Final_Amount ELSE 0 END)
            -
            SUM(CASE WHEN YEAR(Order_Date) = 2024 THEN Final_Amount ELSE 0 END)
        )
        /
        SUM(CASE WHEN YEAR(Order_Date) = 2024 THEN Final_Amount ELSE 0 END)
        * 100,
        2
    ) AS YoY_Sales_Growth_Pct
FROM apollo_healthcare
WHERE Order_Status = 'Delivered'; 

-- FIND TOP 10 CUSTOMERS BY DELIVERED SALES --
SELECT
    Customer_ID,
    COUNT(*) AS Delivered_Transactions,
    SUM(Quantity) AS Units_Sold,
    ROUND(SUM(Final_Amount), 2) AS Delivered_Sales,
    ROUND(AVG(Final_Amount), 2) AS Average_Transaction_Value
FROM apollo_healthcare
WHERE Order_Status = 'Delivered'
GROUP BY Customer_ID
ORDER BY Delivered_Sales DESC
LIMIT 10;

-- CUSTOMER REPEAT PURCHASE ANALYSIS --
SELECT
    Customer_Type,
    COUNT(*) AS Number_of_Customers
FROM (
    SELECT
        Customer_ID,
        CASE
            WHEN COUNT(*) = 1 THEN 'One-Time Customer'
            ELSE 'Repeat Customer'
        END AS Customer_Type
    FROM apollo_healthcare
    WHERE Order_Status = 'Delivered'
    GROUP BY Customer_ID
) AS Customer_Segmentation
GROUP BY Customer_Type
ORDER BY Number_of_Customers DESC;

USE APOLLO_HEALTHCARE;
-- CUSTOMER SEGMENTATION --
SELECT
    Customer_Type,
    COUNT(*) AS Number_of_Customers
FROM (
    SELECT
        Customer_ID,
        CASE
            WHEN COUNT(*) = 1 THEN 'One-Time Customer'
            ELSE 'Repeat Customer'
        END AS Customer_Type
    FROM apollo_healthcare
    WHERE Order_Status = 'Delivered'
    GROUP BY Customer_ID
) AS Customer_Segmentation
GROUP BY Customer_Type
ORDER BY Number_of_Customers DESC;

-- RETURN & CANCELLATION ANALYSIS --
SELECT
    Order_Status,
    COUNT(*) AS Transactions,
    SUM(Quantity) AS Units,
    ROUND(SUM(Final_Amount), 2) AS Sales_Value,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM apollo_healthcare),
        2
    ) AS Transaction_Pct
FROM apollo_healthcare
WHERE Order_Status IN ('Returned', 'Cancelled')
GROUP BY Order_Status
ORDER BY Sales_Value DESC;

-- DISCOUNT IMPACT ANALYSIS --
SELECT
    CASE
        WHEN Discount_Pct = 0 THEN '0% Discount'
        WHEN Discount_Pct <= 5 THEN '1-5% Discount'
        WHEN Discount_Pct <= 10 THEN '6-10% Discount'
        WHEN Discount_Pct <= 15 THEN '11-15% Discount'
        ELSE '16-20% Discount'
    END AS Discount_Band,
    COUNT(*) AS Delivered_Transactions,
    SUM(Quantity) AS Units_Sold,
    ROUND(SUM(Final_Amount), 2) AS Delivered_Sales,
    ROUND(AVG(Final_Amount), 2) AS Average_Transaction_Value
FROM apollo_healthcare
WHERE Order_Status = 'Delivered'
GROUP BY Discount_Band
ORDER BY Delivered_Sales DESC;

-- PRESCRIPTION VS NON-PRESCRIPTION --
SELECT
    Prescription_Required,
    COUNT(*) AS Delivered_Transactions,
    SUM(Quantity) AS Units_Sold,
    ROUND(SUM(Final_Amount), 2) AS Delivered_Sales,
    ROUND(AVG(Final_Amount), 2) AS Average_Transaction_Value
FROM apollo_healthcare
WHERE Order_Status = 'Delivered'
GROUP BY Prescription_Required
ORDER BY Delivered_Sales DESC;

-- FINAL SQL BUSINESS INSIGHTS --
SELECT
    ROUND(SUM(CASE WHEN Order_Status = 'Delivered' THEN Final_Amount ELSE 0 END), 2) AS Delivered_Sales,
    ROUND(SUM(CASE WHEN Order_Status = 'Returned' THEN Final_Amount ELSE 0 END), 2) AS Returned_Value,
    ROUND(SUM(CASE WHEN Order_Status = 'Cancelled' THEN Final_Amount ELSE 0 END), 2) AS Cancelled_Value,
    ROUND(
        SUM(CASE WHEN Order_Status = 'Returned' THEN Final_Amount ELSE 0 END)
        * 100.0 /
        SUM(Final_Amount),
        2
    ) AS Return_Value_Pct,
    ROUND(
        SUM(CASE WHEN Order_Status = 'Cancelled' THEN Final_Amount ELSE 0 END)
        * 100.0 /
        SUM(Final_Amount),
        2
    ) AS Cancellation_Value_Pct,
    ROUND(
        (
            SUM(CASE WHEN YEAR(Order_Date) = 2025 AND Order_Status = 'Delivered'
                     THEN Final_Amount ELSE 0 END)
            -
            SUM(CASE WHEN YEAR(Order_Date) = 2024 AND Order_Status = 'Delivered'
                     THEN Final_Amount ELSE 0 END)
        )
        /
        SUM(CASE WHEN YEAR(Order_Date) = 2024 AND Order_Status = 'Delivered'
                 THEN Final_Amount ELSE 0 END)
        * 100,
        2
    ) AS YoY_Growth_Pct
FROM apollo_healthcare;

-- ADVANCED SQL--
-- CUSTOMER RANKING --
SELECT
    Customer_ID,
    COUNT(*) AS Delivered_Transactions,
    ROUND(SUM(Final_Amount), 2) AS Delivered_Sales,
    RANK() OVER (
        ORDER BY SUM(Final_Amount) DESC
    ) AS Customer_Rank
FROM apollo_healthcare
WHERE Order_Status = 'Delivered'
GROUP BY Customer_ID
ORDER BY Customer_Rank
LIMIT 10;

-- CATEGORY-WISE MEDICINE RANKING --
SELECT
    Category,
    Medicine_Name,
    ROUND(SUM(Final_Amount), 2) AS Delivered_Sales,
    RANK() OVER (
        PARTITION BY Category
        ORDER BY SUM(Final_Amount) DESC
    ) AS Medicine_Rank
FROM apollo_healthcare
WHERE Order_Status = 'Delivered'
GROUP BY Category, Medicine_Name
ORDER BY Category, Medicine_Rank;

-- MONTHLY SALES + PREVIOUS MONTH COMPARISON --
WITH Monthly_Sales AS (
    SELECT
        DATE_FORMAT(Order_Date, '%Y-%m') AS Sales_Month,
        ROUND(SUM(Final_Amount), 2) AS Delivered_Sales
    FROM apollo_healthcare
    WHERE Order_Status = 'Delivered'
    GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
)
SELECT
    Sales_Month,
    Delivered_Sales,
    LAG(Delivered_Sales) OVER (
        ORDER BY Sales_Month
    ) AS Previous_Month_Sales,
    ROUND(
        Delivered_Sales -
        LAG(Delivered_Sales) OVER (
            ORDER BY Sales_Month
        ),
        2
    ) AS Sales_Difference
FROM Monthly_Sales
ORDER BY Sales_Month;

-- RUNNING/CUMULATIVE SALES --
WITH Monthly_Sales AS (
    SELECT
        DATE_FORMAT(Order_Date, '%Y-%m') AS Sales_Month,
        ROUND(SUM(Final_Amount), 2) AS Delivered_Sales
    FROM apollo_healthcare
    WHERE Order_Status = 'Delivered'
    GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
)
SELECT
    Sales_Month,
    Delivered_Sales,
    ROUND(
        SUM(Delivered_Sales) OVER (
            ORDER BY Sales_Month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS Cumulative_Sales
FROM Monthly_Sales
ORDER BY Sales_Month;

-- TOP 3 MEDICINES IN EACH CATEGORY --
WITH Medicine_Sales AS (
    SELECT
        Category,
        Medicine_Name,
        ROUND(SUM(Final_Amount), 2) AS Delivered_Sales
    FROM apollo_healthcare
    WHERE Order_Status = 'Delivered'
    GROUP BY Category, Medicine_Name
),
Ranked_Medicines AS (
    SELECT
        Category,
        Medicine_Name,
        Delivered_Sales,
        ROW_NUMBER() OVER (
            PARTITION BY Category
            ORDER BY Delivered_Sales DESC
        ) AS Medicine_Rank
    FROM Medicine_Sales
)
SELECT
    Category,
    Medicine_Name,
    Delivered_Sales,
    Medicine_Rank
FROM Ranked_Medicines
WHERE Medicine_Rank <= 3
ORDER BY Category, Medicine_Rank;

-- CUSTOMER PURCHASE FREQUENCY --
SELECT
    CASE
        WHEN COUNT(*) = 1 THEN '1 Transaction'
        WHEN COUNT(*) BETWEEN 2 AND 3 THEN '2-3 Transactions'
        WHEN COUNT(*) BETWEEN 4 AND 5 THEN '4-5 Transactions'
        ELSE '6+ Transactions'
    END AS Purchase_Frequency,
    COUNT(*) AS Number_of_Customers,
    ROUND(SUM(SUM(Final_Amount)) OVER (), 2) AS Total_Delivered_Sales
FROM apollo_healthcare
WHERE Order_Status = 'Delivered'
GROUP BY Customer_ID
ORDER BY
    CASE
        WHEN COUNT(*) = 1 THEN 1
        WHEN COUNT(*) BETWEEN 2 AND 3 THEN 2
        WHEN COUNT(*) BETWEEN 4 AND 5 THEN 3
        ELSE 4
    END;
    
    WITH Customer_Frequency AS (
    SELECT
        Customer_ID,
        COUNT(*) AS Transaction_Count
    FROM apollo_healthcare
    WHERE Order_Status = 'Delivered'
    GROUP BY Customer_ID
)
SELECT
    CASE
        WHEN Transaction_Count = 1 THEN '1 Transaction'
        WHEN Transaction_Count BETWEEN 2 AND 3 THEN '2-3 Transactions'
        WHEN Transaction_Count BETWEEN 4 AND 5 THEN '4-5 Transactions'
        ELSE '6+ Transactions'
    END AS Purchase_Frequency,
    COUNT(*) AS Number_of_Customers
FROM Customer_Frequency
GROUP BY Purchase_Frequency
ORDER BY
    CASE
        WHEN Purchase_Frequency = '1 Transaction' THEN 1
        WHEN Purchase_Frequency = '2-3 Transactions' THEN 2
        WHEN Purchase_Frequency = '4-5 Transactions' THEN 3
        ELSE 4
    END;
    
-- CATEGORY CONTRIBUTION % --
WITH Category_Sales AS (
    SELECT
        Category,
        SUM(Final_Amount) AS Delivered_Sales
    FROM apollo_healthcare
    WHERE Order_Status = 'Delivered'
    GROUP BY Category
)
SELECT
    Category,
    ROUND(Delivered_Sales, 2) AS Delivered_Sales,
    ROUND(
        Delivered_Sales * 100.0 /
        SUM(Delivered_Sales) OVER (),
        2
    ) AS Sales_Contribution_Pct
FROM Category_Sales
ORDER BY Delivered_Sales DESC;

-- MONTH-OVER-MONTH GROWTH% --
WITH Monthly_Sales AS (
    SELECT
        DATE_FORMAT(Order_Date, '%Y-%m') AS Sales_Month,
        ROUND(SUM(Final_Amount), 2) AS Delivered_Sales
    FROM apollo_healthcare
    WHERE Order_Status = 'Delivered'
    GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
),
Monthly_Comparison AS (
    SELECT
        Sales_Month,
        Delivered_Sales,
        LAG(Delivered_Sales) OVER (
            ORDER BY Sales_Month
        ) AS Previous_Month_Sales
    FROM Monthly_Sales
)
SELECT
    Sales_Month,
    Delivered_Sales,
    Previous_Month_Sales,
    ROUND(
        (Delivered_Sales - Previous_Month_Sales)
        * 100.0 / Previous_Month_Sales,
        2
    ) AS MoM_Growth_Pct
FROM Monthly_Comparison
ORDER BY Sales_Month;

-- YEAR-OVER-YEAR MONTHLY COMPARISON --
WITH Monthly_Sales AS (
    SELECT
        YEAR(Order_Date) AS Sales_Year,
        MONTH(Order_Date) AS Sales_Month_Number,
        DATE_FORMAT(Order_Date, '%b') AS Sales_Month,
        ROUND(SUM(Final_Amount), 2) AS Delivered_Sales
    FROM apollo_healthcare
    WHERE Order_Status = 'Delivered'
    GROUP BY
        YEAR(Order_Date),
        MONTH(Order_Date),
        DATE_FORMAT(Order_Date, '%b')
),
Yearly_Comparison AS (
    SELECT
        Sales_Year,
        Sales_Month_Number,
        Sales_Month,
        Delivered_Sales,
        LAG(Delivered_Sales) OVER (
            PARTITION BY Sales_Month_Number
            ORDER BY Sales_Year
        ) AS Previous_Year_Sales
    FROM Monthly_Sales
)
SELECT
    Sales_Year,
    Sales_Month,
    Delivered_Sales,
    Previous_Year_Sales,
    ROUND(
        (Delivered_Sales - Previous_Year_Sales)
        * 100.0 / Previous_Year_Sales,
        2
    ) AS YoY_Growth_Pct
FROM Yearly_Comparison
ORDER BY Sales_Year, Sales_Month_Number;

-- TOP 5 CUSTOMERS BY SALES WITHIN EACH STATE --
WITH Customer_State_Sales AS (
    SELECT
        State,
        Customer_ID,
        ROUND(SUM(Final_Amount), 2) AS Delivered_Sales
    FROM apollo_healthcare
    WHERE Order_Status = 'Delivered'
    GROUP BY State, Customer_ID
),
Ranked_Customers AS (
    SELECT
        State,
        Customer_ID,
        Delivered_Sales,
        RANK() OVER (
            PARTITION BY State
            ORDER BY Delivered_Sales DESC
        ) AS Customer_Rank
    FROM Customer_State_Sales
)
SELECT
    State,
    Customer_ID,
    Delivered_Sales,
    Customer_Rank
FROM Ranked_Customers
WHERE Customer_Rank <= 5
ORDER BY State, Customer_Rank;

-- CUSTOMER LIFETIME VALUE --
SELECT
    Customer_ID,
    COUNT(*) AS Total_Transactions,
    SUM(Quantity) AS Total_Units,
    ROUND(SUM(Final_Amount), 2) AS Lifetime_Value,
    ROUND(AVG(Final_Amount), 2) AS Average_Order_Value,
    RANK() OVER (
        ORDER BY SUM(Final_Amount) DESC
    ) AS Customer_Rank
FROM apollo_healthcare
WHERE Order_Status = 'Delivered'
GROUP BY Customer_ID
ORDER BY Customer_Rank

-- IDENTIFY HIGH-VALUE CUSTOMERS --
WITH Customer_CLV AS (
    SELECT
        Customer_ID,
        ROUND(SUM(Final_Amount), 2) AS Lifetime_Value
    FROM apollo_healthcare
    WHERE Order_Status = 'Delivered'
    GROUP BY Customer_ID
)
SELECT
    CASE
        WHEN Lifetime_Value >= 2000 THEN 'High Value'
        WHEN Lifetime_Value >= 1000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Customer_Segment,
    COUNT(*) AS Number_of_Customers,
    ROUND(SUM(Lifetime_Value), 2) AS Total_Customer_Value,
    ROUND(AVG(Lifetime_Value), 2) AS Average_Customer_Value
FROM Customer_CLV
GROUP BY Customer_Segment
ORDER BY
    CASE
        WHEN Customer_Segment = 'High Value' THEN 1
        WHEN Customer_Segment = 'Medium Value' THEN 2
        ELSE 3
    END;
LIMIT 20;

-- REVENUE CONCENTRATION: TOP 10 CUSTOMERS --
WITH Customer_Sales AS (
    SELECT
        Customer_ID,
        SUM(Final_Amount) AS Delivered_Sales
    FROM apollo_healthcare
    WHERE Order_Status = 'Delivered'
    GROUP BY Customer_ID
),
Ranked_Customers AS (
    SELECT
        Customer_ID,
        Delivered_Sales,
        ROW_NUMBER() OVER (
            ORDER BY Delivered_Sales DESC
        ) AS Customer_Rank
    FROM Customer_Sales
)
SELECT
    COUNT(*) AS Top_10_Customers,
    ROUND(SUM(Delivered_Sales), 2) AS Top_10_Sales,
    ROUND(
        SUM(Delivered_Sales) * 100.0 /
        (SELECT SUM(Delivered_Sales) FROM Customer_Sales),
        2
    ) AS Top_10_Sales_Contribution_Pct
FROM Ranked_Customers
WHERE Customer_Rank <= 10;

-- RETURN RATE BY CATEGORY --
SELECT
    Category,
    COUNT(*) AS Total_Transactions,
    SUM(CASE
        WHEN Order_Status = 'Returned' THEN 1
        ELSE 0
    END) AS Returned_Transactions,
    ROUND(
        SUM(CASE
            WHEN Order_Status = 'Returned' THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*),
        2
    ) AS Return_Rate_Pct
FROM apollo_healthcare
GROUP BY Category
ORDER BY Return_Rate_Pct DESC;

-- CANCELLATION RATE BY CATEGORY --
SELECT
    Category,
    COUNT(*) AS Total_Transactions,
    SUM(CASE
        WHEN Order_Status = 'Cancelled' THEN 1
        ELSE 0
    END) AS Cancelled_Transactions,
    ROUND(
        SUM(CASE
            WHEN Order_Status = 'Cancelled' THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*),
        2
    ) AS Cancellation_Rate_Pct
FROM apollo_healthcare
GROUP BY Category
ORDER BY Cancellation_Rate_Pct DESC;

-- CATEGORY RISK STORE --
SELECT
    Category,
    COUNT(*) AS Total_Transactions,

    SUM(CASE
        WHEN Order_Status = 'Returned' THEN 1
        ELSE 0
    END) AS Returned_Transactions,

    SUM(CASE
        WHEN Order_Status = 'Cancelled' THEN 1
        ELSE 0
    END) AS Cancelled_Transactions,

    ROUND(
        (
            SUM(CASE
                WHEN Order_Status IN ('Returned', 'Cancelled') THEN 1
                ELSE 0
            END) * 100.0
        ) / COUNT(*),
        2
    ) AS Overall_Risk_Rate_Pct

FROM apollo_healthcare
GROUP BY Category
ORDER BY Overall_Risk_Rate_Pct DESC;

-- PAYMENT MODE RISK ANALYSIS --
SELECT
    Payment_Mode,
    COUNT(*) AS Total_Transactions,

    SUM(CASE
        WHEN Order_Status = 'Returned' THEN 1
        ELSE 0
    END) AS Returned_Transactions,

    SUM(CASE
        WHEN Order_Status = 'Cancelled' THEN 1
        ELSE 0
    END) AS Cancelled_Transactions,

    ROUND(
        SUM(CASE
            WHEN Order_Status IN ('Returned', 'Cancelled') THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*),
        2
    ) AS Overall_Risk_Rate_Pct

FROM apollo_healthcare
GROUP BY Payment_Mode
ORDER BY Overall_Risk_Rate_Pct DESC;

-- STATE WISE RISK ANALYSIS --
SELECT
    State,
    COUNT(*) AS Total_Transactions,

    SUM(CASE
        WHEN Order_Status = 'Returned' THEN 1
        ELSE 0
    END) AS Returned_Transactions,

    SUM(CASE
        WHEN Order_Status = 'Cancelled' THEN 1
        ELSE 0
    END) AS Cancelled_Transactions,

    ROUND(
        SUM(CASE
            WHEN Order_Status IN ('Returned', 'Cancelled') THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*),
        2
    ) AS Overall_Risk_Rate_Pct

FROM apollo_healthcare
GROUP BY State
ORDER BY Overall_Risk_Rate_Pct DESC;

-- MEDICINE-WISE RISK ANALYSIS --
SELECT
    Medicine_Name,
    Category,
    COUNT(*) AS Total_Transactions,

    SUM(CASE
        WHEN Order_Status = 'Returned' THEN 1
        ELSE 0
    END) AS Returned_Transactions,

    SUM(CASE
        WHEN Order_Status = 'Cancelled' THEN 1
        ELSE 0
    END) AS Cancelled_Transactions,

    ROUND(
        SUM(CASE
            WHEN Order_Status IN ('Returned', 'Cancelled') THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*),
        2
    ) AS Overall_Risk_Rate_Pct

FROM apollo_healthcare
GROUP BY Medicine_Name, Category
ORDER BY Overall_Risk_Rate_Pct DESC;

-- RISK VS SALES ANALYSIS --
SELECT
    Medicine_Name,
    Category,
    ROUND(SUM(Final_Amount), 2) AS Total_Sales,

    COUNT(*) AS Total_Transactions,

    ROUND(
        SUM(CASE
            WHEN Order_Status IN ('Returned', 'Cancelled') THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*),
        2
    ) AS Overall_Risk_Rate_Pct

FROM apollo_healthcare
GROUP BY Medicine_Name, Category
ORDER BY Total_Sales DESC;

-- TOP 5 MEDICINES BY DELIVERED SALES --
SELECT
    Medicine_Name,
    Category,
    COUNT(*) AS Delivered_Transactions,
    SUM(Quantity) AS Units_Sold,
    ROUND(SUM(Final_Amount), 2) AS Delivered_Sales,
    ROUND(AVG(Final_Amount), 2) AS Average_Transaction_Value
FROM apollo_healthcare
WHERE Order_Status = 'Delivered'
GROUP BY Medicine_Name, Category
ORDER BY Delivered_Sales DESC
LIMIT 5;

-- CUSTOMER REPEAT PURCHASE RATE --
WITH Customer_Summary AS (
    SELECT
        Customer_ID,
        COUNT(*) AS Transaction_Count,
        SUM(Final_Amount) AS Customer_Sales
    FROM apollo_healthcare
    WHERE Order_Status = 'Delivered'
    GROUP BY Customer_ID
)
SELECT
    CASE
        WHEN Transaction_Count = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS Customer_Type,

    COUNT(*) AS Number_of_Customers,

    ROUND(SUM(Customer_Sales), 2) AS Total_Sales,

    ROUND(AVG(Customer_Sales), 2) AS Average_Customer_Value,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS Customer_Share_Pct

FROM Customer_Summary
GROUP BY Customer_Type
ORDER BY Number_of_Customers DESC;

-- STATE + CATEGORY PERFORMANCE --
WITH State_Category_Sales AS (
    SELECT
        State,
        Category,
        ROUND(SUM(Final_Amount), 2) AS Delivered_Sales
    FROM apollo_healthcare
    WHERE Order_Status = 'Delivered'
    GROUP BY State, Category
),
Ranked_Data AS (
    SELECT
        State,
        Category,
        Delivered_Sales,
        RANK() OVER (
            PARTITION BY State
            ORDER BY Delivered_Sales DESC
        ) AS Category_Rank
    FROM State_Category_Sales
)
SELECT
    State,
    Category,
    Delivered_Sales,
    Category_Rank
FROM Ranked_Data
WHERE Category_Rank = 1
ORDER BY Delivered_Sales DESC;

-- FINAL ADVANCED SQL QUERY --
WITH Customer_Summary AS (
    SELECT
        Customer_ID,
        COUNT(*) AS Transaction_Count
    FROM apollo_healthcare
    WHERE Order_Status = 'Delivered'
    GROUP BY Customer_ID
),
Customer_Types AS (
    SELECT
        COUNT(*) AS Total_Customers,
        SUM(
            CASE
                WHEN Transaction_Count > 1 THEN 1
                ELSE 0
            END
        ) AS Repeat_Customers
    FROM Customer_Summary
)
SELECT
    COUNT(*) AS Total_Transactions,

    COUNT(DISTINCT Customer_ID) AS Total_Customers,

    SUM(Quantity) AS Total_Units,

    ROUND(
        SUM(
            CASE
                WHEN Order_Status = 'Delivered'
                THEN Final_Amount
                ELSE 0
            END
        ),
        2
    ) AS Delivered_Sales,

    ROUND(
        AVG(
            CASE
                WHEN Order_Status = 'Delivered'
                THEN Final_Amount
            END
        ),
        2
    ) AS Average_Order_Value,

    ROUND(
        SUM(
            CASE
                WHEN Order_Status = 'Returned'
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Return_Rate_Pct,

    ROUND(
        SUM(
            CASE
                WHEN Order_Status = 'Cancelled'
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Cancellation_Rate_Pct,

    ROUND(
        MAX(Repeat_Customers) * 100.0 /
        MAX(Total_Customers),
        2
    ) AS Repeat_Customer_Rate_Pct

FROM apollo_healthcare
CROSS JOIN Customer_Types;

-- SQL VALIDATION & FINAL CHECK --
-- FINAL ROW & TRANSACTION ID VALIDATION --
SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT Transaction_ID) AS Unique_Transaction_IDs,
    SUM(
        CASE
            WHEN Transaction_ID IS NULL OR Transaction_ID = ''
            THEN 1
            ELSE 0
        END
    ) AS Missing_Transaction_IDs
FROM apollo_healthcare;

-- CALCULATED COLUMNS VALIDATION --
SELECT
    COUNT(*) AS Total_Rows,

    SUM(CASE
        WHEN Gross_Amount IS NULL OR Gross_Amount < 0
        THEN 1 ELSE 0
    END) AS Invalid_Gross_Amount,

    SUM(CASE
        WHEN Discount_Amount IS NULL OR Discount_Amount < 0
        THEN 1 ELSE 0
    END) AS Invalid_Discount_Amount,

    SUM(CASE
        WHEN Net_Amount_Before_Tax IS NULL OR Net_Amount_Before_Tax < 0
        THEN 1 ELSE 0
    END) AS Invalid_Net_Amount,

    SUM(CASE
        WHEN Tax_Amount IS NULL OR Tax_Amount < 0
        THEN 1 ELSE 0
    END) AS Invalid_Tax_Amount,

    SUM(CASE
        WHEN Final_Amount IS NULL OR Final_Amount < 0
        THEN 1 ELSE 0
    END) AS Invalid_Final_Amount

FROM apollo_healthcare;

-- FINAL DATA QUALITY VALIDATION --
SELECT
    COUNT(*) AS Total_Rows,

    SUM(CASE
        WHEN Order_ID IS NULL OR TRIM(Order_ID) = ''
        THEN 1 ELSE 0
    END) AS Invalid_Order_ID,

    SUM(CASE
        WHEN Customer_ID IS NULL OR TRIM(Customer_ID) = ''
        THEN 1 ELSE 0
    END) AS Invalid_Customer_ID,

    SUM(CASE
        WHEN Medicine_ID IS NULL OR TRIM(Medicine_ID) = ''
        THEN 1 ELSE 0
    END) AS Invalid_Medicine_ID,

    SUM(CASE
        WHEN Quantity IS NULL OR Quantity <= 0
        THEN 1 ELSE 0
    END) AS Invalid_Quantity,

    SUM(CASE
        WHEN Unit_Price IS NULL OR Unit_Price <= 0
        THEN 1 ELSE 0
    END) AS Invalid_Unit_Price,

    SUM(CASE
        WHEN Discount_Pct IS NULL
             OR Discount_Pct < 0
             OR Discount_Pct > 100
        THEN 1 ELSE 0
    END) AS Invalid_Discount,

    SUM(CASE
        WHEN Tax_Pct IS NULL
             OR Tax_Pct < 0
             OR Tax_Pct > 100
        THEN 1 ELSE 0
    END) AS Invalid_Tax

FROM apollo_healthcare;

-- FINAL CALCULATION ACCURACY CHECK --
SELECT
    COUNT(*) AS Total_Rows,
    SUM(
        CASE
            WHEN Gross_Amount <> ROUND(Quantity * Unit_Price, 2)
            THEN 1 ELSE 0
        END
    ) AS Gross_Errors,
    SUM(
        CASE
            WHEN Discount_Amount <> ROUND(Gross_Amount * Discount_Pct / 100, 2)
            THEN 1 ELSE 0
        END
    ) AS Discount_Errors,
    SUM(
        CASE
            WHEN Net_Amount_Before_Tax <> ROUND(Gross_Amount - Discount_Amount, 2)
            THEN 1 ELSE 0
        END
    ) AS Net_Errors,
    SUM(
        CASE
            WHEN Tax_Amount <> ROUND(Net_Amount_Before_Tax * Tax_Pct / 100, 2)
            THEN 1 ELSE 0
        END
    ) AS Tax_Errors,
    SUM(
        CASE
            WHEN Final_Amount <> ROUND(Net_Amount_Before_Tax + Tax_Amount, 2)
            THEN 1 ELSE 0
        END
    ) AS Final_Amount_Errors
FROM apollo_healthcare;

-- FINAL SQL VALIDATION SUMMARY --
SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT Transaction_ID) AS Unique_Transactions,
    COUNT(DISTINCT Customer_ID) AS Total_Customers,
    COUNT(DISTINCT Medicine_ID) AS Total_Medicines,
    MIN(Order_Date) AS First_Order_Date,
    MAX(Order_Date) AS Last_Order_Date,
    SUM(CASE WHEN Order_Status = 'Delivered' THEN 1 ELSE 0 END) AS Delivered_Orders,
    SUM(CASE WHEN Order_Status = 'Returned' THEN 1 ELSE 0 END) AS Returned_Orders,
    SUM(CASE WHEN Order_Status = 'Cancelled' THEN 1 ELSE 0 END) AS Cancelled_Orders
FROM apollo_healthcare;
SET SQL_SAFE_UPDATES = 0;