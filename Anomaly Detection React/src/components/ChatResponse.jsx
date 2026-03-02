const ChatResponse = ({ query, data }) => {
  if (!query) return null;

  // ✅ Normalize input
  const q = query.toLowerCase().trim();

  const { ip, time, geo, device, session } = data;

  // -----------------------------
  // IP anomalies
  // -----------------------------
  if (q.includes("ip")) {
    const count = ip.filter((r) => r.is_anomaly === 1).length;
    return (
      <div className="success">
        🔍 {count} IP addresses were flagged as anomalous.
      </div>
    );
  }

  // -----------------------------
  // Time-based patterns
  // -----------------------------
  if (
    q.includes("time") ||
    q.includes("when") ||
    q.includes("hour") ||
    q.includes("attack")
  ) {
    const hours = [
      ...new Set(
        time.filter((r) => r.is_anomaly === 1).map((r) => r.login_hour)
      ),
    ];

    return (
      <div className="warning">
        ⏰ Unusual activity is concentrated during these hours:
        <br />
        <strong>{hours.length ? hours.join(", ") : "No dominant pattern detected"}</strong>
      </div>
    );
  }

  // -----------------------------
  // Geographic patterns
  // -----------------------------
  if (q.includes("region") || q.includes("geo") || q.includes("country")) {
    return (
      <div className="error">
        🌍 Certain geographic regions exhibit higher anomaly frequency.
      </div>
    );
  }

  // -----------------------------
  // Device patterns
  // -----------------------------
  if (
    q.includes("device") ||
    q.includes("mobile") ||
    q.includes("browser")
  ) {
    return (
      <div className="info">
        📱 Some device and browser combinations show abnormal behavior.
      </div>
    );
  }

  // -----------------------------
  // Session behavior
  // -----------------------------
  if (q.includes("session")) {
    const count = session.filter((r) => r.is_anomaly === 1).length;
    return (
      <div className="error">
        🚨 {count} sessions were flagged due to abnormal behavior.
      </div>
    );
  }

  // -----------------------------
  // Summary
  // -----------------------------
  if (q.includes("summary") || q.includes("overview")) {
    const total =
      ip.filter((r) => r.is_anomaly === 1).length +
      time.filter((r) => r.is_anomaly === 1).length +
      geo.filter((r) => r.is_anomaly === 1).length +
      device.filter((r) => r.is_anomaly === 1).length +
      session.filter((r) => r.is_anomaly === 1).length;

    return (
      <div className="success">
        📊 Overall, <strong>{total}</strong> anomalous patterns were detected.
      </div>
    );
  }

  // -----------------------------
  // Model explanation
  // -----------------------------
  if (q.includes("isolation") || q.includes("model") || q.includes("forest")) {
    return (
      <div className="info">
        🌲 Isolation Forest identifies anomalies by isolating rare observations
        using fewer random splits than normal data points.
      </div>
    );
  }

  // -----------------------------
  // Fallback
  // -----------------------------
  return (
    <div className="warning">
      ❓ I couldn’t match that input to an insight.
      <br />
      Try keywords like <em>IP</em>, <em>time</em>, <em>region</em>, or <em>summary</em>.
    </div>
  );
};

export default ChatResponse;