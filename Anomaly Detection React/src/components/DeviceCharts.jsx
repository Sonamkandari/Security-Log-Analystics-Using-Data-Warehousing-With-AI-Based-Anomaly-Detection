import {BarChart,Bar,XAxis,YAxis,Tooltip,ResponsiveContainer,CartesianGrid} from "recharts"
import ChartCard from "./ChartCard"

export function DeviceChart({data}){

  return(

    <ChartCard
      title="Attacks by Device"
      description="Distribution of attack attempts across device types such as mobile, desktop, and bots."
    >

      <ResponsiveContainer width="100%" height={260}>

        <BarChart data={data}>

          <CartesianGrid strokeDasharray="3 3" stroke="#1f2937"/>

          <XAxis dataKey="device" stroke="#9CA3AF"/>

          <YAxis
            stroke="#9CA3AF"
            tickFormatter={(v)=>v.toLocaleString()}
          />

          <Tooltip/>

          <Bar dataKey="attacks" fill="#22c55e" barSize={32}/>

        </BarChart>

      </ResponsiveContainer>

    </ChartCard>

  )

}

export function BrowserChart({data}){

  return(

    <ChartCard
      title="Attacks by Browser"
      description="Browser families generating suspicious login activity in the dataset."
    >

      <ResponsiveContainer width="100%" height={260}>

        <BarChart data={data}>

          <CartesianGrid strokeDasharray="3 3" stroke="#1f2937"/>

          <XAxis dataKey="browser" stroke="#9CA3AF"/>

          <YAxis
            stroke="#9CA3AF"
            tickFormatter={(v)=>v.toLocaleString()}
          />

          <Tooltip/>

          <Bar dataKey="attacks" fill="#6366f1" barSize={32}/>

        </BarChart>

      </ResponsiveContainer>

    </ChartCard>

  )

}