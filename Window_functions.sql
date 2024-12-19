use Sales;

select * from sales_data;

-- Rank all sales transactions based on sales_amount in descending order.
select *, rank() over (order by sales_amount)
from sales_data;

-- Rank customers by their total sales_amount (grouped by customer_id) in descending order.
select customer_id, sum(sales_amount) as total_amount,
rank() over (order by sum(sales_amount) desc)
from sales_data
group by customer_id;

-- Rank each sale transaction within product_category based on sales_amount.
select *, rank() over (partition by product_category order by sales_amount)
from sales_data;

-- Identify the top 3 highest sales transactions based on sales_amount using RANK().
select *
from (
    select *, 
           rank() over (partition by product_category order by sales_amount desc) as ranking
    from sales_data
) as rank_data
where ranking <= 3;

-- Rank customers based on their latest sale date in ascending order.
select *
from (select *, rank() over (partition by customer_id order by sale_date desc) as ranking
from sales_data) as ranked_data
where ranking = 1;

-- Rank sales transactions within each product_category based on sales_amount.
select *, rank() over (partition by product_category order by sales_amount) as ranking
from sales_data;

-- Partition the data by customer_id and rank sales by sale_date.
select *, rank() over (partition by customer_id order by sale_date) as ranking
from sales_data;

-- Rank transactions within each month (use EXTRACT(MONTH FROM sale_date)) based on sales_amount.
select *, rank() over (partition by EXTRACT(MONTH FROM sale_date) order by sale_date) as ranking
from sales_data;

-- Partition the data by product_category and rank customers by total sales in descending order.
SELECT customer_id, product_category, SUM(sales_amount) AS total_sales,
       RANK() OVER (PARTITION BY product_category ORDER BY SUM(sales_amount) DESC) AS ranking
FROM sales_data
GROUP BY customer_id, product_category;

-- Rank the transactions within each product_category based on sale_date in ascending order.
select *, rank() over (partition by product_category order by sale_date)
from sales_data;

-- Assign a unique row number to each transaction ordered by sales_amount in descending order.
select *, row_number() over (order by sales_amount desc) as row_num
from sales_data;

-- Generate row numbers for each customer’s transactions based on the sale_date.
select *, row_number() over (partition by customer_id order by sales_amount desc) as row_num
from sales_data;

-- Use PARTITION BY to assign row numbers for each product_category ordered by sales_amount.
select *, row_number() over (partition by product_category order by sales_amount) as row_num
from sales_data;

-- Retrieve only the most recent transaction for each customer using ROW_NUMBER().
select *
from (
	select *, row_number() over (partition by customer_id order by sale_date desc) as row_num
	from sales_data) as rowed_sales_data
where row_num = 1;

-- Identify the second-highest sale for each product_category using ROW_NUMBER().
select *
from (
	select *, row_number() over (partition by product_category order by sales_amount desc) as row_num
	from sales_data) as rowed_sales_data
where row_num = 2;

-- Divide all sales into 4 equal groups based on sales_amount.
select *, ntile(4) over (order by sales_amount) as tile_num
from sales_data;

-- Partition the data by product_category and divide transactions into 3 equal groups.
select *, ntile(3) over (partition by product_category order by sales_amount) as tile_num
from sales_data;

-- Use NTILE() to assign quartiles for total sales_amount.
select *, ntile(4) over (order by sales_amount desc) as quartile
from sales_data;

-- Identify customers in the top 25% of sales transactions based on sales_amount.
select *
from(
	select *, ntile(4) over (order by sales_amount desc) as quartile
	from sales_data) as tiled_sales_data
where quartile = 1;

-- Group transactions into 5 buckets within each product_category.
select *, ntile(5) over (partition by product_category order by sales_amount desc) as quartile
from sales_data;

-- Combine RANK() and ROW_NUMBER() to rank and number sales within each product_category.
select *, rank() over (partition by product_category order by sales_amount) as ranking,
	row_number() over (partition by product_category order by sales_amount) as row_num
from sales_data;

-- Use DENSE_RANK() to find the top 3 sales per product category.
select * from (
	select *, dense_rank() over (partition by product_category order by sales_amount) as ranking
    from sales_data) as ranked_data
    where ranking <= 3;

