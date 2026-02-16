/*

============================================
Create database and schemas
============================================

Script purpose:
This script creates a new database named 'SecurityLogsDW' after checking if it already exists.
If the database exists, it drops and recreated. Additionally, the script sets up the three schemas
within the database: bronze, silver, and gold.

Warning:
Running this script will drop the entire data warehouse database if it exists. 
All data in the database will permanently be deleted. Proceed with caution 
and ensure you have proper backups before running this script 

*/


USE master;
 
 
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'SecurityLogsDW')
BEGIN
  ALTER DATABASE SecurityLogsDW SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE SecurityLogsDW;
END;

create database SecurityLogsDW;
USE SecurityLogsDW;
GO

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

if object_id('bronze.login_attempts','U') is not null
drop table bronze.login_attempts;
go

CREATE TABLE bronze.login_attempts (
   
    login_timestamp     VARCHAR(max),
    rtt_ms              VARCHAR(max),
    ip_address          VARCHAR(max),
    country             VARCHAR(max),
    region              VARCHAR(max),
    city                VARCHAR(100),
    asn                 VARCHAR(100),
    browser_name        VARCHAR(MAX),
    os_name             VARCHAR(MAX),
    device_type         VARCHAR(100),
    login_successful    VARCHAR(50),
    is_attack_ip        VARCHAR(50),
    is_account_takeover VARCHAR(50)
);

if object_id('bronze.login_attempts','U') is not null
drop table bronze.intrusion_events;
GO

CREATE TABLE bronze.intrusion_events (
    timestamp         VARCHAR(MAX),
    ip_address        VARCHAR(MAX),
    protocol          VARCHAR(MAX),
    attack_type       VARCHAR(MAX),
    severity          VARCHAR(MAX),
    intrusion_flag    VARCHAR(MAX),
    packet_size       VARCHAR(MAX),
    src_port          VARCHAR(MAX),
    dst_port          VARCHAR(MAX)
);
GO





