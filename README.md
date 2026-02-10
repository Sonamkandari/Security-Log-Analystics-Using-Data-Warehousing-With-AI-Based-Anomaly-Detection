# Security-Log-Analystics-Using-Data-Warehousing-With-AI-Based-Anomaly-Detection

# 🔐 SecurityLogsDW

> A SQL Server data warehouse project for ingesting and organizing security login logs  
> **Status:** 🚧 Work in Progress (Bronze Layer Completed)

---

## 👋 About This Project

**SecurityLogsDW** is a hands-on data warehouse project where I’m building a system to store and later analyze **login attempt security logs**.

The idea behind this project is simple:
start with raw data, store it safely, and then gradually transform it into something meaningful using a **Bronze → Silver → Gold (Medallion Architecture)** approach.

Right now, the focus is on building a strong foundation — database setup and raw data ingestion.

---

## 🏗️ Architecture Approach

This project follows the Medallion Architecture pattern:
---
<img width="1367" height="602" alt="image" src="https://github.com/user-attachments/assets/fae5fe61-212e-4b42-8edb-461e80690fac" />

---

Only the **Bronze layer** is implemented so far.

---

## 🗄️ Database Setup

- **Database Name:** `SecurityLogsDW`
- **Platform:** Microsoft SQL Server

The setup script:
- Checks if the database already exists
- Drops and recreates it if found
- Creates three schemas:
  - `bronze`
  - `silver`
  - `gold`

⚠️ **Important Note**  
Running the setup script will permanently delete the existing database and all its data.  
It’s meant for development/testing purposes.

---

## 📥 Bronze Layer – Raw Login Data
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

## ⚙️ Loading Data into Bronze Layer

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

