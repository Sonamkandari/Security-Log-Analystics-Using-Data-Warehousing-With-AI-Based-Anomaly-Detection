import {PieChart,Pie,Cell,Tooltip,ResponsiveContainer} from "recharts"
import ChartCard from "./ChartCard"

export default function LoginBreakdown({data}){

  if(!data.length) return null

  const row=data[0]

  const chartData=[
    {name:"Successful",value:row.total_logins-row.failed_logins},
    {name:"Failed",value:row.failed_logins},
    {name:"Attack",value:row.attack_logins}
  ]

  const colors=["#22c55e","#f59e0b","#ef4444"]

  return (

    <ChartCard
      title="Login Activity Breakdown"
      description="Distribution of authentication outcomes showing successful logins, failed attempts, and detected attack logins."
    >

      <ResponsiveContainer width="100%" height={300}>

        <PieChart>

          <Pie
            data={chartData}
            dataKey="value"
            nameKey="name"
            outerRadius={110}
          >

            {chartData.map((entry,i)=>(
              <Cell key={i} fill={colors[i]}/>
            ))}

          </Pie>

          <Tooltip/>

        </PieChart>

      </ResponsiveContainer>

    </ChartCard>

  )
}