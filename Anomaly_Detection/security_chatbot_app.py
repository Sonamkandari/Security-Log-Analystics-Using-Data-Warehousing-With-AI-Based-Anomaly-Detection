# ============================================
# AI Security Analytics Chatbot (Streamlit)
# Isolation Forest Based Anomaly Detection
# ============================================

import streamlit as st
import pandas as pd

# -----------------------------
# Page Configuration
# -----------------------------
st.set_page_config(
    page_title="AI Security Analytics Chatbot",
    page_icon="🛡",
    layout="wide"
)

# -----------------------------
# Load Data
# -----------------------------
@st.cache_data
def load_data():
    df_ip = pd.read_csv("ip_anomaly_results.csv")
    df_time = pd.read_csv("time_anomaly_results.csv")
    df_geo = pd.read_csv("geo_anomaly_results.csv")
    df_device = pd.read_csv("device_anomaly_results.csv")
    df_session = pd.read_csv("session_anomaly_results.csv")
    return df_ip, df_time, df_geo, df_device, df_session

df_ip, df_time, df_geo, df_device, df_session = load_data()

# -----------------------------
# Sidebar
# -----------------------------
st.sidebar.title("🛡 Security Assistant")
st.sidebar.markdown("""
This chatbot explains **security anomalies** detected using  
**Isolation Forest (AI model)**.

### Example Questions:
- Show suspicious IPs  
- When do attacks happen?  
- Which regions are risky?  
- Are mobile devices risky?  
- Show anomaly summary  
- Why are logins flagged?  
- Explain Isolation Forest  
""")

st.sidebar.info("📌 Dataset: Login Security Logs")

# -----------------------------
# Main Title
# -----------------------------
st.title("🤖 AI Security Analytics Chatbot")
st.caption("Isolation Forest–based anomaly detection with conversational explanation")

st.divider()

# -----------------------------
# Question Suggestions
# -----------------------------
st.subheader("💡 Suggested Questions")

col1, col2, col3 = st.columns(3)

with col1:
    if st.button("🔍 Show suspicious IPs"):
        st.session_state["query"] = "show suspicious ips"
    if st.button("🌍 Which regions are risky?"):
        st.session_state["query"] = "which regions are risky"

with col2:
    if st.button("⏰ When do attacks happen?"):
        st.session_state["query"] = "when do attacks happen"
    if st.button("📱 Are mobile devices risky?"):
        st.session_state["query"] = "are mobile devices risky"

with col3:
    if st.button("📊 Show anomaly summary"):
        st.session_state["query"] = "show anomaly summary"
    if st.button("🌲 Explain Isolation Forest"):
        st.session_state["query"] = "explain isolation forest"

st.divider()
# -----------------------------
# Chat Input
# -----------------------------
user_input = st.text_input(
    "💬 Ask a security-related question",
    value=st.session_state.get("query", ""),
    placeholder="Type or click a suggested question above"
)

# Clear stored query after use
st.session_state["query"] = ""

# -----------------------------
# Chatbot Logic
# -----------------------------
if user_input:
    query = user_input.lower()
    st.subheader("🧠 Analysis Result")

    if "suspicious ip" in query or "ip" in query:
        count = df_ip[df_ip["is_anomaly"] == 1].shape[0]
        st.success(f"🔍 {count} IP addresses were flagged as suspicious.")
        st.caption("Reason: Abnormal IP usage patterns detected by AI")

    elif "time" in query or "attacks happen" in query:
        risky_hours = sorted(df_time[df_time["is_anomaly"] == 1]["login_hour"].unique())
        st.warning("⏰ Unusual login activity observed during these hours:")
        st.write(risky_hours)

    elif "region" in query or "country" in query:
        risky_regions = (
            df_geo[df_geo["is_anomaly"] == 1]
            .groupby(["country", "region"])
            .size()
            .reset_index(name="anomaly_count")
            .sort_values("anomaly_count", ascending=False)
        )
        st.error("🌍 High-risk regions detected:")
        st.dataframe(risky_regions.head(10), use_container_width=True)

    elif "device" in query or "mobile" in query or "browser" in query:
        risky_devices = (
            df_device[df_device["is_anomaly"] == 1]
            .groupby(["device_type", "browser_family"])
            .size()
            .reset_index(name="anomaly_count")
            .sort_values("anomaly_count", ascending=False)
        )
        st.info("📱 Suspicious device & browser combinations:")
        st.dataframe(risky_devices.head(10), use_container_width=True)

    elif "session" in query:
        count = df_session[df_session["is_anomaly"] == 1].shape[0]
        st.error(f"🚨 {count} login sessions were detected as anomalous.")

    elif "summary" in query or "overview" in query:
        total = (
            df_ip["is_anomaly"].sum()
            + df_time["is_anomaly"].sum()
            + df_geo["is_anomaly"].sum()
            + df_device["is_anomaly"].sum()
            + df_session["is_anomaly"].sum()
        )
        st.success(f"📊 Overall, {total} anomalies were detected across the system.")

    elif "why" in query or "explain anomalies" in query:
        st.info(
            "🔎 Login attempts are flagged due to:\n\n"
            "- New or rare IP addresses\n"
            "- Unusual login times\n"
            "- New geographic locations\n"
            "- Rare devices or browsers\n"
            "- Abnormal session behavior"
        )

    elif "isolation forest" in query or "model" in query:
        st.info(
            "🌲 Isolation Forest is an unsupervised machine learning model that "
            "detects anomalies by isolating unusual login patterns faster than normal ones."
        )

    elif "hello" in query or "hi" in query:
        st.info("👋 Hello! Ask me anything about security anomalies.")

    else:
        st.warning("❓ I didn’t understand that question.")
        st.markdown("""
Try clicking a **suggested question** above or ask:
- Show suspicious IPs  
- When do attacks happen?  
- Which regions are risky?  
- Show anomaly summary  
- Explain Isolation Forest  
""")

# -----------------------------
# Footer
# -----------------------------
st.divider()
st.caption(
    "🧪 Capstone Project | Security Log Analytics using Isolation Forest & AI Chatbot"
)