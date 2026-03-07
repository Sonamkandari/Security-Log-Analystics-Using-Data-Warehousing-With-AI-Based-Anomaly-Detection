# Security Log Analytics Using Data Warehousing with AI-Based Anomaly Detection

A capstone project focused on building a structured security analytics pipeline using **SQL-based data warehousing**, **layered transformation architecture**, and **AI-ready security data preparation**.

---

## Project Status

**Current Development Stage:** Bronze Layer + Silver Layer Implemented
**Gold Layer / AI Detection / Dashboard:** In Progress

---

##  Project Overview

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

##  Project Objectives

The project aims to:

* Build a multi-layered security data warehouse
* Integrate multiple security datasets
* Preserve raw source data safely
* Standardize login and intrusion data
* Prepare analytics-ready structured security records
* Support future anomaly detection models

---

##  Architecture Overview

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

##  Data Sources

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

##  Database Setup

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

##  Important Warning

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

#  Bronze Layer – Raw Data Ingestion

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

#  Silver Layer – Cleaned and Structured Data

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
#  Gold Layer – Analytics and Security Intelligence

## Overview

The Gold layer transforms cleaned security records from the Silver layer into **analytics-ready security summaries**.

Unlike the Silver layer, which focuses on cleaning and validation, the Gold layer focuses on:

* aggregation
* security pattern summarization
* risk scoring
* feature generation for anomaly detection

This layer represents the first business-facing analytical layer of the warehouse.

---

## Purpose of the Gold Layer

The Gold layer was designed to:

* generate summarized login intelligence
* identify high-risk IP behavior
* measure failure rates across dimensions
* prepare structured outputs for AI anomaly detection
* support dashboards and chatbot explanations

---

## Gold Layer Data Flow

```text id="n4gr6u"
Silver Layer
   ↓
Gold Analytical Tables
   ↓
AI Anomaly Detection
```

---

## Gold Tables Implemented

The following analytical tables were created in the `gold` schema.

---

## 1. `gold.login_fact`

This is the core analytical fact table for login behavior.

It stores login activity in a flattened analytical structure.

### Columns

| Column Name         | Description           |
| ------------------- | --------------------- |
| login_hour          | Extracted login hour  |
| ip_address          | Login IP              |
| country             | Country code          |
| region              | Region                |
| city                | City                  |
| browser_family      | Browser family        |
| os_name             | Operating system      |
| device_type         | Device type           |
| login_successful    | Login success flag    |
| is_attack_ip        | Attack IP flag        |
| is_account_takeover | Account takeover flag |

---

## Purpose

This table supports flexible downstream analysis such as:

* hourly login patterns
* region-based analysis
* device behavior analysis

---

## 2. `gold.login_time_summary`

This table summarizes login behavior by hour.

### Columns

| Column Name   | Description          |
| ------------- | -------------------- |
| login_hour    | Hour of login        |
| total_logins  | Total login attempts |
| failed_logins | Failed login count   |
| attack_logins | Attack IP count      |
| failure_rate  | Failure percentage   |

---

## Purpose

Used to identify:

* unusual login hours
* high-risk time windows
* failed login concentration

---

## 3. `gold.ip_risk_summary`

This table summarizes security behavior by IP address.

### Columns

| Column Name     | Description           |
| --------------- | --------------------- |
| ip_address      | Login IP              |
| total_attempts  | Total login attempts  |
| failed_attempts | Failed attempts       |
| attack_attempts | Attack IP occurrences |
| failure_rate    | Failure percentage    |
| risk_level      | LOW / MEDIUM / HIGH   |

---

## Risk Classification Logic

Risk levels are assigned using login behavior:

* **HIGH** → attack attempts greater than 5
* **MEDIUM** → failed attempts greater than 5
* **LOW** → otherwise

---

## Purpose

This table supports:

* suspicious IP identification
* attack concentration analysis

---

## 4. `gold.geo_risk_summary`

This table summarizes geographic login risk.

### Columns

| Column Name   | Description        |
| ------------- | ------------------ |
| country       | Country            |
| region        | Region             |
| total_logins  | Total logins       |
| failed_logins | Failed logins      |
| attack_logins | Attack logins      |
| failure_rate  | Failure percentage |

---

## Purpose

Used for:

