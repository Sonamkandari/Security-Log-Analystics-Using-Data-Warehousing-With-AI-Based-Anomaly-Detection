import {BarChart,Bar,XAxis,YAxis,Tooltip,ResponsiveContainer,CartesianGrid} from "recharts"
import ChartCard from "./ChartCard"

export default function CountryAttackChart({data}){

  return (

    <ChartCard
      title="Top Attack Countries"
      description="Countries generating the highest number of attack login attempts based on aggregated security logs."
    >

      <ResponsiveContainer width="100%" height={300}>

        <BarChart data={data}>

          <CartesianGrid strokeDasharray="3 3" stroke="#1f2937"/>

          <XAxis
            dataKey="country"
            stroke="#9CA3AF"
          />

          <YAxis
            stroke="#9CA3AF"
            tickFormatter={(v)=>v.toLocaleString()}
          />

          <Tooltip/>

          <Bar
            dataKey="attacks"
            fill="#ef4444"
            barSize={28}
            radius={[6,6,0,0]}
          />

        </BarChart>

      </ResponsiveContainer>

    </ChartCard>

  )
}