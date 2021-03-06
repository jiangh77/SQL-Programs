/*

This file create a Database with data on Cryptocurrencies from coinmarketcap.com and Manipulates the data

This file demonstrates the following commands:

USE database

CREATE, DELETE, ALTER, TRUNCATE Table

CREATE and ADD PRIMARY keys and FOREIGN Keys

CREATE a TABLE using SELECT INTO

CREATE Views using INNER JOIN and CROSS JOIN

INNER JOIN, OUTER JOIN, LEFT OUTER JOIN, RIGHT OUTER JOIN and CROSS JOIN statements

ORDER BY

SELECT, INSERT, UPDADTE, DELETE rows

SELECT using AND, BETWEEN, OR, <>, IS NULL, IS NOT NULL

Built-in Functions: COUNT(), AVG() and SUM() Functions

DISTINCT statement

CASE ... WHEN ... THEN ... ELSE statement

BEGIN TRAN, COMMIT, ROLLBACK, EXECUTE

User Defined Procedures

SET NOCOUNT ON, SET NOCOUNT OFF

Check for Duplicates using COUNT(*), GROUP BY, HAVING COUNT(*)

TRUNCATE and DROP TABLE

*/

-- Find out which verson of SQL Server is running

SELECT @@VERSION

-- USE Cryptocurrency database

USE Cryptocurrency;

-- Create 1 table for top 10 cryptocurrencies listed on coinmarketcap.com

CREATE TABLE [Top 10 Crypto](
	Ranking INT NOT NULL,
	Symbol nvarchar (50) NOT NULL,
	Price decimal (20,2),
	Marketcap decimal (20,2),
	TotalSupply decimal (20,2),
	);
GO


-- Create 1 table for Sample Portfolio

CREATE TABLE Portfolio(
	Ranking INT NOT NULL,
	Symbol nvarchar (50) NOT NULL,
	Amount decimal (20, 2) NULL,
	[Purchase Price] decimal (20,2),
	[Selling Price] decimal (20,2),
	);
GO

-- Create 1 table for De-Fi (Decentralized Finanace) Coins listed on coinmarketcap.com

CREATE TABLE [De-Fi](
	Ranking INT NOT NULL,
	Symbol nvarchar (50) PRIMARY Key NOT NULL,
	Price decimal (20,2),
	Marketcap decimal (20,2),
	TotalSupply decimal (20,2),
	);
GO

-- Create a End table for testing purposes and CREATE a PRIMARY Key at the same time

CREATE TABLE End_Table(
	Ranking INT NOT NULL,
	Symbol varchar (50) NOT NULL,
	Amount decimal (10,3) NULL,
	CONSTRAINT PK_Coin PRIMARY KEY (Symbol)
	);
GO

-- Add PRIMARY KEY on [Top 10 Crypto] table based on the Symbol column

ALTER TABLE [Top 10 Crypto]
ADD CONSTRAINT PK_Rank PRIMARY KEY (Ranking);

-- Add foreign key to Portfolio table

ALTER TABLE Portfolio
ADD CONSTRAINT FK_Rank
FOREIGN KEY (Ranking) REFERENCES [Top 10 Crypto](Ranking);


/*
INSERT VALUES INTO table [Top 10 Crypto]
Price is in USD
Marketcap is in Billions
TotalSupply is in Millions
*/

INSERT INTO [Top 10 Crypto]
VALUES (1, 'BTC', 18321.69, 340.12, 18.57);

INSERT INTO [Top 10 Crypto](Ranking, Symbol, Price, Marketcap, TotalSupply)
VALUES (2, 'ETH', 553.89, 63.12, 113.80),
(3, 'XRP', 0.53, 24.12, 45404.03);

INSERT INTO [Top 10 Crypto]
VALUES (4, 'USDT', 1.00, 19.83, 19817);

INSERT INTO [Top 10 Crypto](Ranking, Symbol, Price, Marketcap, TotalSupply)
VALUES (5, 'BCH', 264.8, 1.92, 18.57),
(6, 'LTC', 74.66, 4.93, 66.07),
(7, 'LINK', 12.06, 4.78, 396.51),
(8, 'ADA', 0.15, 4.53, 311112.48),
(9, 'DOT', 4.74, 4.2, 886.96),
(10, 'BNB', 27.80, 4.01, 144.41);

