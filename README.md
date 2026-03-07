# 🛡 Security Log Analytics Using Data Warehousing with AI-Based Anomaly Detection

A capstone project focused on building a structured security analytics pipeline using **SQL-based data warehousing**, **layered transformation architecture**, and **AI-ready security data preparation**.

---

## 📌 Project Status

**Current Development Stage:** Bronze Layer + Silver Layer Implemented
**Gold Layer / AI Detection / Dashboard:** In Progress

---

## 📖 Project Overview

Modern systems generate extremely large volumes of authentication logs and security events every day.
Manual analysis of such data is inefficient, slow, and often unreliable when suspicious behavior must be identified quickly.

This project addresses that problem by designing a structured **security data warehouse** that prepares raw security logs for analytics and anomaly detection.

The system uses:

* Layered warehousing architecture
* SQL-based ETL pipelines
* Structured transformation logic
* Security-oriented data validation

The final long-term goal is to support:

* abnormal login detection
* suspicious IP identification
* intrusion pattern analytics
* AI-based anomaly detection

---

## 🎯 Project Objectives

The project aims to:

* Build a multi-layered security data warehouse
* Integrate multiple security datasets
* Preserve raw source data safely
* Standardize login and intrusion data
* Prepare analytics-ready structured security records
* Support future anomaly detection models

---

## 🏗 Architecture Overview

The project follows a layered medallion-style data architecture:

```text
Source Data
   ↓
Bronze Layer (Raw Ingestion)
   ↓
Silver Layer (Cleaned & Structured Data)
   ↓
Gold Layer (Analytics Ready)   [In Progress]
   ↓
AI Anomaly Detection           [In Progress]
```

---

## 📂 Data Sources

Two datasets are currently integrated into the warehouse.

---

### Dataset 1: Risk-Based Authentication Login Dataset

This dataset contains login activity records.

Main attributes include:

* login timestamp
* IP address
* country
* region
* city
* ASN
* browser name
* operating system
* device type
* login success status
* attack IP indicator
* account takeover flag

Used for login security analytics.

---

### Dataset 2: Intrusion Detection Dataset

This dataset contains intrusion session records.

Main attributes include:

* session id
* protocol type
* login attempts
* session duration
* encryption usage
* failed logins
* IP reputation score
* attack detected flag

Used for intrusion event analytics.

---

## 🗄 Database Setup

Database platform:

**Microsoft SQL Server**

Database name:

```sql
SecurityLogsDW
```

---

## Database Initialization

The database setup script performs:

* existing database detection
* forced single-user mode if database exists
* complete database recreation
* schema creation

Schemas created:

* bronze
* silver
* gold

---

## ⚠ Important Warning

Running the setup script deletes the full existing warehouse database.

Use only in development or testing environments.

---

## Database Creation Script

```sql
USE master;

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'SecurityLogsDW')
BEGIN
    ALTER DATABASE SecurityLogsDW SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE SecurityLogsDW;
END;

CREATE DATABASE SecurityLogsDW;
```

---

## Schema Creation

```sql
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;
```

---

# 🥉 Bronze Layer – Raw Data Ingestion

The Bronze layer stores source data exactly as received.

No transformations are applied here.

Purpose:

* preserve raw source integrity
* enable traceability
* support repeatable ETL

All source fields are intentionally stored as text.

---

## Bronze Tables Implemented

---

### bronze.login_attempts

Stores raw login activity records.

Columns:

* login_timestamp
* rtt_ms
* ip_address
* country
* region
* city
* asn
* browser_name
* os_name
* device_type
* login_successful
* is_attack_ip
* is_account_takeover

---

### bronze.intrusion_detection

Stores raw intrusion session records.

Columns:

* session_id
* network_packet
* protocol_type
* login_attempts
* session_duration
* encryption_used
* ip_reputation_score
* failed_logins
* browser_type
* unusual_time_access
* attack_detected

---

## Bronze Layer Loading Process

A stored procedure is used for ingestion.

Procedure:

```sql
bronze.usp_load_login_attempts
```

---

## Bronze Load Logic

The procedure performs:

* truncates existing bronze tables
* bulk inserts login dataset
* bulk inserts intrusion dataset
* skips header rows
* uses UTF-8 encoding
* handles errors using TRY...CATCH

---

## Example Execution

```sql
EXEC bronze.usp_load_login_attempts;
```

---

## Source Files Used

```text
C:\data\rba-dataset.csv
C:\data\cybersecurity_intrusion_data.csv
```

---

# 🥈 Silver Layer – Cleaned and Structured Data

The Silver layer transforms Bronze data into validated structured records.

This layer improves:

* data quality
* consistency
* reliability

---

## Silver Layer Purpose

The Silver layer performs:

* type conversion
* null handling
* text normalization
* field validation
* feature extraction

---

## Silver Tables Implemented

---

### silver.login_attempts

Structured login records.

Columns include:

* login_time
* rtt_ms
* ip_address
* country
* region
* city
* asn
* browser_name
* browser_family
* browser_version
* os_name
* device_type
* login_successful
* is_attack_ip
* is_account_takeover

---

### silver.intrusion_detection

Structured intrusion records.

Columns include:

* session_id
* network_packet
* protocol_type
* login_attempts
* session_duration
* encryption_used
* ip_reputation_score
* failed_logins
* browser_type
* unusual_time_access
* attack_detected
* source_system

---

## Silver Layer ETL Procedure

Procedure:

```sql
silver.load_silver
```

---

## Example Execution

```sql
EXEC silver.load_silver;
```

---

## Silver Transformations Applied

---

### Login Data Transformations

---

#### Timestamp Conversion

```sql
TRY_CONVERT(TIME, '00:' + login_timestamp)
```

---

#### RTT Cleaning

```sql
TRY_CONVERT(INT, NULLIF(rtt_ms, 'NaN'))
```

---

#### Country Standardization

```sql
UPPER(NULLIF(LTRIM(RTRIM(country)), ''))
```

---

#### Browser Family Extraction

Chrome, Firefox, Safari, Edge classification.

---

#### Browser Version Extraction

Version parsed from browser string.

---

#### OS Validation

Numeric-only invalid OS values removed.

---

#### Device Type Normalization

Lowercase conversion applied.

---

#### Security Flags Converted to BIT

Applied to:

* login_successful
* is_attack_ip
* is_account_takeover

---

### Intrusion Data Transformations

---

#### Numeric Conversion

Applied to:

* network_packet
* login_attempts
* failed_logins

---

#### Protocol Standardization

Converted to uppercase.

---

#### Encryption Handling

NONE converted to NULL.

---

#### Browser Cleanup

UNKNOWN converted to NULL.

---

#### Attack Flags Converted to BIT

Applied to:

* unusual_time_access
* attack_detected

---

#### Source Lineage Added

```sql
INTRUSION_DETECTION_CSV
```

---

## Load Monitoring Features

Silver procedure includes:

* execution time tracking
* batch timing
* step-by-step progress messages
* error handling

---

## Current Implementation Summary

Implemented:

* Database creation
* Bronze schema
* Silver schema
* Bronze load procedure
* Silver ETL procedure

In Progress:

* Gold layer
* anomaly detection
* dashboard
* chatbot

---

## 🚀 Next Planned Phase

Upcoming work:

* Gold analytical tables
* anomaly feature generation
* AI model integration
* dashboard visualization
* chatbot analytics layer

---

## 📄 License

This project is currently under repository license terms.
