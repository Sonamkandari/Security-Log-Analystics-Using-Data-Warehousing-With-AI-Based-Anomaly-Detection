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

IF OBJECT_ID('bronze.intrusion_detection', 'U') IS NOT NULL
    DROP TABLE bronze.intrusion_detection;
GO
CREATE TABLE bronze.intrusion_detection (
    session_id            VARCHAR(MAX),
    network_packet        VARCHAR(MAX),
    protocol_type         VARCHAR(MAX),
    login_attempts        VARCHAR(MAX),
    session_duration      VARCHAR(MAX),
    encryption_used       VARCHAR(MAX),
    ip_reputation_score   VARCHAR(MAX),
    failed_logins         VARCHAR(MAX),
    browser_type          VARCHAR(MAX),
    unusual_time_access   VARCHAR(MAX),
    attack_detected       VARCHAR(MAX)
);
GO





