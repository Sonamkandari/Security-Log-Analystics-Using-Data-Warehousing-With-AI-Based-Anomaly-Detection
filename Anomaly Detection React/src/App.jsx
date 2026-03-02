import { useEffect, useState } from "react";
import Sidebar from "./components/Sidebar";
import SuggestedQuestions from "./components/SuggestedQuestions";
import ChatResponse from "./components/ChatResponse";
import { loadCSV } from "./utils/loadCSV";

function App() {
  const [query, setQuery] = useState("");
  const [data, setData] = useState(null);

  // 🔥 NEW: theme state
  const [theme, setTheme] = useState("dark");

  useEffect(() => {
    document.body.className = theme;
  }, [theme]);

  useEffect(() => {
    const fetchData = async () => {
      setData({
        ip: await loadCSV("/data/ip_anomaly_results.csv"),
        time: await loadCSV("/data/time_anomaly_results.csv"),
        geo: await loadCSV("/data/geo_anomaly_results.csv"),
        device: await loadCSV("/data/device_anomaly_results.csv"),
        session: await loadCSV("/data/session_anomaly_results.csv"),
      });
    };

    fetchData();
  }, []);

  return (
    <div className="container">
      <Sidebar />

      <main className="main-content">
        {/* Header */}
        <div className="header">
          <div>
            <h1>AI Security Analytics</h1>
            <p className="subtitle">
              Isolation Forest–based anomaly detection & explanation
            </p>
          </div>

          <button
            className="theme-toggle"
            onClick={() => setTheme(theme === "dark" ? "light" : "dark")}
          >
            {theme === "dark" ? "☀️ Light" : "🌙 Dark"}
          </button>
        </div>

        {/* Chat Card */}
        <div className="chat-card">
          <SuggestedQuestions setQuery={setQuery} />

          <div className="chat-input">
            <input
              type="text"
              placeholder="Ask a security-related question…"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
            />
          </div>

          <div className="chat-response">
            {data && <ChatResponse query={query} data={data} />}
          </div>
        </div>

        <footer>
          🧪 Capstone Project | Security Log Analytics using Isolation Forest
        </footer>
      </main>
    </div>
  );
}

export default App;
