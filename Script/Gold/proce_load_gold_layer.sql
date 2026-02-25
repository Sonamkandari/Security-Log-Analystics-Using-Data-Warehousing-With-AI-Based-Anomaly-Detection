
use SecurityLogsDW;
go
CREATE OR ALTER PROCEDURE gold.load_gold
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        PRINT '==================================';
        PRINT 'Loading Gold Layer';
        PRINT '==================================';

        /* =====================================
           1. Login Fact
        ===================================== */
        TRUNCATE TABLE gold.login_fact;

        INSERT INTO gold.login_fact
        SELECT
            DATEPART(HOUR, login_time),
            ip_address,
            country,
            region,
            city,
            browser_family,
            os_name,
            device_type,
            login_successful,
            is_attack_ip,
            is_account_takeover
        FROM silver.login_attempts;

        /* =====================================
           2. Time Risk Summary
        ===================================== */
        TRUNCATE TABLE gold.login_time_summary;

        INSERT INTO gold.login_time_summary
        SELECT
            DATEPART(HOUR, login_time),
            COUNT(*),
            SUM(CASE WHEN login_successful = 0 THEN 1 ELSE 0 END),
            SUM(CASE WHEN is_attack_ip = 1 THEN 1 ELSE 0 END),
            ROUND(
                CAST(SUM(CASE WHEN login_successful = 0 THEN 1 ELSE 0 END) AS FLOAT)
                / COUNT(*) * 100, 2
            )
        FROM silver.login_attempts
        GROUP BY DATEPART(HOUR, login_time);

        /* =====================================
           3. IP Risk Summary
        ===================================== */
        TRUNCATE TABLE gold.ip_risk_summary;

        INSERT INTO gold.ip_risk_summary
        SELECT
            ip_address,
            COUNT(*),
            SUM(CASE WHEN login_successful = 0 THEN 1 ELSE 0 END),
            SUM(CASE WHEN is_attack_ip = 1 THEN 1 ELSE 0 END),
            ROUND(
                CAST(SUM(CASE WHEN login_successful = 0 THEN 1 ELSE 0 END) AS FLOAT)
                / COUNT(*) * 100, 2
            ),
            CASE
                WHEN SUM(CASE WHEN is_attack_ip = 1 THEN 1 ELSE 0 END) > 5 THEN 'HIGH'
                WHEN SUM(CASE WHEN login_successful = 0 THEN 1 ELSE 0 END) > 5 THEN 'MEDIUM'
                ELSE 'LOW'
            END
        FROM silver.login_attempts
        WHERE ip_address IS NOT NULL
        GROUP BY ip_address;

        /* =====================================
           4. Geography Risk Summary
        ===================================== */
        TRUNCATE TABLE gold.geo_risk_summary;

        INSERT INTO gold.geo_risk_summary
        SELECT
            country,
            region,
            COUNT(*),
            SUM(CASE WHEN login_successful = 0 THEN 1 ELSE 0 END),
            SUM(CASE WHEN is_attack_ip = 1 THEN 1 ELSE 0 END),
            ROUND(
                CAST(SUM(CASE WHEN login_successful = 0 THEN 1 ELSE 0 END) AS FLOAT)
                / COUNT(*) * 100, 2
            )
        FROM silver.login_attempts
        GROUP BY country, region;

        /* =====================================
           5. Device & Browser Risk Summary
        ===================================== */
        TRUNCATE TABLE gold.device_risk_summary;

        INSERT INTO gold.device_risk_summary
        SELECT
            device_type,
            browser_family,
            COUNT(*),
            SUM(CASE WHEN login_successful = 0 THEN 1 ELSE 0 END),
            SUM(CASE WHEN is_attack_ip = 1 THEN 1 ELSE 0 END),
            ROUND(
                CAST(SUM(CASE WHEN login_successful = 0 THEN 1 ELSE 0 END) AS FLOAT)
                / COUNT(*) * 100, 2
            )
        FROM silver.login_attempts
        GROUP BY device_type, browser_family;

        /* =====================================
           6. Intrusion Session Summary
        ===================================== */
        TRUNCATE TABLE gold.intrusion_session_summary;

        INSERT INTO gold.intrusion_session_summary
        SELECT
            protocol_type,
            COUNT(*),
            AVG(session_duration),
            AVG(failed_logins),
            SUM(CASE WHEN attack_detected = 1 THEN 1 ELSE 0 END),
            SUM(CASE WHEN ip_reputation_score > 0.7 THEN 1 ELSE 0 END)
        FROM silver.intrusion_detection
        GROUP BY protocol_type;

        PRINT '==================================';
        PRINT 'Gold Layer Load Completed';
        PRINT '==================================';

    END TRY
    BEGIN CATCH
        PRINT 'ERROR IN GOLD LAYER';
        PRINT ERROR_MESSAGE();
        THROW;
    END CATCH
END;
GO
