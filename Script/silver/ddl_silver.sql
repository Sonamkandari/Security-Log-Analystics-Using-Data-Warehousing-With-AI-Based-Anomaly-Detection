
/*
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DDL script: Create Silver Tables
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Script Purpose:
     This script creates tables in the 'silver' schema,dropping existing tables 
     if they already exist.
     Run this script to re-define the DDL structure of 'bronze' Tables
=============================================================================== 
*/

use SecurityLogsDW;


IF OBJECT_ID('silver.login_attempts', 'U') IS NOT NULL
    DROP TABLE silver.login_attempts;
GO

CREATE TABLE silver.login_attempts (
    login_time           TIME,
    rtt_ms               INT,
    ip_address           VARCHAR(45),
    country              VARCHAR(10),
    region               VARCHAR(100),
    city                 VARCHAR(100),
    asn                  VARCHAR(50),
    browser_name         VARCHAR(100),
    browser_family VARCHAR(100),
    browser_version VARCHAR(100),
    os_name              VARCHAR(100),
    device_type          VARCHAR(50),
    login_successful     BIT,
    is_attack_ip         BIT,
    is_account_takeover  BIT
);
GO

IF OBJECT_ID('silver.intrusion_detection', 'U') IS NOT NULL
    DROP TABLE silver.intrusion_detection;
GO

CREATE TABLE silver.intrusion_detection (
    session_id            VARCHAR(50),        -- Session identifier (SID_00001)
    network_packet        INT,                -- Packet count / metric
    protocol_type         VARCHAR(10),         -- TCP / UDP / ICMP
    login_attempts        INT,                -- Number of login attempts
    session_duration      DECIMAL(18,6),       -- Session duration
    encryption_used       VARCHAR(20),         -- AES / DES / NULL
    ip_reputation_score   DECIMAL(18,6),       -- Risk score (0–1)
    failed_logins         INT,                -- Failed login count
    browser_type          VARCHAR(50),         -- Chrome / Firefox / Edge
    unusual_time_access   BIT,                -- Boolean flag
    attack_detected       BIT,                -- Ground-truth attack label
    source_system         VARCHAR(50)          -- Data lineage
);
GO



