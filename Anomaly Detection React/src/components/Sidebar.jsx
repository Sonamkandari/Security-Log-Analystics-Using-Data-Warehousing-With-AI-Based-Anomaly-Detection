const Sidebar = () => {
  return (
    <aside className="sidebar">
      {/* Brand */}
      <div className="sidebar-header">
        <span className="logo">🛡</span>
        <span className="brand">AI Analytics</span>
      </div>

      {/* Short description */}
      <p className="sidebar-subtitle">
        Anomaly detection & analytical insights
      </p>

      {/* Navigation */}
      <nav className="sidebar-nav">
        <div className="nav-item active">
          <span className="nav-icon">📊</span>
          <span>Overview</span>
        </div>

        <div className="nav-item">
          <span className="nav-icon">⚠️</span>
          <span>Anomalies</span>
        </div>

        <div className="nav-item">
          <span className="nav-icon">🌲</span>
          <span>Model</span>
        </div>

        <div className="nav-item">
          <span className="nav-icon">🗂</span>
          <span>Data</span>
        </div>
      </nav>

      {/* Footer */}
      <div className="sidebar-footer">
        <div className="dataset-label">Dataset</div>
        <div className="dataset-name">Login Logs</div>
      </div>
    </aside>
  );
};

export default Sidebar;