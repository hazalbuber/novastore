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