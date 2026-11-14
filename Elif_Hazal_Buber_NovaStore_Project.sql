-- PART 1: DATABASE DESIGN (DDL)

-- Task 1: Create the database
USE master;
GO

DROP DATABASE IF EXISTS NovaStoreDB;
GO

-- Turkish_CI_AS collation keeps Turkish characters (ş, ğ, ı, ü, ö, ç) intact in varchar columns.
CREATE DATABASE NovaStoreDB COLLATE Turkish_CI_AS;
GO

USE NovaStoreDB;
GO


-- Task 2: Create the tables

-- Task 2-A: Categories
-- CategoryID is an auto-increment primary key; CategoryName cannot be NULL.
CREATE TABLE Categories (
    CategoryID   INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL
);
GO

-- Task 2-B: Products
-- Stock defaults to 0; CategoryID is a foreign key to Categories.
CREATE TABLE Products (
    ProductID   INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price       DECIMAL(10,2),
    Stock       INT DEFAULT 0,
    CategoryID  INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);
GO

-- Task 2-C: Customers
-- Email is UNIQUE, so two customers cannot share the same e-mail address.
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FullName   VARCHAR(50),
    City       VARCHAR(20),
    Email      VARCHAR(100) UNIQUE
);
GO

-- Task 2-D: Orders
-- OrderDate defaults to the current date and time; CustomerID is a foreign key to Customers.
CREATE TABLE Orders (
    OrderID     INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID  INT,
    OrderDate   DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
GO

-- Task 2-E: OrderDetails (junction table)
-- Links Orders and Products: one order can contain many products,
-- and one product can appear in many orders.
CREATE TABLE OrderDetails (
    DetailID  INT IDENTITY(1,1) PRIMARY KEY,
    OrderID   INT,
    ProductID INT,
    Quantity  INT,
    FOREIGN KEY (OrderID)   REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

-- PART 2: DATA ENTRY (DML - INSERT)

-- Task 1: Insert 5 categories
INSERT INTO Categories (CategoryName) VALUES
(N'Elektronik'),
(N'Giyim'),
(N'Kitap'),
(N'Kozmetik'),
(N'Ev ve Yaşam');
GO

-- Task 2: Insert 13 products (at least 2 per category)
INSERT INTO Products (ProductName, Price, Stock, CategoryID) VALUES
(N'Kablosuz Kulaklık',    1250.00,  35, 1),
(N'Akıllı Saat',          2799.90,  15, 1),
(N'Bluetooth Hoparlör',    899.50,   8, 1),
(N'Erkek Tişört',          249.90, 120, 2),
(N'Kadın Mont',           1499.00,  18, 2),
(N'Spor Ayakkabı',        1899.00,  12, 2),
(N'Suç ve Ceza',            95.00,  60, 3),
(N'Sefiller',              120.00,  25, 3),
(N'Nutuk',                  85.50,   5, 3),
(N'Nemlendirici Krem',     189.90,  40, 4),
(N'Parfüm',                650.00,  14, 4),
(N'Nevresim Takımı',       799.00,  22, 5),
(N'Elektrikli Süpürge',   3499.00,   6, 5);
GO

-- Task 3: Insert 6 customers
INSERT INTO Customers (FullName, City, Email) VALUES
(N'Elif Büber', N'İstanbul', 'elif.buber@mail.com'),
(N'Elif Demir', N'Ankara',   'elif.demir@mail.com'),
(N'Hazal Kaya', N'İzmir',    'hazal.kaya@mail.com'),
(N'Ali Çelik', N'Antalya',  'ali.celik@mail.com'),
(N'Zeynep Aydın', N'Bursa',    'zeynep.aydin@mail.com'),
(N'Ramazan Şahin', N'İstanbul', 'ramazan.sahin@mail.com');
GO

-- Task 4: Insert 10 orders on different dates
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount) VALUES
(1, '2026-09-05', 1440.00),   -- OrderID 1
(1, '2026-10-12',  749.70),   -- OrderID 2
(2, '2026-09-18', 2799.90),   -- OrderID 3
(2, '2026-10-25', 1029.80),   -- OrderID 4
(3, '2026-10-03', 2398.80),   -- OrderID 5
(4, '2026-10-30',  919.00),   -- OrderID 6
(5, '2026-11-02', 1799.00),   -- OrderID 7
(3, '2026-11-05', 3499.00),   -- OrderID 8
(6, '2026-11-08', 1670.00),   -- OrderID 9
(4, '2026-11-10', 1439.90);   -- OrderID 10
GO

-- Task 4: Insert the order details (which products are in which order)
INSERT INTO OrderDetails (OrderID, ProductID, Quantity) VALUES
(1, 1, 1),    -- Kablosuz Kulaklık x1
(1, 7, 2),    -- Suç ve Ceza x2
(2, 4, 3),    -- Erkek Tişört x3
(3, 2, 1),    -- Akıllı Saat x1
(4, 10, 2),   -- Nemlendirici Krem x2
(4, 11, 1),   -- Parfüm x1
(5, 6, 1),    -- Spor Ayakkabı x1
(5, 4, 2),    -- Erkek Tişört x2
(6, 12, 1),   -- Nevresim Takımı x1
(6, 8, 1),    -- Sefiller x1
(7, 3, 2),    -- Bluetooth Hoparlör x2
(8, 13, 1),   -- Elektrikli Süpürge x1
(9, 5, 1),    -- Kadın Mont x1
(9, 9, 2),    -- Nutuk x2
(10, 1, 1),   -- Kablosuz Kulaklık x1
(10, 10, 1);  -- Nemlendirici Krem x1
GO

-- PART 3: QUERYING AND ANALYSIS (DQL)

-- Question 1: Products with stock below 20, sorted by stock in descending order
SELECT ProductName, Stock
FROM Products
WHERE Stock < 20
ORDER BY Stock DESC;
GO

-- Question 2: Which customer placed an order on which date? (INNER JOIN)
SELECT c.FullName     AS CustomerName,
       c.City         AS City,
       o.OrderDate    AS OrderDate,
       o.TotalAmount  AS TotalAmount
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
ORDER BY o.OrderDate;
GO

-- Question 3: Name, price and category of the products bought by "Elif Büber"
SELECT c.FullName        AS CustomerName,
       p.ProductName     AS ProductName,
       p.Price           AS Price,
       cat.CategoryName  AS Category
FROM Customers c
JOIN Orders o        ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID    = od.OrderID
JOIN Products p      ON od.ProductID = p.ProductID
JOIN Categories cat  ON p.CategoryID = cat.CategoryID
WHERE c.FullName = N'Elif Büber';
GO

-- Question 4: How many products are in each category? (LEFT JOIN + GROUP BY + COUNT)
SELECT cat.CategoryName AS Category, COUNT(p.ProductID)  AS ProductCount
FROM Categories cat
LEFT JOIN Products p ON cat.CategoryID = p.CategoryID
GROUP BY cat.CategoryName
ORDER BY ProductCount DESC;
GO

-- Question 5: Total revenue per customer, from highest to lowest (SUM)
SELECT c.FullName AS CustomerName, SUM(o.TotalAmount) AS TotalRevenue
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.FullName
ORDER BY TotalRevenue DESC;
GO

-- Question 6: Days passed since each order (DATEDIFF + GETDATE)
SELECT OrderID, OrderDate, DATEDIFF(DAY, OrderDate, GETDATE()) AS DaysPassed
FROM Orders
ORDER BY OrderDate;
GO

-- PART 4: ADVANCED DATABASE OBJECTS

-- Task 1: Create the vw_SiparisOzet view
-- Shows customer name, order date, product name and quantity in a single result.
-- CREATE VIEW must be the first statement in its batch, so it comes right after a GO.
CREATE VIEW vw_SiparisOzet AS
SELECT c.FullName     AS CustomerName,
       o.OrderDate    AS OrderDate,
       p.ProductName  AS ProductName,
       od.Quantity    AS Quantity
FROM Customers c
JOIN Orders o        ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID    = od.OrderID
JOIN Products p      ON od.ProductID = p.ProductID;
GO

-- Test the view
SELECT * FROM vw_SiparisOzet ORDER BY OrderDate;
GO

-- Task 2: Back up the database

-- Task 2-A: Windows version (as requested in the assignment).
-- Requires the folder C:\Yedek\ to exist. This will fail on Docker/Linux.
BACKUP DATABASE NovaStoreDB
TO DISK = 'C:\Yedek\NovaStoreDB.bak'
WITH FORMAT, INIT, NAME = 'NovaStoreDB Full Backup';
GO

-- Task 2-B: Linux/Docker version (used when SQL Server runs in a Linux container).
-- /var/opt/mssql/data/ is a folder inside the container.
BACKUP DATABASE NovaStoreDB
TO DISK = '/var/opt/mssql/data/NovaStoreDB.bak'
WITH FORMAT, INIT, NAME = 'NovaStoreDB Full Backup';
GO