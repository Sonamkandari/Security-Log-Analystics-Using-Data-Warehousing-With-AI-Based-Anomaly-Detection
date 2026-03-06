function Card({title,value,description}){

  return (
    <div className="
      bg-gray-900
      p-6
      rounded-xl
      border border-gray-800
      space-y-2
    ">

      <p className="text-gray-400 text-sm">{title}</p>

      <h2 className="text-3xl font-bold">
        {value.toLocaleString()}
      </h2>

      <p className="text-xs text-gray-500">
        {description}
      </p>

    </div>
  )
}

export default function KPICards({stats}){

  return (

    <div className="grid grid-cols-4 gap-4">

      <Card
        title="Total Logins"
        value={stats.totalLogins}
        description="Total authentication attempts across the system"
      />

      <Card
        title="Attack Attempts"
        value={stats.attacks}
        description="Detected malicious login attempts"
      />

      <Card
        title="Average Failure Rate"
        value={stats.avgFailure}
        description="Percentage of logins that failed authentication"
      />

      <Card
        title="Detected Anomalies"
        value={stats.anomalies}
        description="AI-detected suspicious behavior events"
      />

    </div>

  )

}