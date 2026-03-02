
/*
what i had done here
============================================================================
stored procedure: load silver layer (Bronze-> silver )
============================================================================
what my Script is doing:
     This script procedure performs the ETL (Extract,Transform,Load) Process
	 to populate the 'silver' schema tables from the 'bronze'schema
Actions Performed:
     - Truncate silver tables
	 - Inserts transformed and cleared data from Bronze into silver tables
Parameters:
      None.
	  This stored procedure does not accept any parameters or return any values,
Usage example;
       EXEC silver.load_silver;
==============================================================================
*/

/*  In the Silver layer, we clean and validate the raw login data received from the Bronze layer.
	This includes converting timestamps and numeric fields to proper data types, handling missing or 
	invalid values, normalizing text fields such as browser and OS names, identifying private IP 
	addresses, and converting login flags into boolean values. Only validated and standardized 
	records are loaded into the Silver tables, making the data reliable for further analysis.
*/


-- Created stored procedures
/*
============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
============================================================================
This procedure performs ETL from Bronze to Silver layer.
============================================================================
*/

USE SecurityLogsDW;
GO

CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN
    SET NOCOUNT ON;

    -- =====================================================
    -- Variable Declarations (MUST BE FIRST)
    -- =====================================================
    DECLARE 
        @start_time        DATETIME,
        @end_time          DATETIME,
        @batch_start_time  DATETIME,
        @batch_end_time    DATETIME;

    SET @batch_start_time = GETDATE();

    BEGIN TRY

        PRINT '==================================';
        PRINT 'Loading Silver Layer';
        PRINT '==================================';

        /* =====================================================
           PART 1: Silver.login_attempts
        ===================================================== */

        PRINT '>> Truncating Table: silver.login_attempts';
        TRUNCATE TABLE silver.login_attempts;

        SET @start_time = GETDATE();

        INSERT INTO silver.login_attempts (
            login_time,
            rtt_ms,
            ip_address,
            country,
            region,
            city,
            asn,
            browser_name,
            browser_family,
            browser_version,
            os_name,
            device_type,
            login_successful,
            is_attack_ip,
            is_account_takeover
        )
        SELECT 
            TRY_CONVERT(TIME, '00:' + login_timestamp),
            TRY_CONVERT(INT, NULLIF(rtt_ms, 'NaN')),
            NULLIF(LTRIM(RTRIM(ip_address)), ''),
            UPPER(NULLIF(LTRIM(RTRIM(country)), '')),
            NULLIF(LTRIM(RTRIM(region)), ''),
            NULLIF(LTRIM(RTRIM(city)), ''),
            TRY_CONVERT(INT, asn),
            NULLIF(LTRIM(RTRIM(browser_name)), ''),
            CASE 
                WHEN browser_name LIKE 'Chrome%' THEN 'Chrome'
                WHEN browser_name LIKE 'Firefox%' THEN 'Firefox'
                WHEN browser_name LIKE 'Safari%' THEN 'Safari'
                WHEN browser_name LIKE 'Edge%' THEN 'Edge'
                ELSE 'Other'
            END,
            CASE 
                WHEN CHARINDEX(' ', browser_name) > 0
                THEN RIGHT(browser_name, CHARINDEX(' ', REVERSE(browser_name)) - 1)
                ELSE NULL
            END,
            CASE 
                WHEN TRY_CONVERT(INT, LTRIM(RTRIM(os_name))) IS NOT NULL THEN NULL
                ELSE NULLIF(LTRIM(RTRIM(os_name)), '')
            END,
            LOWER(NULLIF(LTRIM(RTRIM(device_type)), '')),
            CASE WHEN login_successful = '1' THEN 1
                 WHEN login_successful = '0' THEN 0
                 ELSE NULL END,
            CASE WHEN is_attack_ip = '1' THEN 1
                 WHEN is_attack_ip = '0' THEN 0
                 ELSE NULL END,
            CASE WHEN is_account_takeover = '1' THEN 1
                 WHEN is_account_takeover = '0' THEN 0
                 ELSE NULL END
        FROM bronze.login_attempts;

        SET @end_time = GETDATE();
        PRINT '>> login_attempts load time: '
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
              + ' seconds';

        /* =====================================================
           PART 2: Silver.intrusion_detection
        ===================================================== */

        PRINT '>> Truncating Table: silver.intrusion_detection';
        TRUNCATE TABLE silver.intrusion_detection;

        SET @start_time = GETDATE();

        INSERT INTO silver.intrusion_detection (
            session_id,
            network_packet,
            protocol_type,
            login_attempts,
            session_duration,
            encryption_used,
            ip_reputation_score,
            failed_logins,
            browser_type,
            unusual_time_access,
            attack_detected,
            source_system
        )
        SELECT
            NULLIF(LTRIM(RTRIM(session_id)), ''),
            TRY_CONVERT(INT, network_packet),
            UPPER(NULLIF(LTRIM(RTRIM(protocol_type)), '')),
            TRY_CONVERT(INT, login_attempts),
            TRY_CONVERT(DECIMAL(18,6), session_duration),
            CASE 
                WHEN encryption_used IS NULL THEN NULL
                WHEN UPPER(LTRIM(RTRIM(encryption_used))) = 'NONE' THEN NULL
                ELSE UPPER(LTRIM(RTRIM(encryption_used)))
            END,
            TRY_CONVERT(DECIMAL(18,6), ip_reputation_score),
            TRY_CONVERT(INT, failed_logins),
            CASE 
                WHEN browser_type IS NULL THEN NULL
                WHEN UPPER(LTRIM(RTRIM(browser_type))) = 'UNKNOWN' THEN NULL
                ELSE LTRIM(RTRIM(browser_type))
            END,
            CASE 
                WHEN unusual_time_access = '1' THEN 1
                WHEN unusual_time_access = '0' THEN 0
                ELSE NULL
            END,
            CASE 
                WHEN attack_detected = '1' THEN 1
                WHEN attack_detected = '0' THEN 0
                ELSE NULL
            END,
            'INTRUSION_DETECTION_CSV'
        FROM bronze.intrusion_detection;

        SET @end_time = GETDATE();
        PRINT '>> intrusion_detection load time: '
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
              + ' seconds';

        SET @batch_end_time = GETDATE();

        PRINT '==================================';
        PRINT 'Silver Layer Load Completed';
        PRINT 'Total batch time: '
              + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR)
              + ' seconds';
        PRINT '==================================';

    END TRY
    BEGIN CATCH
        PRINT 'ERROR OCCURRED DURING SILVER LOAD';
        PRINT ERROR_MESSAGE();
        THROW;
    END CATCH
END;
GO

EXEC silver.load_silver;
