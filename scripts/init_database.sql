/*
============================================
Create Database and Schemas
Scripts Purpose:
      This script creates a new database named 'DataWarehouse' after checking if it already exists.
      If the database exists, it is dropped and recreated. additionally, the script sets up three schemas
      within the database : 'bronze', 'silver', 'gold'
WARNING:
      Running this scripts will drop entire 'DataWarehouse' database if it exists.
      All data in the database will be permanently deleted. proceed with caution
      and ensure you have proper backups before running this script.
=============================================
*/

USE master;
GO

--Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.database WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

--create the 'DataWarehouse'

CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

--Create Schemas
CREATE SCHEMAS bronze;
GO

CREATE SCHEMA silver;
GO
  
CREATE SCHEMA gold;
GO
