#  Security Log Analytics Using Data Warehousing & AI

> A capstone project focused on security login analytics using data warehousing and AI-based anomaly detection  
> **Status:**  Work in Progress  
> **Current Phase:** Bronze Layer Completed

---

##  About the Project

This project aims to build a **security log analytics system** that helps identify suspicious and abnormal login behavior using a combination of **data warehousing, analytics, and basic AI models**.

Modern systems generate massive volumes of authentication logs, making manual analysis impractical. This project addresses that problem by storing login data in a structured **data warehouse** and gradually transforming it into analytics-ready datasets that can be used to detect potential security threats such as:
- Repeated failed login attempts  
- Suspicious IP addresses  
- Unusual login times  
- Possible account takeover behavior  

At the moment, the project focuses on building a **strong data foundation** by ingesting raw login data into the **Bronze layer** of the warehouse.

---

##  Project Objective

The long-term objective of this project is to:

- Design a layered data warehouse for security logs  
- Clean and standardize login data for analysis  
- Apply basic AI / anomaly detection techniques to learn normal login behavior  
- Automatically flag suspicious or abnormal login patterns  
- Visualize insights using dashboards and charts  

---

##  Architecture Overview (Medallion Approach)

The project follows the **Medallion Architecture**, which helps keep data reliable, traceable, and scalable.


---
<img width="1367" height="602" alt="image" src="https://github.com/user-attachments/assets/fae5fe61-212e-4b42-8edb-461e80690fac" />

---

Only the **Bronze layer** is implemented so far.

---

##  Database Setup

- **Database Name:** `SecurityLogsDW`
- **Platform:** Microsoft SQL Server

The setup script:
- Checks if the database already exists
- Drops and recreates it if found
- Creates three schemas:
  - `bronze`
  - `silver`
  - `gold`

 **Important Note**  
Running the setup script will permanently delete the existing database and all its data.  
It’s meant for development/testing purposes.

---

##  Bronze Layer – Raw Login Data
<img width="710" height="604" alt="image" src="https://github.com/user-attachments/assets/91c6a24b-21f3-4215-a225-87ec55e43bf3" />

### Table: `bronze.login_attempts`

The Bronze layer stores login data **exactly as it comes from the source file**, without any transformations.  
This makes it easier to trace back to the original data if something goes wrong later.

All columns are intentionally stored as `VARCHAR`.

| Column Name | Description |
|------------|------------|
| login_timestamp | Time of login attempt |
| rtt_ms | Network round-trip time |
| ip_address | User IP address |
| country | Country of login |
| region | Region or state |
| city | City |
| asn | Autonomous System Number |
| browser_name | Browser used |
| os_name | Operating system |
| device_type | Device type |
| login_successful | Login success flag |
| is_attack_ip | Indicates suspicious IP |
| is_account_takeover | Account takeover flag |

---

##  Loading Data into Bronze Layer

### Stored Procedure


This stored procedure handles the raw data load process:

- Truncates the existing Bronze table
- Loads fresh data from a CSV file using `BULK INSERT`
- Skips the header row
- Uses `TRY...CATCH` blocks for error handling
- Prints progress messages during execution

### Source File Location


### How to Run
```sql
EXEC bronze.usp_load_login_attempts;
```
---
---

## Silver Layer – Data Cleaning and Standardization

### Overview

The Silver layer is responsible for transforming raw login data from the Bronze layer into clean, validated, and structured data.  
This layer focuses on improving data quality and enforcing consistency so that the data can be reliably used for analytics and AI-based anomaly detection.

Unlike the Bronze layer, which stores data exactly as received, the Silver layer applies controlled transformations while still preserving the original meaning of the data.

---

### Purpose of the Silver Layer

The Silver layer was designed to:

- Convert raw string values into appropriate data types
- Remove invalid and inconsistent values
- Standardize text-based fields
- Validate logical consistency of security flags
- Extract structured features from browser-related data
- Prepare data for aggregation and modeling in the Gold layer

---

### Silver Layer Architecture

Bronze (Raw Data) → Silver (Cleaned and Structured Data)

> **Add Silver Layer Data Flow Diagram Here**  
> (Diagram should show Bronze table feeding into Silver transformations)

---

### Table: `silver.login_attempts`

