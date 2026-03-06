import {BarChart,Bar,XAxis,YAxis,Tooltip,ResponsiveContainer,CartesianGrid} from "recharts"
import ChartCard from "./ChartCard"

export default function ProtocolAnalysis({data}){

  return(

    <ChartCard
      title="Protocol Attack Analysis"
      description="Network protocols associated with detected intrusion attempts."
    >

      <ResponsiveContainer width="100%" height={300}>

        <BarChart data={data}>

          <CartesianGrid strokeDasharray="3 3" stroke="#1f2937"/>

          <XAxis dataKey="protocol_type" stroke="#9CA3AF"/>

          <YAxis
            stroke="#9CA3AF"
            tickFormatter={(v)=>v.toLocaleString()}
          />

          <Tooltip/>

          <Bar dataKey="detected_attacks" fill="#ef4444" barSize={36}/>

        </BarChart>

      </ResponsiveContainer>

    </ChartCard>

  )

}