use SecurityLogsDW;
SELECT 
    login_timestamp,
    TRY_CONVERT(TIME, login_timestamp) AS cleaned_time
FROM bronze.login_attempts;


SELECT COUNT(*) AS total_rows
FROM bronze.login_attempts;


SELECT COUNT(*) AS null_time_rows
FROM bronze.login_attempts
WHERE TRY_CONVERT(TIME, login_timestamp) IS NULL;


SELECT 
    login_timestamp,
    TRY_CONVERT(TIME, '00:' + login_timestamp) AS fixed_time
FROM bronze.login_attempts;

SELECT TOP 10 * FROM bronze.login_attempts;


-- Now we are checking Round trip column

SELECT rtt_ms
FROM bronze.login_attempts
WHERE rtt_ms IS NOT NULL;

SELECT DISTINCT rtt_ms
FROM bronze.login_attempts
ORDER BY rtt_ms;

SELECT 
    rtt_ms,
    TRY_CONVERT(INT, NULLIF(rtt_ms, 'NaN')) AS cleaned_rtt
FROM bronze.login_attempts;

TRUNCATE TABLE silver.login_attempts;



SELECT TOP 20 login_time, rtt_ms
FROM silver.login_attempts;

-- Attack IP vs Failed Logins
SELECT is_attack_ip, COUNT(*) AS total
FROM silver.login_attempts
GROUP BY is_attack_ip;

SELECT is_attack_ip, login_successful, COUNT(*) AS total
FROM silver.login_attempts
GROUP BY is_attack_ip, login_successful
ORDER BY is_attack_ip;


-- Account Takeover Frequency
SELECT COUNT(*) AS takeover_count
FROM silver.login_attempts
WHERE is_account_takeover = 1;


-- moving to the column third ip_address
SELECT * FROM bronze.login_attempts;

SELECT TOP 20
    ip_address,
    '[' + ip_address + ']' AS original_value,
    '[' + LTRIM(RTRIM(ip_address)) + ']' AS trimmed_value
FROM bronze.login_attempts
WHERE ip_address <> LTRIM(RTRIM(ip_address));

SELECT COUNT(*) AS null_or_empty_ips
FROM bronze.login_attempts
WHERE ip_address IS NULL
   OR LTRIM(RTRIM(ip_address)) = '';

   SELECT COUNT(*) 
FROM bronze.login_attempts
WHERE ip_address <> LTRIM(RTRIM(ip_address));



SELECT TOP 20 ip_address
FROM bronze.login_attempts
WHERE ip_address NOT LIKE '%.%.%.%';

-- No changes required in this column

-- 

-- now check Country column

/*

Are they 2-letter codes? (US, NO, AU)
Any lowercase? (us, no)
Any NULL?
Any empty string?
Any strange values?


*/


SELECT TOP 20
    country,
    '[' + country + ']' AS original_value,
    '[' + LTRIM(RTRIM(country)) + ']' AS trimmed_value
FROM bronze.login_attempts
WHERE country <> LTRIM(RTRIM(country));

SELECT DISTINCT country
FROM bronze.login_attempts
ORDER BY country;

-- check for null or Empty
SELECT COUNT(*) AS null_or_empty_country
FROM bronze.login_attempts
WHERE country IS NULL
   OR LTRIM(RTRIM(country)) = '';


-- check for spaces
SELECT COUNT(*) AS space_issue
FROM bronze.login_attempts
WHERE country <> LTRIM(RTRIM(country));

-- 


--  move to Region column

-- check distinct values
SELECT DISTINCT region
FROM bronze.login_attempts
ORDER BY region;

/*  
Are there NULL values?
Any empty strings?
Any strange values?
Any lowercase vs uppercase inconsistency?
Any leading/trailing spaces?
*/

SELECT COUNT(*) AS null_or_empty_region
FROM bronze.login_attempts
WHERE region IS NULL
   OR LTRIM(RTRIM(region)) = '';


SELECT COUNT(*) AS space_issue_region
FROM bronze.login_attempts
WHERE region <> LTRIM(RTRIM(region));

-- Lets move to city column
SELECT DISTINCT city
FROM bronze.login_attempts
ORDER BY city;

-- check null and empty
SELECT COUNT(*) AS null_or_empty_city
FROM bronze.login_attempts
WHERE city IS NULL
   OR LTRIM(RTRIM(city)) = '';
--  check space issue
SELECT COUNT(*) AS space_issue_city
FROM bronze.login_attempts
WHERE city <> LTRIM(RTRIM(city));

-- Lets move to the  ASN column

/* 

Check:
Are they numeric?
Any NULL?
Any empty strings?
Any weird characters?
*/

SELECT DISTINCT asn
FROM bronze.login_attempts
ORDER BY asn;


-- Check Null / Empty

SELECT COUNT(*) AS null_or_empty_asn
FROM bronze.login_attempts
WHERE asn IS NULL
   OR LTRIM(RTRIM(asn)) = '';


--  Check If Convertible to INT

SELECT DISTINCT asn
FROM bronze.login_attempts
WHERE TRY_CONVERT(INT, asn) IS NULL
  AND asn IS NOT NULL;


-- lets move to the next column  browser_name
SELECT DISTINCT browser_name
FROM bronze.login_attempts
ORDER BY browser_name;


-- Check Null or Empty
SELECT COUNT(*) AS null_or_empty_browser
FROM bronze.login_attempts
WHERE browser_name IS NULL
   OR LTRIM(RTRIM(browser_name)) = '';

-- Check Space Issues
SELECT COUNT(*) AS space_issue_browser
FROM bronze.login_attempts
WHERE browser_name <> LTRIM(RTRIM(browser_name));


-- since brower name is a composite attribute of browser family and version so we devided it into different columns
---

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'silver'
AND TABLE_NAME = 'login_attempts';

---
--  now checking the next column os_name
-- Distinct OS Values
SELECT DISTINCT os_name
FROM silver.login_attempts
ORDER BY os_name;

-- checking null and empty
SELECT COUNT(*) AS null_or_empty_os
FROM silver.login_attempts
WHERE os_name IS NULL
   OR LTRIM(RTRIM(os_name)) = '';


-- Checking space isuues

select count(*) as spsce_issues_os
from silver.login_attempts
where os_name<>LTRIM(RTRIM(os_name));
----

SELECT distinct os_name
FROM silver.login_attempts order by os_name ;

SELECT DISTINCT os_name
FROM silver.login_attempts
WHERE TRY_CONVERT(INT, os_name) IS NOT NULL;

-- if get only a integer value replace it with null because getting only a integer value is not a valid operating system
-- done with the replacement

---
-- now lets move on next column Device type

-- 
SELECT *
FROM silver.login_attempts
WHERE login_successful = 0
AND is_account_takeover = 1;

-- Attack IP vs Failed Logins
SELECT is_attack_ip, COUNT(*) AS total
FROM silver.login_attempts
GROUP BY is_attack_ip;


SELECT is_attack_ip, login_successful, COUNT(*) AS total
FROM silver.login_attempts
GROUP BY is_attack_ip, login_successful
ORDER BY is_attack_ip;


-- Account Takeover Frequency
SELECT COUNT(*) AS takeover_count
FROM silver.login_attempts
WHERE is_account_takeover = 1;


------
select * from bronze.login_attempts;

EXEC bronze.usp_load_login_attempts;

EXEC silver.load_silver;


SELECT COUNT(*) 
FROM silver.login_attempts;


SELECT TOP 20 *
FROM silver.login_attempts;


select * from silver.login_attempts;

TRUNCATE TABLE silver.login_attempts;
EXEC silver.load_silver;
