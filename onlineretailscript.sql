create database retail;
use retail;

-- creating table using query becaue this platform didnt support the data types and now we will change data types manually later 

CREATE TABLE onlineretail (
  InvoiceNo VARCHAR(20),
  StockCode VARCHAR(20),
  Description TEXT,
  Quantity INT,
  InvoiceDate VARCHAR(30),  -- store as text first
  UnitPrice DECIMAL(10,2),
  CustomerID VARCHAR(20),
  Country VARCHAR(50)
);

-- manually loading data set using path 
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/online_retail.csv'
INTO TABLE onlineretail
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country);

SELECT * FROM onlineretail;

SELECT DATABASE();
SELECT * FROM onlineretail;

CREATE TABLE onlineretail2 LIKE onlineretail;

SELECT * FROM onlineretail2;

INSERT onlineretail2
SELECT * FROM onlineretail;

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY InvoiceNo, StockCode, `Description`, Quantity, InvoiceDate, UnitPrice, CustomerID, Country) AS row_num
FROM onlineretail2;


WITH duplicate_CTE AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY InvoiceNo, StockCode, `Description`, Quantity, InvoiceDate, UnitPrice, CustomerID, Country) AS row_num
FROM onlineretail2
)
SELECT * FROM duplicate_CTE
WHERE row_num>3;

SELECT * FROM onlineretail2
WHERE StockCode=22698 and InvoiceNo=555524 and Quantity=1 and InvoiceDate='6/5/2011 11:37' and UnitPrice='2.95'
and CustomerID=16923 and Country='United Kingdom';


WITH duplicate_CTE AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY InvoiceNo, StockCode, `Description`, Quantity, InvoiceDate, UnitPrice, CustomerID, Country) AS row_num
FROM onlineretail2
)
DELETE FROM duplicate_CTE
WHERE row_num>15;


CREATE TABLE `onlineretail3` (
  `InvoiceNo` varchar(20) DEFAULT NULL,
  `StockCode` varchar(20) DEFAULT NULL,
  `Description` text,
  `Quantity` int DEFAULT NULL,
  `InvoiceDate` varchar(30) DEFAULT NULL,
  `UnitPrice` decimal(10,2) DEFAULT NULL,
  `CustomerID` varchar(20) DEFAULT NULL,
  `Country` varchar(50) DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM onlineretail3;

INSERT INTO onlineretail3
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY InvoiceNo, StockCode, `Description`, Quantity, InvoiceDate, UnitPrice, CustomerID, Country) AS row_num
FROM onlineretail2;

SELECT * FROM onlineretail3
WHERE row_num>1;
	
DELETE FROM onlineretail3
WHERE row_num>1;

SELECT * FROM onlineretail3;

alter table onlineretail3
drop column row_num;

CREATE TABLE online_retail_cleaned AS
SELECT *
FROM onlineretail3;

select * from online_retail_cleaned;
drop table onlineretail3;
rename table online_retail_cleaned to onlineretailNoDuplicateRows;

select * from onlineretailNoDuplicateRows;
select count(*) from onlineretailNoDuplicateRows;



SELECT count(*)
FROM onlineretail2;

select * from onlineretailNoDuplicateRows;
select InvoiceNo , StockCode from onlineretailNoDuplicateRows 
order by  InvoiceNo , StockCode asc ;

select InvoiceNo, `Description`, Quantity from onlineretailNoDuplicateRows
where `Description` is null and  Quantity<0 ;

select InvoiceNo, `Description`, Quantity from onlineretailNoDuplicateRows
where  InvoiceNo like 'c%';

Update onlineretailNoDuplicateRows
set CustomerID =null
where CustomerID='null';

select * from onlineretailNoDuplicateRows
where CustomerID is null;

select * from onlineretailNoDuplicateRows
where UnitPrice='0.0' and CustomerID is null 
order by InvoiceNo desc;


SELECT InvoiceNo, Quantity, UnitPrice, CustomerID, COUNT(*) AS rows_in_invoice
FROM onlineretailNoDuplicateRows
WHERE InvoiceNo LIKE 'C%'
GROUP BY InvoiceNo, Quantity, UnitPrice, CustomerID
ORDER BY InvoiceNo, Quantity;

SELECT InvoiceNo,UnitPrice from onlineretailNoDuplicateRows
where InvoiceNo=581406 and  UnitPrice>0;


-- Select invoices that do NOT start with 'C' and contain any alphabet letters
SELECT DISTINCT InvoiceNo
FROM onlineretailNoDuplicateRows
WHERE InvoiceNo NOT LIKE 'C%'
  AND InvoiceNo REGEXP '[A-Za-z]';
  
SELECT *
FROM onlineretailNoDuplicateRows
WHERE InvoiceNo IN ('A563185', 'A563186', 'A563187');

