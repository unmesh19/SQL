# Sales Data Ranking and Analysis

This project demonstrates various SQL queries using window functions to analyze and rank sales data. These queries are useful for extracting insights, such as top-performing transactions, customer rankings, and sales trends.

## Features

1. **Ranking Transactions**:
   - Rank all sales transactions based on `sales_amount` in descending order.
   - Rank customers by their total `sales_amount` grouped by `customer_id`.
   - Rank sales within each `product_category` based on `sales_amount`.

2. **Identifying Top Sales**:
   - Retrieve the top 3 highest sales transactions per `product_category` using `RANK()`.
   - Identify the second-highest sale for each `product_category` using `ROW_NUMBER()`.
   - Retrieve only the most recent transaction for each customer.

3. **Cumulative and Comparative Analysis**:
   - Show cumulative sales within each `product_category`.
   - Compare results of `RANK()`, `DENSE_RANK()`, and `ROW_NUMBER()` in a single query.
   - Analyze trends within `customer_id` by combining ranking and cumulative sales.

4. **Percentile Analysis**:
   - Divide sales into quartiles, deciles, and percentiles.
   - Identify customers in the top 10% or 25% of sales transactions.
   - Analyze distribution of `sales_amount` within each `product_category`.

5. **Previous and Next Transactions**:
   - Use `LAG()` and `LEAD()` to find previous and next sales transactions for each customer.
   - Show differences in `sales_amount` compared to the previous transaction.

6. **Group Analysis**:
   - Partition data by `customer_id` or `product_category` for ranking and grouping.
   - Assign transactions into equal groups using `NTILE()`.

## Prerequisites

- A database with a table named `sales_data`.
- SQL knowledge and a database management system like MySQL, PostgreSQL, or SQL Server.

### Example Table Structure

```sql
CREATE TABLE sales_data (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    product_category VARCHAR(255),
    sales_amount DECIMAL(10, 2),
    sale_date DATE
);
```

### Sample Data

```sql
INSERT INTO sales_data (sale_id, customer_id, product_category, sales_amount, sale_date) VALUES
(1, 101, 'Electronics', 500.00, '2024-01-01'),
(2, 102, 'Apparel', 200.00, '2024-01-02'),
(3, 101, 'Electronics', 300.00, '2024-01-03'),
(4, 103, 'Home', 400.00, '2024-01-04'),
(5, 102, 'Apparel', 150.00, '2024-01-05');
```

## Usage

1. Clone the repository or copy the SQL script.
2. Set up the `sales_data` table in your database.
3. Populate the table with sample data.
4. Run the provided SQL queries to perform various analyses.