-- Rank transactions by sales_amount and show cumulative sales using SUM() with OVER().
select *,
	rank() over (order by sales_amount desc) as rank_by_sales,
    sum(sales_amount) over (partition by product_category order by sales_amount desc) as cum_sum
from sales_data;

-- Compare the results of RANK(), DENSE_RANK(), and ROW_NUMBER() in a single query.
select *,
	rank() over (order by sales_amount desc) as ranking,
    row_number() over (order by sales_amount desc) as row_num,
    dense_rank() over (order by sales_amount desc) as d_ranking
from sales_data;

-- Combine ranking and cumulative sales to analyze trends within customer_id.
select *, rank() over (partition by customer_id order by sales_amount) as ranking,
	sum(sales_amount) over (partition by customer_id order by sale_date) as cum_sum
from sales_data
order by customer_id, sale_date;

-- Divide all sales into percentiles using NTILE() (top 25%, 50%, etc.).
select *, ntile(4) over (order by sales_amount desc)
from sales_data;

-- Rank customers based on their total sales_amount percentile.
select *, rank() over (order by total_sale desc) as ranking
from (
    select customer_id, sum(sales_amount) as total_sale,
           ntile(10) over (order by sum(sales_amount) desc) as percentile
    from sales_data
    group by customer_id
) as ranked_data;

-- Identify customers in the top 10% of sales transactions.
select * from (
select *, ntile(10) over (order by sales_amount) as percentile
from sales_data) as percent_data
where percentile = 1;

-- Use NTILE(10) to assign sales into deciles.
select *, ntile(10) over (order by sales_amount) as percentile
from sales_data;

-- Analyze the distribution of sales_amount within each product category using percentiles.
select *, ntile(10) over (partition by product_category order by sales_amount) as percentile
from sales_data;

-- Use LAG() to find the previous transaction's sales_amount for each customer.
select *, lag(sales_amount) over (partition by customer_id order by sale_date) as old_sales_amount
from sales_data;

-- Use LEAD() to find the next transaction's sales_amount for each customer.
select *, lead(sales_amount) over (partition by customer_id order by sale_date) as next_sales_amount
from sales_data;

-- Compare sales_amount with the previous transaction and show the difference.
select *, (sales_amount - old_sales_amount)
from(
	select *, lag(sales_amount) over (partition by customer_id order by sale_date) as old_sales_amount
	from sales_data) as new_data;

-- Retrieve only rows where the difference in sales_amount from the previous transaction is positive.
select * from (
select *, (sales_amount - old_sales_amount) as diff
from (
	select *, lag(sales_amount) over (partition by customer_id order by sale_date) as old_sales_amount
	from sales_data) as new_data) new_sale_data    
where diff > 0;

-- Use both LEAD() and LAG() to display the previous and next sales transactions for each customer.
select *, lead(sales_amount) over (partition by customer_id order by sale_date) as next_sales_amount,
	lag(sales_amount) over (partition by customer_id order by sale_date) as old_sales_amount
from sales_data;

-- Rank sales transactions and display only the top 3 rows for each product_category.
select * from (
	select *, rank() over (partition by product_category order by sales_amount desc) as ranking
    from sales_data) as new_data
where ranking <= 3;

-- Use RANK() to find rows with the highest sales_amount in each product category.
select *, rank() over (partition by product_category order by sales_amount desc) as ranking
from sales_data;

-- Retrieve only rows with RANK = 1 (top sales) for each product category.
select * from (
	select *, rank() over (partition by product_category order by sales_amount desc) as ranking
	from sales_data) as new_data
where ranking = 1;    

-- Use DENSE_RANK() to filter transactions with ranks less than or equal to 3.
select * from (
	select *, dense_rank() over (order by sales_amount desc) as ranking
    from sales_data) as new_data
where ranking <= 3;

-- Display customers whose transactions are ranked in the top 2 within each customer_id group.
select * from (
	select *, dense_rank() over (partition by customer_id order by sales_amount desc) as ranking
    from sales_data) as new_data
where ranking <= 2;