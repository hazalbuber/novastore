# NovaStore – E-Commerce Database Project

[Türkçe sürüm](README.tr.md)

A relational database for a fictional online store called NovaStore, written in T-SQL for SQL Server. The project covers database design, sample data, analysis queries, a view and a backup. It is the final project of an SQL training course.

## What's Inside

| File                                  | Description                                                                    |
| ------------------------------------- | ------------------------------------------------------------------------------ |
| `ElifHazalBuber_NovaStore_Proje.sql`  | The full script: tables, sample data, queries, view and backup                 |
| `ElifHazalBuber_NovaStore_Proje.docx` | Project report (in Turkish) with the code, result screenshots and explanations |
| `ElifHazalBuber_NovaStore_Proje.png`  | Relational diagram of the tables                                               |

## Database Design

The database is called `NovaStoreDB` and has five tables:

- **Categories**: product categories
- **Products**: products with price and stock, linked to a category
- **Customers**: customers with a unique e-mail address
- **Orders**: orders linked to a customer
- **OrderDetails**: junction table that links orders and products

![Relational diagram](ElifHazalBuber_NovaStore_Proje.png)

## Script Contents

1. **Database design (DDL):** creates `NovaStoreDB` and the five tables with primary keys, foreign keys, a unique e-mail, a default stock value and a default order date.
2. **Sample data (DML):** 5 categories, 13 products, 6 customers, 10 orders and 16 order detail rows.
3. **Queries (DQL):**
   - Products with stock below 20, sorted by stock (descending)
   - Customers and their order dates (`INNER JOIN`)
   - Products bought by a given customer (five-table `JOIN`)
   - Number of products per category (`LEFT JOIN`, `GROUP BY`, `COUNT`)
   - Total revenue per customer (`SUM`, `GROUP BY`)
   - Days passed since each order (`DATEDIFF`, `GETDATE`)
4. **Advanced objects:** the view `vw_SiparisOzet` and a full database backup (`BACKUP DATABASE`).

## How to Run

The script was run on SQL Server in a Docker container and used from Visual Studio Code with the SQL Server (mssql) extension.

1. Start SQL Server in Docker (replace the password with your own):
   ```bash
   docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=YourStrong!Passw0rd" \
     -p 1433:1433 --name sqlserver -d mcr.microsoft.com/mssql/server:2022-latest
   ```
2. In VS Code, connect to `localhost,1433` with the user `sa` and your password.
3. Open `ElifHazalBuber_NovaStore_Proje.sql` and run it (the whole file or one query at a time by selecting it).

Notes:

- The script starts with `DROP DATABASE IF EXISTS NovaStoreDB`, so running it again recreates the database from scratch.
- The assignment asks for a backup to `C:\Yedek\`, which is a Windows path. The script contains that version and a Linux/Docker version that writes to `/var/opt/mssql/data/`. Inside Docker only the Linux version works.
- The result of the "days passed" query depends on the day it is run.