SELECT * FROM [Top 10 Crypto];
SELECT * FROM [Top 10 Crypto] ORDER BY Ranking;

/*
INSERT VALUES INTO table [De-Fi]
Price is in USD
Marketcap is in Billions
TotalSupply is in Millions
*/

INSERT INTO [De-Fi] (Ranking, Symbol, Price, Marketcap, TotalSupply)
VALUES (1, 'LINK', 12.06, 4.78, 396.51),
(2, 'WBTC', 18321.69, 2.13, 0.12),
(3, 'DAI', 1.00, 1.07, 1063.63),
(4, 'AAVE', 77.97, 0.93, 11.97),
(5, 'UNI', 3.12, 0.78, 251.70);

SELECT * FROM [De-Fi];
SELECT * FROM [De-Fi] ORDER BY TotalSupply;

/*
INSERT VALUES INTO table Sample Portfolio
Price is in USD
*/

INSERT INTO Portfolio (Ranking, Symbol, Amount, [Purchase Price], [Selling Price])
VALUES (1, 'BTC', 0.7, 8000, 1000000),
(2, 'ETH', 1, 250, 15000),
(3, 'ADA', 17000, 0.12, 40),
(4, 'XLM', 3300, 0.4, 20),
(5, 'EOS', 247, 12.5, 1000);

SELECT * FROM Portfolio;

-- Find second highest Value in Amount column

SELECT MAX(Amount)
FROM Portfolio
WHERE Amount < (SELECT MAX(Amount) FROM Portfolio);

-- INSERT Values INTO End_Table

INSERT INTO End_Table (Ranking, Symbol, Amount) VALUES (1, 'BTC', 56.3567),
(2, 'ETH', 0.256),
(3, 'XRP', 15.25678);

/*
CREATE a TABLE using SELECT INTO
SELECT Top 5 Cryptocurrencies from Top 10 Crypto Table and Create a new table
*/

SELECT * INTO Top5
FROM [Top 10 Crypto]
WHERE Ranking <= 5;

SELECT * FROM Top5;
DROP TABLE Top5;


-- CREATE a VIEWS using INNER JOIN and CROSS JOIN

CREATE VIEW CoinMatch AS
SELECT [Top 10 Crypto].Ranking, [Top 10 Crypto].Marketcap, [Top 10 Crypto].Symbol
FROM [Top 10 Crypto]
INNER JOIN Portfolio
ON [Top 10 Crypto].Symbol = Portfolio.Symbol;

SELECT * FROM CoinMatch;

CREATE VIEW CoinMatch2 AS
SELECT [Top 10 Crypto].Ranking, [Top 10 Crypto].Marketcap, [Top 10 Crypto].Symbol
FROM [Top 10 Crypto] CROSS JOIN Portfolio;

SELECT * FROM CoinMatch2;

CREATE VIEW CoinMatch3 AS
SELECT [Top 10 Crypto].Ranking, [Top 10 Crypto].Symbol
FROM [Top 10 Crypto]
INNER JOIN Portfolio
ON [Top 10 Crypto].Symbol = Portfolio.Symbol;

SELECT * FROM CoinMatch3;


-- SELECT using LEFT and RIGHT OUTER JOIN and ORDER BY ASC and DSC

USE Cryptocurrency;

SELECT Portfolio, [Top 10 Crypto].Ranking, [Top 10 Crypto].Marketcap, [Top 10 Crypto].Symbol, Portfolio.[Purchase Price]
FROM [Top 10 Crypto]
INNER JOIN Portfolio
ON [Top 10 Crypto].Symbol = Portfolio.Symbol
WHERE Portfolio.Ranking = 1;

SELECT [Top 10 Crypto].Ranking, [Top 10 Crypto].Marketcap, Portfolio.[Purchase Price]
FROM [Top 10 Crypto]
INNER JOIN Portfolio
ON [Top 10 Crypto].Symbol = Portfolio.Symbol
WHERE Portfolio.Ranking = 1;

-- only shows the BTC record that exists in both tables and display related data in both tables, it works

SELECT [Top 10 Crypto].Ranking, [Top 10 Crypto].Marketcap, [Top 10 Crypto].Symbol, Portfolio.Amount, Portfolio.[Selling Price]
FROM [Top 10 Crypto]
INNER JOIN Portfolio
ON [Top 10 Crypto].Symbol = Portfolio.Symbol
WHERE [Top 10 Crypto].Ranking = 1;

