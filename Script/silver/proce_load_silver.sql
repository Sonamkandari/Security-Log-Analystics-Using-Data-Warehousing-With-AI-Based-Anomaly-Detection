

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
use SecurityLogsDW;

go
CREATE OR ALTER PROCEDURE silver.load_silver 
AS
BEGIN 
    -- Duration tracking
    DECLARE @start_time DATETIME,
            @end_time DATETIME,
            @batch_start_time DATETIME,
            @batch_end_time DATETIME;

    SET @batch_start_time = GETDATE();

    BEGIN TRY

        PRINT '==================================';
        PRINT 'Loading Silver Layer';
        PRINT '==================================';

        PRINT '-----------------------------------------------------------------------------------';
        PRINT 'Inserting cleaned data into silver layer from Bronze layer (login_attempts)';
        PRINT '-----------------------------------------------------------------------------------';

        -- Truncate silver table
        PRINT '>> Truncating Table: silver.login_attempts';
        TRUNCATE TABLE silver.login_attempts;

        PRINT '>> Inserting Data Into: silver.login_attempts';

        SET @start_time = GETDATE();

        -- Insert cleaned data
           INSERT INTO silver.login_attempts(
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
            -- Fix timestamp (MM:SS.ms ? HH:MM:SS.ms)
            TRY_CONVERT(TIME, '00:' + login_timestamp),

            -- Clean RTT
            TRY_CONVERT(INT, NULLIF(rtt_ms, 'NaN')),

            -- Clean IP
            NULLIF(LTRIM(RTRIM(ip_address)), ''),

            -- Clean Country (keep ISO code)
            UPPER(NULLIF(LTRIM(RTRIM(country)), '')),

            -- Clean Region
            NULLIF(LTRIM(RTRIM(region)), ''),

            -- Clean City
            NULLIF(LTRIM(RTRIM(city)), ''),

            -- Convert ASN to INT
            TRY_CONVERT(INT, asn),

            -- Browser Family
            NULLIF(LTRIM(RTRIM(browser_name)), ''),
            CASE 
                WHEN browser_name LIKE 'Chrome%' THEN 'Chrome'
                WHEN browser_name LIKE 'Firefox%' THEN 'Firefox'
                WHEN browser_name LIKE 'Safari%' THEN 'Safari'
                WHEN browser_name LIKE 'Edge%' THEN 'Edge'
                ELSE 'Other'
            END,

            -- Browser Version
               CASE 
                WHEN CHARINDEX(' ', browser_name) > 0
                THEN RIGHT(browser_name, 
                           CHARINDEX(' ', REVERSE(browser_name)) - 1)
                ELSE NULL
            END,

            -- 1??1?? Validated OS Name (remove numeric-only garbage like 134)
            CASE 
                WHEN TRY_CONVERT(INT, LTRIM(RTRIM(os_name))) IS NOT NULL THEN NULL
                ELSE NULLIF(LTRIM(RTRIM(os_name)), '')
            END,

            -- 1??2?? Clean Device Type
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

        PRINT '>> Load Duration: ' 
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
              + ' seconds';

        SET @batch_end_time = GETDATE();

        PRINT '>> ------------------------------';
        PRINT 'Loading Silver Layer Completed';
        PRINT '>> Total Load Duration: '
              + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR)
              + ' seconds';
        PRINT '==============================================================';

    END TRY

    BEGIN CATCH

        PRINT '--------------------------------------------------------------';
        PRINT 'Error occurred during inserting data into Silver layer';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '--------------------------------------------------------------';

    END CATCH
END;

-- EXEC bronze.usp_load_login_attempts;
EXEC silver.load_silver;




