# Healthcare & E-Pharmacy Sales Analytics

An end-to-end healthcare e-commerce analytics project built using **Excel, MySQL, Power BI and DAX** to analyze sales performance, customer behavior, product trends, geography and order fulfillment risks.

> **Dataset Note:** This project uses a **synthetic/simulated healthcare e-commerce dataset** created for educational and portfolio purposes. It does not contain real Apollo customer or business data.

---

## 📌 Project Overview

The objective of this project is to transform raw healthcare e-commerce transaction data into actionable business insights.

The project follows a complete analytics workflow:

**Raw Data → Excel → MySQL → Power BI → Business Insights**

The analysis focuses on:

* Sales and revenue performance
* Customer purchasing behavior
* Medicine and category performance
* Geographic sales distribution
* Order status and fulfillment risk
* Returns and cancellations
* Sales trends
* Business recommendations

---

## 🛠️ Tools & Technologies

| Tool                | Purpose                                                               |
| ------------------- | --------------------------------------------------------------------- |
| **Microsoft Excel** | Data profiling, quality checks, calculations and exploratory analysis |
| **MySQL**           | Data transformation, validation and business analysis                 |
| **Power BI**        | Interactive dashboard and visualization                               |
| **DAX**             | KPI calculations and analytical measures                              |
| **GitHub**          | Project documentation and portfolio management                        |

---

## 📊 Dataset

* **Transactions:** 8,000
* **Customers:** 3,137
* **Transaction Period:** January 2024 – December 2025
* **Units Sold:** 16,739
* **Medicine/Product data:** Healthcare and pharmaceutical products
* **Geography:** Indian cities and states
* **Order statuses:** Delivered, Returned, Cancelled, Processing

---

## 🔍 Excel Analysis

Excel was used for initial data preparation, validation and exploratory analysis.

### Data Quality

Performed checks for:

* Missing values
* Invalid quantities
* Invalid prices
* Invalid discounts
* Invalid tax rates
* Duplicate transaction records
* Calculation errors
* Transaction ID uniqueness

**Overall Data Quality Status: PASS**

### Calculated Fields

Created:

* Gross Amount
* Discount Amount
* Net Sales Before Tax
* Tax Amount
* Final Amount
* Transaction ID

### Excel Exploratory Analysis

Built PivotTables for:

* Sales by Category
* Sales by State
* Sales by Payment Mode
* Order Status
* Monthly Sales
* Customer Frequency
* Category Units and Sales
* Top Medicines

---

## 🗄️ MySQL Analysis

MySQL was used for data transformation, validation and advanced business analysis.

Key SQL techniques included:

* Aggregations
* CASE statements
* CTEs
* Subqueries
* Window functions
* Ranking
* Customer frequency analysis
* Sales trend analysis
* Return and cancellation analysis
* Geographic analysis
* Final data validation

---

## 📈 Power BI Dashboard

A **5-page interactive Power BI dashboard** was created.

### Page 1 — Executive Overview

Provides a high-level view of:

* Total Sales
* Delivered Sales
* Transactions
* Customers
* AOV
* Order performance

### Page 2 — Medicine & Category

Analyzes:

* Top medicines
* Category sales
* Units sold
* Product performance
* Category-level trends

### Page 3 — Customer & Geography

Analyzes:

* Customer behavior
* Repeat vs one-time customers
* State-level sales
* Geographic performance

### Page 4 — Trends, Returns & Risk

Analyzes:

* Sales trends
* Returns
* Cancellations
* Processing orders
* Non-delivered orders
* Risk areas

### Page 5 — Key Insights & Recommendations

Summarizes major findings and provides business recommendations for:

* Reducing returns
* Reducing cancellations
* Improving customer retention
* Focusing on high-value categories
* Monitoring non-delivered orders

---

## 📌 Key Business Findings

### 1. Respiratory Care is a Major Revenue Driver

Delivered sales from Respiratory Care were approximately **₹247.19K**, making it the highest-selling category.

### 2. Skin Care Has the Highest AOV

Skin Care recorded an average order value of approximately **₹404.26**, indicating strong potential for premium bundles and cross-selling.

### 3. Repeat Customers Are Important

Approximately **55.96%** of delivered customers were repeat customers, highlighting the importance of customer retention.

### 4. Order Fulfillment Is a Key Opportunity

Approximately **37.25%** of transactions were non-delivered, consisting of returned, cancelled and processing orders.

### 5. Returns and Cancellations Require Attention

* Return Rate: **12.78%**
* Cancellation Rate: **12.26%**

These metrics indicate opportunities to improve fulfillment and customer experience.

### 6. Delivered Sales Declined in 2025

Delivered sales declined by approximately **2.72% YoY** from 2024 to 2025.

---

## 💡 Business Recommendations

1. **Reduce Returns**
   Investigate high-return categories and identify common return drivers.

2. **Reduce Cancellations**
   Analyze cancellation patterns, especially in high-risk categories.

3. **Improve Customer Retention**
   Use loyalty offers, refill reminders and personalized promotions to convert one-time customers into repeat customers.

4. **Focus on High-Value Categories**
   Develop bundles and cross-selling strategies around categories with higher AOV.

5. **Monitor Non-Delivered Orders**
   Track returned, cancelled and processing orders by category and geography.

---

## 📁 Project Structure

Healthcare-Ecommerce-Analytics/
│
├── README.md
├── .gitignore
│
├── Healthcare_Ecommerce_Analytics.xlsx
├── Healthcare_Ecommerce_Analytics.sql
├── Healthcare_Ecommerce_Analytics.pbix
│
└── Dashboard_Screenshots/
    ├── 01_Executive_Overview.png
    ├── 02_Medicine_Category.png
    ├── 03_Customer_Geography.png
    ├── 04_Trends_Returns_Risk.png
    └── 05_Insights_Recommendations.png

## 🎯 Skills Demonstrated

* Data Cleaning
* Data Validation
* Exploratory Data Analysis
* Excel PivotTables
* Excel Formulas
* SQL
* CTEs
* Window Functions
* Business KPI Analysis
* Customer Analytics
* Product Analytics
* Geographic Analysis
* Power BI
* DAX
* Data Visualization
* Business Storytelling
* Insight Generation

---

## 🚀 Project Outcome

This project demonstrates an end-to-end analytics workflow where raw transaction data is transformed into validated datasets, analytical outputs and an interactive business intelligence dashboard.

The combination of **Excel + SQL + Power BI** demonstrates the ability to work across the complete data analytics lifecycle — from data preparation to business recommendations.

---

## 📌 Disclaimer

This project is created strictly for **educational, portfolio and demonstration purposes**.

The dataset is synthetic/simulated and does not represent real Apollo customer transactions, customers, financial information or internal business data.
