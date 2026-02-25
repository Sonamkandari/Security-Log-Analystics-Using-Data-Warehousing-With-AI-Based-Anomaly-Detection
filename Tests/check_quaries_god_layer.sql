-- check queries
use SecurityLogsDW;
EXEC gold.load_gold;
SELECT * FROM gold.login_time_summary;
SELECT * FROM gold.ip_risk_summary;
SELECT * FROM gold.geo_risk_summary;
SELECT * FROM gold.device_risk_summary;
SELECT * FROM gold.intrusion_session_summary;
