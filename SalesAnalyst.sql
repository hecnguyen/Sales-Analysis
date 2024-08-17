--Male vs Female:
--Getting the count of male and female
--Getting the average amount spent and total amount spent of male and female

SELECT gender,COUNT(*) AS num_of_people,ROUND(AVG(total),2) AS avg_amount,
ROUND(SUM(total),2) AS total_spent
FROM supermarket
GROUP BY gender

--Customer Type:
--Getting the count of regular customers and people who paid a membership
--Getting the average amount spent and total amount spent of normal customers and members

SELECT customer_type, COUNT(customer_type) AS count_of_customers,
ROUND(AVG(total),2) AS average_amount, ROUND(SUM(total),2) AS total_amount 
FROM supermarket
GROUP by customer_type

--Product Line Total:
--Getting the total amount on each product line

SELECT product_line,SUM(total) AS total FROM supermarket
GROUP BY product_line
ORDER BY total DESC

--Ranking of Products:
--Ranking the product line to determine which product is the most popular among males and females

WITH cte AS
(SELECT gender,product_line,ROUND(SUM(total),2) AS total
FROM supermarket
GROUP BY gender,product_line)

SELECT gender,product_line,total,
DENSE_RANK () OVER (PARTITION BY gender ORDER BY total DESC) AS ranking
FROM cte

--Most Spending Day:
--Identifying which day of the week has the highest number of people making purchases

WITH cte AS(
SELECT DISTINCT(EXTRACT(DOW FROM date)) AS days,date,total,invoice_id,product_line
FROM supermarket
),
cte2 AS(
SELECT date,total,product_line,invoice_id, CASE  
WHEN days = 0 THEN 'Sunday'
WHEN days = 1 THEN 'Monday'
WHEN days = 2 THEN 'Tuesday'
WHEN days = 3 THEN 'Wednesday'
WHEN days = 4 THEN 'Thursday'
WHEN days = 5 THEN 'Friday'
WHEN days = 6 THEN 'Saturday'
END AS day_of_week
FROM cte)

SELECT day_of_week,ROUND(SUM(total),2) AS total,COUNT(invoice_id) AS count FROM cte2
GROUP BY day_of_week
ORDER BY total DESC

--Total Purchases Per Hour:
--Identifying the time of day when sales peak

WITH cte AS(
	SELECT EXTRACT(HOUR FROM time) AS hour,invoice_id
FROM supermarket)

SELECT hour,ROUND(COUNT(invoice_id),2) AS total_purchases
FROM cte
GROUP BY hour
ORDER BY hour