-- only shows the BTC record that exists in both tables but only show requested data in one table, it works

SELECT [Top 10 Crypto].Ranking, [Top 10 Crypto].Marketcap, [Top 10 Crypto].Symbol
FROM [Top 10 Crypto]
LEFT OUTER JOIN Portfolio
ON [Top 10 Crypto].Symbol = Portfolio.Symbol
ORDER BY [Top 10 Crypto].Ranking ASC;

SELECT [Top 10 Crypto].Ranking, [Top 10 Crypto].Marketcap, [Top 10 Crypto].Symbol
FROM [Top 10 Crypto]
RIGHT OUTER JOIN Portfolio
ON [Top 10 Crypto].Symbol = Portfolio.Symbol
WHERE [Top 10 Crypto].Marketcap > 60
ORDER BY [Top 10 Crypto].Ranking ASC;

SELECT [Top 10 Crypto].Ranking, [Top 10 Crypto].Marketcap, [Top 10 Crypto].Symbol
FROM [Top 10 Crypto]
RIGHT OUTER JOIN Portfolio
ON [Top 10 Crypto].Symbol = Portfolio.Symbol
WHERE [Top 10 Crypto].Marketcap > 60
	AND [Top 10 Crypto].Price > 1000
ORDER BY [Top 10 Crypto].Ranking ASC;

SELECT [Top 10 Crypto].Ranking, [Top 10 Crypto].Marketcap, [Top 10 Crypto].Symbol
FROM [Top 10 Crypto]
RIGHT OUTER JOIN Portfolio
ON [Top 10 Crypto].Symbol = Portfolio.Symbol
WHERE [Top 10 Crypto].Marketcap > 60
	AND [Top 10 Crypto].Price > 1000
	AND [Top 10 Crypto].TotalSupply > 17
ORDER BY [Top 10 Crypto].Ranking ASC;

SELECT [Top 10 Crypto].Ranking, [Top 10 Crypto].Marketcap, [Top 10 Crypto].Symbol
FROM [Top 10 Crypto]
RIGHT OUTER JOIN Portfolio
ON [Top 10 Crypto].Symbol = Portfolio.Symbol
WHERE [Top 10 Crypto].Marketcap > 60
	AND [Top 10 Crypto].Price > 1000
	AND ([Top 10 Crypto].TotalSupply > 17)
ORDER BY [Top 10 Crypto].Ranking ASC;

SELECT [Top 10 Crypto].Ranking, [Top 10 Crypto].Marketcap, [Top 10 Crypto].Symbol
FROM [Top 10 Crypto]
RIGHT OUTER JOIN Portfolio
ON [Top 10 Crypto].Symbol = Portfolio.Symbol
WHERE [Top 10 Crypto].Marketcap > 60
	AND [Top 10 Crypto].Price > 1000
	AND ([Top 10 Crypto].TotalSupply > 17
		AND [Top 10 Crypto].TotalSupply <19)
ORDER BY [Top 10 Crypto].Ranking ASC;

SELECT [Top 10 Crypto].Ranking, [Top 10 Crypto].Marketcap, [Top 10 Crypto].Symbol
FROM [Top 10 Crypto]
RIGHT OUTER JOIN Portfolio
ON [Top 10 Crypto].Symbol = Portfolio.Symbol
WHERE [Top 10 Crypto].Marketcap > 60
	AND [Top 10 Crypto].Price > 1000
	AND [Top 10 Crypto].TotalSupply > 17
	AND [Top 10 Crypto].TotalSupply <19
ORDER BY [Top 10 Crypto].Ranking ASC;

-- works with and without ()

SELECT AVG(price)
FROM [Top 10 Crypto]
INNER JOIN Portfolio
ON [Top 10 Crypto].Ranking = Portfolio.Ranking

SELECT AVG(price)
FROM [Top 10 Crypto]
INNER JOIN Portfolio
ON [Top 10 Crypto].Ranking = Portfolio.Ranking
WHERE [Top 10 Crypto].Marketcap = 340.12
	AND Portfolio.[Purchase Price] NOT BETWEEN 50 AND 250;

-- SELECT using AND, BETWEEN, OR, <>, IS NULL, IS NOT NULL

SELECT Ranking, Symbol, Price
FROM [Top 10 Crypto]
WHERE Ranking < 5 AND Price > 300;

