SHOW DATABASES;
USE `awesome chocolates`;

-- Dataset Tables:
-- 1. sales    Columns: SPID, GeoID, PID, SaleDate, Amount, Customers, Boxes
-- 2. people    Columns: Salesperson, SPID, Team, Location
-- 3. products	Columns: PID, Product, Category, Size, Cost_per_box
-- 4. geo	Columns: GeoID, Geo, Region

-- Q1. Basic Filtering
-- Display all sales transactions where Amount is greater than 10,000.
-- Display SPID, PID, SaleDate, Amount, Customers and Boxes.

SELECT * From sales s
WHERE s.amount>10000;

-- Q2. Sorting and Filtering
-- Find all sales transactions where more than 500 boxes were sold.
-- Display SaleDate, SPID, PID, Boxes and Amount.
-- Sort the result by Boxes in descending order.

SELECT * From sales s
WHERE s.boxes>500
ORDER BY s.boxes DESC;


/* 
Q3. DISTINCT + Date Filtering
Find all unique product IDs (PID) that were sold during the year 2021.
Display only the unique PID values.
Concepts: DISTINCT, WHERE, date filtering.

*/
SELECT DISTINCT s.pid, s.geoid, s.spid,s.saledate,s.amount From sales s
WHERE s.saledate between '2021-01-01' AND '2021-12-31'
;

/*
Q4. Basic Aggregation
Calculate the following for the complete sales table:
- Total sales amount
- Average sales amount
- Maximum sales amount
- Minimum sales amount
- Total boxes sold
- Total customers

Return the results in one row.

Concepts: SUM, AVG, MAX, MIN, aggregation.
*/

SELECT SUM(s.amount),AVG(s.amount),MAX(s.amount),MIN(s.amount),COUNT(s.boxes),COUNT(s.customers) FROM sales s;


/*
Q5. Sales by Product
Calculate total sales amount and total boxes sold for each PID.
Display PID, total sales amount and total boxes sold.
Sort by total sales amount from highest to lowest.

Concepts: GROUP BY, SUM, ORDER BY.
*/
SELECT s.pid, SUM(s.amount) FROM sales s
GROUP BY s.PID
ORDER BY SUM(s.amount) DESC;


/*
Q6. Sales by Product with HAVING
Calculate total sales amount for each PID.
Display only products whose total sales amount is greater than 500,000.
Sort the result by total sales amount in descending order.

Concepts: GROUP BY, SUM, HAVING, ORDER BY.

*/
SELECT s.pid, SUM(s.amount) FROM sales s
GROUP BY s.PID
HAVING SUM(s.amount) > 500000;

/*
Q7. Sales by Region
Using the sales and geo tables, calculate total sales amount for each region.
Display Region and total sales amount.
Sort from highest to lowest.

Concepts: INNER JOIN, GROUP BY, SUM, ORDER BY.
*/
SELECT g.Region, SUM(s.Amount) FROM sales s
INNER JOIN geo g
ON s.GeoID=g.GeoID
GROUP BY g.Region
ORDER BY SUM(s.Amount) DESC;

/*
Q8. Sales by Country
Using sales and geo, calculate:
- Total sales amount
- Total boxes sold
- Total customers

for each country.

Display country name and the three metrics.
Sort by total sales amount descending.

Concepts: JOIN, GROUP BY, multiple aggregate functions.
*/

SELECT g.Region, SUM(s.Amount), SUM(s.Boxes), COUNT(s.Customers) FROM sales s
INNER JOIN geo g
ON s.GeoID=g.GeoID
GROUP BY g.Region
ORDER BY SUM(s.Amount) DESC;

/*
Q9. Salesperson Performance
Using sales and people, calculate total sales amount for every salesperson.
Display:
- Salesperson
- SPID
- Team
- Total Sales

Sort from highest to lowest total sales.

Concepts: JOIN, GROUP BY, SUM, aliases, ORDER BY.
*/
SELECT * FROM people;

SELECT p.Salesperson as Salesperson, p.SPID as SPID, p.Team AS TEAM, SUM(s.Amount) AS 'TOTAL Sales'  FROM people p
INNER JOIN sales s
ON p.SPID = s.SPID
GROUP BY p.spid
ORDER BY SUM(s.Amount) DESC;

/*
Q10. Product Category Analysis
Using sales and products, calculate total sales amount and total boxes sold for each product category.
Display:
- Category
- Total Sales
- Total Boxes

Sort by Total Sales descending.

Concepts: JOIN, GROUP BY, aggregation.
*/
SELECT p.Category AS Category, SUM(s.amount) AS 'Total Sales', COUNT(s.boxes) AS 'Total Boxes' FROM sales s
JOIN products p
ON p.pid = s.pid
GROUP BY p.Category
ORDER BY SUM(s.amount) DESC;


/*
Q11. Team Performance
Using sales and people, calculate total sales amount for each team.
Display:
- Team
- Number of sales transactions
- Total Sales
- Total Boxes

Sort teams by Total Sales descending.

Concepts: JOIN, COUNT, SUM, GROUP BY, ORDER BY.
*/

