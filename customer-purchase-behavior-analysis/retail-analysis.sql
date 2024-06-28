-- Create a new database
CREATE DATABASE retail_sales;

-- Select database as default schema
use retail_sales;

-- Create a table
CREATE TABLE sales_data(
  InvoiceNo VARCHAR(10),
  StockCode VARCHAR(20),
  Description TEXT,
  Quantity INT,
  InvoiceDate DATETIME,
  UnitPrice DECIMAL(10, 2),
  CustomerID INT,
  Country VARCHAR(50)
);

-- #### DATA ANALYSIS ####

-- View first five rows
SELECT *
FROM sales_data
LIMIT 5; 

-- ### Data Cleaning ###

-- Check for missing values
SELECT count(*) - count(Description) as MissingDesc, 
count(*) - count(CustomerID) as MissingCustID
FROM sales_data;

-- Remove missing customerid from data
DELETE FROM sales_data WHERE CustomerID IS NULL;

-- Check for duplicates
SELECT InvoiceNo, COUNT(*)
FROM sales_data
GROUP BY InvoiceNo
HAVING COUNT(*) > 1;

-- #### Exploratory data analysis (EDA) ####
SELECT MIN(Quantity),
       MAX(Quantity), 
       AVG(Quantity), 
       MIN(UnitPrice), 
       MAX(UnitPrice), 
       AVG(UnitPrice)
FROM sales_data;

-- ### Customer Analysis ###

-- Total spend by customer

SELECT CustomerID, SUM(quantity * unitprice) as TotalSpend
from sales_data
where CustomerID is not null
Group by CustomerID
order by TotalSpend desc
limit 10;

-- Average spend by customer

SELECT CustomerID, AVG(quantity * unitprice) as TotalSpend
from sales_data
where CustomerID is not null
Group by CustomerID
order by TotalSpend desc
limit 10;

-- Frequency of purchase.

select CustomerID, Count(distinct InvoiceNo) as PurchaseFreq
from sales_data
where CustomerID is not null
group by CustomerID
order by PurchaseFreq desc;


-- ### Product Analysis ###

-- Top selling product
SELECT Description, SUM(Quantity) as TotalQuantity
FROM sales_data
GROUP BY Description
order by TotalQuantity desc
limit 5;

-- Revenue by Product
SELECT Description, SUM(Quantity*UnitPrice) as TotalRevenue
FROM sales_data
GROUP BY Description
order by TotalRevenue desc
limit 5;

-- Sales over time
SELECT DATE(InvoiceDate) as date, 
sum(Quantity * UnitPrice) as total_sales
FROM sales_data
group by date;

-- Seasonal trends in Sales
select month(InvoiceDate) as month, sum(UnitPrice * Quantity) as total_sales
from sales_data
group by month(InvoiceDate)
order by total_sales desc;

-- Sales by Country
SELECT Country, SUM(Quantity * UnitPrice) AS TotalSales
FROM sales_data
GROUP BY Country
ORDER BY TotalSales DESC;