SELECT Ranking, Marketcap, TotalSupply
FROM [Top 10 Crypto]
WHERE Ranking BETWEEN 4 AND 8;

SELECT Ranking, Symbol, Price
FROM [De-Fi]
WHERE Ranking <> 5 OR Symbol = 'DAI';

SELECT * FROM Top5
WHERE Symbol IS NOT NULL;

SELECT * FROM Top5
WHERE Symbol IS NULL;

SELECT * FROM [Top 10 Crypto];
SELECT * FROM [De-Fi];
SELECT * FROM Portfolio;
SELECT * FROM End_Table;
SELECT * FROM Top5;


-- INSERT

INSERT INTO [De-Fi]
VALUES (6, 'FYI', 26061.23, 0.78, 0.029);

INSERT INTO [De-Fi]
VALUES (7, 'COMP', 148.61, 0.6, 4.37);


-- UPDATE

UPDATE [De-Fi]
SET Price = 25139.23
WHERE Symbol = 'FYI';

UPDATE [De-Fi]
SET Marketcap = 0.65
WHERE Ranking = 7;


-- DELETE

DELETE FROM [De-Fi]
WHERE Symbol = 'COMP';


-- Built-in Functions: COUNT, AVG, SUM Functions

SELECT COUNT(Symbol)
FROM [Top 10 Crypto]
WHERE Price > 300;

SELECT AVG(Price)
FROM [Top 10 Crypto]
WHERE Ranking < 5;

SELECT SUM(Marketcap)
FROM [Top 10 Crypto]
WHERE Symbol <> 'BTC';


-- DISTINCT Function

SELECT DISTINCT Symbol
FROM [De-Fi];


-- CASE ... WHEN ... THEN ... ELSE statement

SELECT * FROM [Top 10 Crypto];

SELECT Symbol, Ranking, Marketcap,
CASE
	WHEN Marketcap > 100 THEN 'The Marketcap of this coin is greater than $100 billion'
	WHEN Marketcap < 100 AND Marketcap >= 60 THEN 'The Marketcap of this coin is greater than $60 billion but less than $100 billion'
	WHEN Marketcap < 60 AND Marketcap >= 10 THEN 'The Marketcap of this coin is greater than $10 billion but less than $60 billion'
	ELSE 'The Marketcap of this coin is less than $10 billion'
END AS Comparison
FROM [Top 10 Crypto];


-- BEGIN TRAN, COMMIT, ROLLBACK, EXECUTE

BEGIN TRAN;

DELETE FROM [Top 10 Crypto]
WHERE Symbol = 'DOT';

COMMIT;

ROLLBACK;

SELECT * FROM [Top 10 Crypto];

INSERT INTO [Top 10 Crypto]
VALUES (9, 'DOT', 4.74, 4.2, 886.86);

INSERT INTO [Top 10 Crypto]
VALUES (10, 'BNB', 27.80, 4.01, 144.41);

SELECT * FROM [Top 10 Crypto]
ORDER BY Ranking;

SELECT * FROM Portfolio;

BEGIN TRAN;

DELETE FROM Portfolio
WHERE Ranking = 1;

ROLLBACK;

BEGIN TRAN;

INSERT INTO Portfolio
VALUES (6, 'TRX', 23000, 0.07, 10);

COMMIT;

SELECT * FROM Portfolio;


-- CREATE and EXECUTE User Defined Procedures

CREATE PROCEDURE Display
AS
SELECT * FROM Portfolio
WHERE Amount > 100;

GO

EXECUTE Display;


-- SET NOCOUNT ON, SET NOCOUNT OFF

SET NOCOUNT ON;

INSERT INTO [De-Fi]
VALUES (7, 'COMP', 148.61, 0.6, 4.37);

SET NOCOUNT OFF;

INSERT INTO [De-Fi]
VALUES (8, 'SNX', 5.25, 0.58, 110.48);

SELECT * FROM [De-Fi];


-- Check for Duplicates

SELECT Symbol,
COUNT (*) AS DUP
FROM [Top 10 Crypto]
GROUP BY Symbol
HAVING COUNT (*) > 1;


-- TRUNCATE and DROP End_Table

TRUNCATE TABLE End_Table;
DROP TABLE End_Table;


-- Testing to determine if End_Table still exists

SELECT * FROM End_Table;

-- the end
