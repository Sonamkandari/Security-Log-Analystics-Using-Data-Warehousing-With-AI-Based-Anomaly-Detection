

use SecurityLogsDW;
SELECT TOP 10  timestamp 
FROM bronze.intrusion_events;

-- validation query
SELECT COUNT(*)
FROM bronze.intrusion_events
WHERE TRY_CONVERT(INT, ip_address) IS NULL;

-- Check NULL values
SELECT COUNT(*) AS null_session_id
FROM bronze.intrusion_detection
WHERE session_id IS NULL;

-- Check empty strings (very important)
SELECT COUNT(*) AS empty_session_id
FROM bronze.intrusion_detection
WHERE LTRIM(RTRIM(session_id)) = '';

SELECT COUNT(*) AS session_id_with_spaces
FROM bronze.intrusion_detection
WHERE session_id <> LTRIM(RTRIM(session_id));

-- Check uniqueness (critical validation)
SELECT COUNT(DISTINCT session_id) AS distinct_session_ids,
       COUNT(*) AS total_rows
FROM bronze.intrusion_detection;

-- Find duplicate session IDs (if any)
SELECT session_id, COUNT(*) AS occurrence_count
FROM bronze.intrusion_detection
GROUP BY session_id
HAVING COUNT(*) > 1;

-- check formart consistency
SELECT COUNT(*) AS invalid_format_count
FROM bronze.intrusion_detection
WHERE session_id NOT LIKE 'SID_%';


SELECT TOP 10 session_id
FROM bronze.intrusion_detection;

-- Next colun Network packets 
-- (Check total rows)
SELECT COUNT(*) AS total_rows
FROM bronze.intrusion_detection;

-- Check NULL values
SELECT COUNT(*) AS null_network_packet
FROM bronze.intrusion_detection
WHERE network_packet IS NULL;

--  checking empty string
SELECT COUNT(*) AS empty_network_packet
FROM bronze.intrusion_detection
WHERE LTRIM(RTRIM(network_packet)) = ''; 

-- checking numeric validity
SELECT COUNT(*) AS non_numeric_network_packet
FROM bronze.intrusion_detection
WHERE TRY_CONVERT(INT, network_packet) IS NULL
  AND LTRIM(RTRIM(network_packet)) <> '';

-- checking value range
SELECT 
    MIN(TRY_CONVERT(INT, network_packet)) AS min_network_packet,
    MAX(TRY_CONVERT(INT, network_packet)) AS max_network_packet
FROM bronze.intrusion_detection;

-- looking for negative or weired values
SELECT COUNT(*) AS negative_network_packet
FROM bronze.intrusion_detection
WHERE TRY_CONVERT(INT, network_packet) < 0;

-- preview raw values

SELECT TOP 10 network_packet
FROM bronze.intrusion_detection;

-- next column protocol type
-- check null value
select COUNT(*) AS null_protocol_type
from bronze.intrusion_detection
where protocol_type is null;

-- Check empty strings
select COUNT(*) AS empty_protocol_type
from bronze.intrusion_detection
where LTRIM(RTRIM(protocol_type))='';

-- check distinct value
select distinct protocol_type
from bronze.intrusion_detection;

-- check value length
select 
    MAX(LEN(protocol_type)) as max_length
    from bronze.intrusion_detection;
-- Next columns login_attempts
-- check null values

SELECT COUNT(*) AS null_login_attempts
FROM bronze.intrusion_detection
WHERE login_attempts IS NULL;

-- check empty strings
select COUNT(*) as empty_login_attempts
from bronze.intrusion_Detection
where LTRIM(RTRIM(login_attempts))='';

-- check numeric validity
SELECT COUNT(*) AS non_numeric_login_attempts
FROM bronze.intrusion_detection
WHERE TRY_CONVERT(INT, login_attempts) IS NULL
  AND LTRIM(RTRIM(login_attempts)) <> '';

-- check the value range
SELECT 
    MIN(TRY_CONVERT(INT, login_attempts)) AS min_login_attempts,
    MAX(TRY_CONVERT(INT, login_attempts)) AS max_login_attempts
FROM bronze.intrusion_detection;


-- checking for negative value
SELECT COUNT(*) AS negative_login_attempts
FROM bronze.intrusion_detection
WHERE TRY_CONVERT(INT, login_attempts) < 0;

-- 

SELECT TOP 10 login_attempts
FROM bronze.intrusion_detection;


-- next column session_duration
SELECT COUNT(*) AS null_session_duration
FROM bronze.intrusion_detection
WHERE session_duration IS NULL;

-- 
SELECT COUNT(*) AS empty_session_duration
FROM bronze.intrusion_detection
WHERE LTRIM(RTRIM(session_duration)) = '';

-- 
SELECT COUNT(*) AS non_numeric_session_duration
FROM bronze.intrusion_detection
WHERE TRY_CONVERT(DECIMAL(18,6), session_duration) IS NULL
  AND LTRIM(RTRIM(session_duration)) <> '';


  --
  SELECT 
    MIN(TRY_CONVERT(DECIMAL(18,6), session_duration)) AS min_duration,
    MAX(TRY_CONVERT(DECIMAL(18,6), session_duration)) AS max_duration
FROM bronze.intrusion_detection;

-- checking negative values

SELECT COUNT(*) AS negative_session_duration
FROM bronze.intrusion_detection
WHERE TRY_CONVERT(DECIMAL(18,6), session_duration) < 0;

-- 
SELECT TOP 10 session_duration
FROM bronze.intrusion_detection;


-- next column encryption_used
-- check null values

SELECT COUNT(*) AS null_encryption
FROM bronze.intrusion_detection
WHERE encryption_used IS NULL;

-- 
SELECT COUNT(*) AS empty_encryption
FROM bronze.intrusion_detection
WHERE LTRIM(RTRIM(encryption_used)) = '';

--
SELECT DISTINCT encryption_used
FROM bronze.intrusion_detection;

-- check next column ip_reputation_score
-- check for null values

SELECT COUNT(*) AS null_ip_score
FROM bronze.intrusion_detection
WHERE ip_reputation_score IS NULL;

-- check numeric values
SELECT COUNT(*) AS non_numeric_ip_score
FROM bronze.intrusion_detection
WHERE TRY_CONVERT(DECIMAL(18,6), ip_reputation_score) IS NULL
  AND LTRIM(RTRIM(ip_reputation_score)) <> '';

-- check range
SELECT 
    MIN(TRY_CONVERT(DECIMAL(18,6), ip_reputation_score)) AS min_score,
    MAX(TRY_CONVERT(DECIMAL(18,6), ip_reputation_score)) AS max_score
FROM bronze.intrusion_detection;

-- next column failed_logins
SELECT COUNT(*) AS non_numeric_failed_logins
FROM bronze.intrusion_detection
WHERE TRY_CONVERT(INT, failed_logins) IS NULL
  AND LTRIM(RTRIM(failed_logins)) <> '';

  SELECT 
    MIN(TRY_CONVERT(INT, failed_logins)) AS min_failed,
    MAX(TRY_CONVERT(INT, failed_logins)) AS max_failed
FROM bronze.intrusion_detection;


-- next column browser type
SELECT DISTINCT browser_type
FROM bronze.intrusion_detection;

-- Treat Unknown as NULL (cleaner analytics)

-- next column unusual_time_ access
SELECT DISTINCT unusual_time_access
FROM bronze.intrusion_detection;

-- next column attack_detected
SELECT DISTINCT attack_detected
FROM bronze.intrusion_detection;

--

select * from silver.intrusion_detection;
