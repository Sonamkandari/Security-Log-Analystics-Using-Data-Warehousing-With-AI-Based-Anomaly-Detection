# ============================================================
# AI Anomaly Detection on Gold Layer (SQL Server)
# Isolation Forest | Security Analytics
# ============================================================

import pyodbc
import pandas as pd
from sklearn.ensemble import IsolationForest
import os

print("🚀 Starting AI Anomaly Detection Pipeline...")

# ------------------------------------------------------------
# 1. OUTPUT DIRECTORY (Frontend + Power BI)
# ------------------------------------------------------------
OUTPUT_DIR = "../Anomaly Detection React/public/data"
os.makedirs(OUTPUT_DIR, exist_ok=True)

# ------------------------------------------------------------
# 2. CONNECT TO SQL SERVER
# ------------------------------------------------------------
conn = pyodbc.connect(
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=LAPTOP-IJ8NES98\\SQLEXPRESS;"
    "DATABASE=SecurityLogsDW;"
    "Trusted_Connection=yes;"
)

print("✅ Connected to SecurityLogsDW")

# ------------------------------------------------------------
# 3. LOAD GOLD LAYER TABLES
# ------------------------------------------------------------
print("📥 Loading Gold tables...")

df_ip = pd.read_sql("SELECT * FROM gold.ip_risk_summary", conn)
df_time = pd.read_sql("SELECT * FROM gold.login_time_summary", conn)
df_geo = pd.read_sql("SELECT * FROM gold.geo_risk_summary", conn)
df_device = pd.read_sql("SELECT * FROM gold.device_risk_summary", conn)
df_session = pd.read_sql("SELECT * FROM gold.intrusion_session_summary", conn)

print("✅ Gold tables loaded")

# ------------------------------------------------------------
# 4. GENERIC ISOLATION FOREST FUNCTION
# ------------------------------------------------------------
def detect_anomalies(df, feature_columns, contamination=0.05):
    model = IsolationForest(
        n_estimators=100,
        contamination=contamination,
        random_state=42
    )

    df["anomaly_flag"] = model.fit_predict(df[feature_columns])
    df["is_anomaly"] = (df["anomaly_flag"] == -1).astype(int)

    return df

# ------------------------------------------------------------
# 5. APPLY AI MODELS
# ------------------------------------------------------------
print("🤖 Running anomaly detection...")

df_ip = detect_anomalies(
    df_ip,
    ["failure_rate", "attack_attempts", "total_attempts"]
)

df_time = detect_anomalies(
    df_time,
    ["total_logins", "failed_logins", "attack_logins", "failure_rate"]
)

df_geo = detect_anomalies(
    df_geo,
    ["total_logins", "failed_logins", "attack_logins", "failure_rate"]
)

df_device = detect_anomalies(
    df_device,
    ["total_logins", "failed_logins", "attack_logins", "failure_rate"]
)

df_session = detect_anomalies(
    df_session,
    [
        "avg_session_duration",
        "avg_failed_logins",
        "detected_attacks",
        "high_risk_sessions"
    ]
)

print("✅ Anomaly detection completed")

# ------------------------------------------------------------
# 6. SAVE RESULTS (FOR REACT + POWER BI)
# ------------------------------------------------------------
df_ip.to_csv(f"{OUTPUT_DIR}/ip_anomaly_results.csv", index=False)
df_time.to_csv(f"{OUTPUT_DIR}/time_anomaly_results.csv", index=False)
df_geo.to_csv(f"{OUTPUT_DIR}/geo_anomaly_results.csv", index=False)
df_device.to_csv(f"{OUTPUT_DIR}/device_anomaly_results.csv", index=False)
df_session.to_csv(f"{OUTPUT_DIR}/session_anomaly_results.csv", index=False)

print("📁 CSV files saved to React public/data")

# ------------------------------------------------------------
# 7. SUMMARY
# ------------------------------------------------------------
print("\n================ SUMMARY ================")
print(f"Suspicious IPs: {df_ip['is_anomaly'].sum()}")
print(f"Suspicious Time Windows: {df_time['is_anomaly'].sum()}")
print(f"Suspicious Regions: {df_geo['is_anomaly'].sum()}")
print(f"Suspicious Devices/Browsers: {df_device['is_anomaly'].sum()}")
print(f"Suspicious Sessions: {df_session['is_anomaly'].sum()}")
print("========================================")
print("🎯 AI SECURITY ANALYTICS PIPELINE DONE")