* country-level risk analysis
* region-level attack concentration

---

## 5. `gold.device_risk_summary`

This table summarizes device and browser behavior.

### Columns

| Column Name    | Description        |
| -------------- | ------------------ |
| device_type    | Device category    |
| browser_family | Browser family     |
| total_logins   | Total logins       |
| failed_logins  | Failed logins      |
| attack_logins  | Attack logins      |
| failure_rate   | Failure percentage |

---

## Purpose

Used to detect:

* suspicious device patterns
* browser-related anomalies

---

## 6. `gold.intrusion_session_summary`

This table summarizes intrusion records by protocol.

### Columns

| Column Name          | Description                            |
| -------------------- | -------------------------------------- |
| protocol_type        | TCP / UDP / ICMP                       |
| total_sessions       | Total sessions                         |
| avg_session_duration | Average duration                       |
| avg_failed_logins    | Average failed logins                  |
| detected_attacks     | Total attacks                          |
| high_risk_sessions   | Sessions with high IP reputation score |

---

## Purpose

Used for:

* intrusion protocol analysis
* high-risk session monitoring

---

# Gold Layer Loading Procedure

## Stored Procedure

The Gold layer is populated using:

```sql id="g7mq0l"
EXEC gold.load_gold;
```

---

## What the Procedure Performs

The procedure performs:

* truncates existing Gold tables
* loads analytical summaries from Silver layer
* calculates failure rates
* classifies IP risk levels
* aggregates intrusion sessions

---

## Gold Layer Aggregations Applied

---

## Login Fact Creation

The login hour is extracted from cleaned login time:

```sql id="9wlnd6"
DATEPART(HOUR, login_time)
```

---

## Failure Rate Calculation

Failure rates are calculated using:

```sql id="p55y8n"
ROUND(
    CAST(SUM(CASE WHEN login_successful = 0 THEN 1 ELSE 0 END) AS FLOAT)
    / COUNT(*) * 100, 2
)
```

---

## IP Risk Classification

Risk level logic:

```sql id="c8pn2x"
CASE
    WHEN attack_attempts > 5 THEN 'HIGH'
    WHEN failed_attempts > 5 THEN 'MEDIUM'
    ELSE 'LOW'
END
```

---

## Intrusion High-Risk Session Detection

High-risk sessions are identified using:

```sql id="vh1r7f"
ip_reputation_score > 0.7
```

---

# Gold Layer Validation Queries

Example queries used to verify outputs:

```sql id="1l4r9s"
SELECT * FROM gold.login_time_summary;
SELECT * FROM gold.ip_risk_summary;
SELECT * FROM gold.geo_risk_summary;
SELECT * FROM gold.device_risk_summary;
SELECT * FROM gold.intrusion_session_summary;
```

---

# Current Output of the Gold Layer

At this stage, the warehouse can answer:

* Which login hours are risky
* Which IPs show repeated failures
* Which regions have abnormal attack rates
* Which devices show suspicious behavior
* Which intrusion protocols are high risk

---

#  AI Anomaly Detection Layer

## Overview

After generating structured analytical outputs in the Gold layer, the next stage of the project applies **AI-based anomaly detection** to identify unusual security behavior.

The anomaly detection layer uses **Isolation Forest**, an unsupervised machine learning algorithm designed to detect rare or abnormal patterns without requiring labeled attack data.

This layer works on top of Gold-layer summaries because Gold tables already contain aggregated risk signals that are suitable for anomaly analysis.

---

## Why Isolation Forest Was Used

Isolation Forest is suitable for this project because:

* it works well on unlabeled security data
* it isolates rare behavior efficiently
* it performs well on high-volume security logs
* it detects anomalies without predefined attack rules

---

## Python Backend

The anomaly detection backend is implemented in:

```text id="o8i6ly"
Anomaly Detection Backend/
└── anomaly_detection_gold.py
```

---

## What the Python Backend Does

The Python script connects anomaly detection with Gold-layer outputs.

It performs the following tasks:

* reads analytical data
* selects risk features
* trains Isolation Forest
* detects anomalies
* exports anomaly result files

---

## Input Used for AI Detection

The model uses Gold-layer analytical summaries such as:

* login hour summaries
* IP risk summaries
* geography summaries
* device summaries
* intrusion session summaries