SELECT p.Team as Team, COUNT(s.SPID) as 'Number of sales transactions', p.Team AS TEAM, SUM(s.Amount) AS 'TOTAL Sales'  FROM people p
INNER JOIN sales s
ON p.SPID = s.SPID
GROUP BY p.team
ORDER BY SUM(s.Amount) DESC;

/*
Q12. Monthly Sales
Calculate total sales amount for each month of 2021.
Display:
- Month
- Total Sales
- Total Boxes

Sort chronologically by month.

Concepts: date functions, GROUP BY, SUM, ORDER BY.
*/
SELECT month(s.saledate) as Month, COUNT(s.SPID) as 'Total Sales', SUM(s.Boxes) as 'Total Boxes' FROM sales s
GROUP BY month(s.saledate)
ORDER BY month(s.saledate);

/*
Q13. Product Cost Analysis
Using sales and products, calculate the estimated total product cost for each product.

Use:
Estimated Product Cost = Total Boxes Sold × Cost_per_box

Display:
- PID
- Product
- Cost_per_box
- Total Boxes
- Estimated Product Cost

Sort by Estimated Product Cost descending.

Concepts: JOIN, GROUP BY, arithmetic calculations, aliases.
*/

SELECT p.PID AS PID, p.Product AS Product, p.Cost_per_box AS Cost_per_box, COUNT(s.Boxes) AS 'Total Boxes', 
COUNT(s.Boxes)*p.Cost_per_box AS 'Estimated Product Cost' 
FROM sales s
INNER JOIN products p
on s.PID = p.PID
GROUP BY s.PID
ORDER BY 'Estimated Product Cost' DESC;

-- Find % of orders from each region
SELECT g.region, COUNT(s.geoid)/(SELECT Count(*) from sales s)*100 FROM geo g
INNER JOIN sales s
ON s.geoid = g.geoid
GROUP BY g.Region;

-- Find 2nd top sales person
SELECT p.Salesperson, SUM(s.amount) AS Sales
from people p
INNER JOIN sales s
ON s.SPID = p.SPID
GROUP BY s.SPID
ORDER BY Sales DESC
LIMIT 1 OFFSET 1;


/*
Q14. Revenue per Box
For every product, calculate:
- Product
- Total Sales
- Total Boxes
- Revenue per Box

Revenue per Box = Total Sales / Total Boxes

Sort products by Revenue per Box descending.
Handle division by zero appropriately.

Concepts: JOIN, GROUP BY, arithmetic calculations, NULLIF.
*/
SELECT p.Product As Product, COUNT(s.pid) as 'Total Sales', SUM(s.Boxes) as 'Total Boxes', (SUM(s.amount)/SUM(s.Boxes))as 'Revenue per Box' FROM products p
INNER JOIN sales s
ON s.pid = p.PID
GROUP BY s.pid 
ORDER BY 'Revenue per Box' DESC;

/*
Q15. Salesperson and Region Analysis
Using sales, people and geo, calculate total sales for each salesperson in each region.

Display:
- Salesperson
- Team
- Region
- Total Sales

Sort by Region and then Total Sales descending.

Concepts: multiple JOINs, GROUP BY, ORDER BY.
*/
SELECT p.Salesperson as Salesperson, p.Team,g.region, SUM(s.Amount) as 'Total Sales'  FROM geo g
INNER JOIN sales s
ON s.geoid = g.geoid
INNER JOIN people p
ON p.spid = s.spid
GROUP BY g.region
ORDER BY 'Total Sales' DESC
;

/*
Q16. High-Value Transactions by Category
Find product categories where the average transaction Amount is greater than 8,000.

Display:
- Category
- Number of transactions
- Average transaction amount
- Total sales amount

Only include categories with an average transaction amount greater than 8,000.

Concepts: JOIN, GROUP BY, AVG, SUM, COUNT, HAVING.

*/
SELECT p.Category as Category,COUNT(p.PID) as 'Number of transactions',AVG(s.amount) as 'Average transaction amount',SUM(s.amount) as 'Total sales amount' from sales s
INNER JOIN products p 
ON p.pid=s.pid
GROUP BY p.Category
HAVING AVG(s.amount)>8000;


-- Find monthly revenue,total sales for each region
select g.region, MONTH(s.SaleDate) as 'total sales' from geo g
INNER JOIN sales s 
ON s.geoid = g.geoid
GROUP BY g.region, MONTH(s.SaleDate);

/*
Q17. Salesperson Performance Classification
Using a CTE, calculate total sales for every salesperson.

Then classify each salesperson:
- Total Sales >= 1,000,000 → Excellent
- Total Sales >= 500,000 → Good
- Total Sales < 500,000 → Needs Improvement

Display:
- Salesperson
- Team
- Total Sales
- Performance

Sort by Total Sales descending.

Concepts: CTE, SUM, CASE, GROUP BY, ORDER BY.

*/








