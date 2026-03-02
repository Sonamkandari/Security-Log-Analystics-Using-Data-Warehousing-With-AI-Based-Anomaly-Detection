const SuggestedQuestions = ({ setQuery }) => {
  return (
    <div className="suggestions">
      <h3>💡 Suggested Questions</h3>

      <div className="btn-grid">
        <button onClick={() => setQuery("show suspicious ips")}>
          🔍 Show suspicious IPs
        </button>

        <button onClick={() => setQuery("when do attacks happen")}>
          ⏰ When do attacks happen?
        </button>

        <button onClick={() => setQuery("which regions are risky")}>
          🌍 Which regions are risky?
        </button>

        <button onClick={() => setQuery("are mobile devices risky")}>
          📱 Are mobile devices risky?
        </button>

        <button onClick={() => setQuery("show anomaly summary")}>
          📊 Show anomaly summary
        </button>

        <button onClick={() => setQuery("explain isolation forest")}>
          🌲 Explain Isolation Forest
        </button>
      </div>
    </div>
  );
};

export default SuggestedQuestions;