---

## Output Files Generated

The anomaly detection process creates separate output files for each security dimension.

```text id="2p1q9v"
ip_anomaly_results.csv
time_anomaly_results.csv
geo_anomaly_results.csv
device_anomaly_results.csv
session_anomaly_results.csv
```

---

## Meaning of Output Files

Each output file contains:

* original analytical values
* anomaly label
* detected abnormal behavior

Typical anomaly output:

* `1` → anomaly detected
* `0` → normal behavior

---

## Security Questions Answered by AI Layer

The anomaly outputs help answer:

* which IP addresses behave abnormally
* which login hours are unusual
* which regions show suspicious activity
* which devices are uncommon
* which intrusion sessions are high risk

---

#  React Security Dashboard

## Overview

To make anomaly outputs easier to interpret visually, a React dashboard was developed.

The dashboard reads anomaly result files and converts them into security charts.

---

## Frontend Folder Structure

```text id="8j24w4"
Anomaly Detection React/
```

---

## Main Frontend Components

```text id="hqlcb7"
src/components/
```

Includes:

* ChartCard.jsx
* CountryAttackChart.jsx
* DeviceCharts.jsx
* HighRiskRegions.jsx
* KPICards.jsx
* LoginBreakdown.jsx
* ProtocolAnalysis.jsx

---

## Dashboard Purpose

The dashboard provides visual answers to:

* where attacks are concentrated
* which countries are risky
* which devices fail more
* which protocols show abnormal activity

---

## KPI Layer

The KPI cards summarize:

* total anomalies
* suspicious IP count
* risky sessions
* attack concentration

---

## Data Source for Dashboard

Dashboard CSV files are stored in:

```text id="o8lmb9"
public/data/
```

---

## Files Used

```text id="k2h5rj"
device_anomaly_results.csv
geo_anomaly_results.csv
ip_anomaly_results.csv
session_anomaly_results.csv
time_anomaly_results.csv
```

---

## Frontend Utility Layer

The React project includes utility functions for:

* loading CSV files
* preprocessing anomaly data
* feeding chart components

Located in:

```text id="x8k6qg"
src/utils/
```

Includes:

* loadCSV.js
* dataProcessing.js

---

#  AI Security Chatbot

## Overview

A conversational chatbot was added so users can ask security-related questions directly.

This allows anomaly results to be explained in simple language.

---

## Chatbot Location

```text id="g4pkzw"
Anomaly_Detection/
└── security_chatbot_app.py
```

---

## Technology Used

The chatbot is built using:

Streamlit

---

## What the Chatbot Does

The chatbot reads anomaly result files and answers questions such as:

* Show suspicious IPs
* Which regions are risky?
* When do attacks happen?
* Are mobile devices risky?
* Show session anomalies

---

## Chatbot Logic

The chatbot works by:

* reading anomaly CSV outputs
* matching user question keywords
* returning anomaly explanation

---

## Current Chatbot Scope

The chatbot currently supports project-related security questions.

It is designed as an explainable AI layer rather than a general-purpose chatbot.

---

## Example Security Insight

A user can ask:

```text id="3a1z3f"
Which regions are risky?
```

The chatbot responds using anomaly output from:

```text id="vduq85"
geo_anomaly_results.csv
```

---

#  Repository Structure

Current repository organization:

```text id="2lm0kk"
SECURITY-LOG-ANALYTICS-USING-DATA-WAREHOUSING-WITH-AI-BASED-ANOMALY-DETECTION

├── Anomaly Detection Backend
│   └── anomaly_detection_gold.py

├── Anomaly Detection React
│   ├── public/data/
│   ├── src/components/
│   ├── src/utils/

├── Anomaly_Detection
│   ├── code.ipynb
│   ├── security_chatbot_app.py
│   ├── anomaly result csv files

├── Script
├── Source Data File
├── Tests
├── Document
```

---

#  Current System Capability

At this stage, the full system can:

* ingest raw security logs
* clean and validate records
* generate risk summaries
* detect anomalies using AI
* visualize threats
* explain anomalies conversationally

---

#  Next Improvement Areas

Planned future enhancements:

* real-time anomaly scoring
* SQL-to-Python pipeline automation
* live dashboard refresh
* stronger chatbot reasoning
* API integration



