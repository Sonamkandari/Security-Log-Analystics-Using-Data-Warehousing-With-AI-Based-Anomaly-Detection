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