The Silver table stores cleaned and validated login data with proper data types.

| Column Name | Data Type | Description |
|------------|----------|-------------|
| login_time | TIME | Converted login timestamp |
| rtt_ms | INT | Cleaned network round-trip time |
| ip_address | VARCHAR | Trimmed IP address |
| country | VARCHAR | Standardized country code |
| region | VARCHAR | Cleaned region |
| city | VARCHAR | Cleaned city |
| asn | INT | Converted ASN |
| browser_name | VARCHAR | Cleaned browser string |
| browser_family | VARCHAR | Extracted browser family |
| browser_version | VARCHAR | Extracted browser version |
| os_name | VARCHAR | Validated operating system |
| device_type | VARCHAR | Normalized device type |
| login_successful | BIT | Login success indicator |
| is_attack_ip | BIT | Suspicious IP indicator |
| is_account_takeover | BIT | Account takeover indicator |

---

## Silver Layer Transformations

### 1. Timestamp Conversion

The original login timestamp was stored as text.  
It was converted into SQL `TIME` format for consistency.

```sql
TRY_CONVERT(TIME, '00:' + login_timestamp)
```

### 2. RTT (Round Trip Time) Cleaning
> Invalid RTT values such as NaN were handled safely.
```
TRY_CONVERT(INT, NULLIF(rtt_ms, 'NaN'))
```
### 3. Text Field Cleaning
> Leading and trailing spaces were removed from all relevant text columns.
```
NULLIF(LTRIM(RTRIM(column_name)), '')

```
### 4. Country Standardization
> Country codes were standardized to uppercase to avoid case mismatches.
```
UPPER(NULLIF(LTRIM(RTRIM(country)), ''))
```

### 5. Region and City Cleaning
> Region and city values were cleaned without altering their meaning.
```
NULLIF(LTRIM(RTRIM(region)), '')
NULLIF(LTRIM(RTRIM(city)), '')

```
### 6. ASN Conversion
> ASN values were converted from text to integer format.
```
TRY_CONVERT(INT, asn)
```
### 7. Browser Data Structuring
> Browser information was preserved and enriched by extracting structured components.
```
NULLIF(LTRIM(RTRIM(browser_name)), '')

```
- Browser Family Extraction
```
CASE 
    WHEN browser_name LIKE 'Chrome%' THEN 'Chrome'
    WHEN browser_name LIKE 'Firefox%' THEN 'Firefox'
    WHEN browser_name LIKE 'Safari%' THEN 'Safari'
    WHEN browser_name LIKE 'Edge%' THEN 'Edge'
    ELSE 'Other'
END

```
- Browser Version Extraction
```
CASE 
    WHEN CHARINDEX(' ', browser_name) > 0
    THEN RIGHT(browser_name, 
               CHARINDEX(' ', REVERSE(browser_name)) - 1)
    ELSE NULL
END

```
- Browser Transformation Diagram

---
### 8. Operating System Validation
> The os_name column contained invalid numeric-only values (e.g., 134).
Such values were removed to prevent invalid OS data.

```
CASE 
    WHEN LTRIM(RTRIM(os_name)) NOT LIKE '%[A-Za-z]%' THEN NULL
    ELSE NULLIF(LTRIM(RTRIM(os_name)), '')
END

```
### 9. Device Type Normalization
> Device type values were standardized to lowercase.
```
LOWER(NULLIF(LTRIM(RTRIM(device_type)), ''))
```
### 10. Security Flag Validation
> Login-related flags were converted into BIT values.
```
CASE 
    WHEN login_successful = '1' THEN 1
    WHEN login_successful = '0' THEN 0
    ELSE NULL
END

```
- The same logic was applied to:
### is_attack_ip
### is_account_takeover
- Logical checks were performed to ensure no inconsistent combinations exist.
---
## Loading Data into the Silver Layer
### Stored Procedure
- The Silver layer is populated using the following stored procedure:
```
EXEC silver.load_silver;
```
---
## This stored procedure performs the following actions:

- Truncates the Silver table before each load  
- Cleans and transforms data from the Bronze layer  
- Validates column values and data types  
- Extracts structured features (such as browser family and version)  
- Handles errors using `TRY...CATCH` blocks  
- Tracks execution time for monitoring and debugging  
