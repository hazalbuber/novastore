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

