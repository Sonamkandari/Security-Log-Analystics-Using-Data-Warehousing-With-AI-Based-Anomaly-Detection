
USE SecurityLogsDW;

-- Gold Login Fact (Flexible Analysis Table)
GO
IF OBJECT_ID('gold.login_fact','U') IS NOT NULL
    DROP TABLE gold.login_fact;
GO

CREATE TABLE gold.login_fact (
    login_hour            INT,
    ip_address            VARCHAR(45),
    country               VARCHAR(10),
    region                VARCHAR(100),
    city                  VARCHAR(100),
    browser_family        VARCHAR(50),
    os_name               VARCHAR(100),
    device_type           VARCHAR(50),
    login_successful      BIT,
    is_attack_ip          BIT,
    is_account_takeover   BIT
);
GO

-- Gold Time Risk Summary
IF OBJECT_ID('gold.login_time_summary','U') IS NOT NULL
    DROP TABLE gold.login_time_summary;
GO

CREATE TABLE gold.login_time_summary (
    login_hour        INT,
    total_logins      INT,
    failed_logins     INT,
    attack_logins     INT,
    failure_rate      DECIMAL(5,2)
);
GO

-- Gold IP Risk Summary
IF OBJECT_ID('gold.ip_risk_summary','U') IS NOT NULL
    DROP TABLE gold.ip_risk_summary;
GO

CREATE TABLE gold.ip_risk_summary (
    ip_address          VARCHAR(45),
    total_attempts      INT,
    failed_attempts     INT,
    attack_attempts     INT,
    failure_rate        DECIMAL(5,2),
    risk_level          VARCHAR(10)
);
GO

-- Gold Geography Risk Summary
IF OBJECT_ID('gold.geo_risk_summary','U') IS NOT NULL
    DROP TABLE gold.geo_risk_summary;
GO

CREATE TABLE gold.geo_risk_summary (
    country          VARCHAR(10),
    region           VARCHAR(100),
    total_logins     INT,
    failed_logins    INT,
    attack_logins    INT,
    failure_rate     DECIMAL(5,2)
);
GO

-- Gold Device & Browser Risk Summary
IF OBJECT_ID('gold.device_risk_summary','U') IS NOT NULL
    DROP TABLE gold.device_risk_summary;
GO

CREATE TABLE gold.device_risk_summary (
    device_type       VARCHAR(50),
    browser_family    VARCHAR(50),
    total_logins      INT,
    failed_logins     INT,
    attack_logins     INT,
    failure_rate      DECIMAL(5,2)
);
GO

-- Gold Intrusion Session Summary

IF OBJECT_ID('gold.intrusion_session_summary','U') IS NOT NULL
    DROP TABLE gold.intrusion_session_summary;
GO

CREATE TABLE gold.intrusion_session_summary (
    protocol_type         VARCHAR(10),
    total_sessions        INT,
    avg_session_duration  DECIMAL(18,6),
    avg_failed_logins     DECIMAL(10,2),
    detected_attacks      INT,
    high_risk_sessions    INT
);
GO

