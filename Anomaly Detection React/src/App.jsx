import {useEffect,useState} from "react"
import {loadCSV} from "./utils/loadCSV"
import {computeKPI,topCountries,deviceAttackSummary,browserAttackSummary} from "./utils/dataProcessing"

import KPICards from "./components/KPICards"
import LoginBreakdown from "./components/LoginBreakdown"
import CountryAttackChart from "./components/CountryAttackChart"
import {DeviceChart,BrowserChart} from "./components/DeviceCharts"
import ProtocolAnalysis from "./components/ProtocolAnalysis"
import HighRiskRegions from "./components/HighRiskRegions"

export default function App(){

  const [timeData,setTime]=useState([])
  const [geoData,setGeo]=useState([])
  const [deviceData,setDevice]=useState([])
  const [sessionData,setSession]=useState([])

  useEffect(()=>{

    loadCSV("/data/time_anomaly_results.csv",setTime)
    loadCSV("/data/geo_anomaly_results.csv",setGeo)
    loadCSV("/data/device_anomaly_results.csv",setDevice)
    loadCSV("/data/session_anomaly_results.csv",setSession)

  },[])

  const stats=computeKPI(timeData,deviceData,geoData,sessionData)

  const countryData=topCountries(geoData)
  const deviceChart=deviceAttackSummary(deviceData)
  const browserChart=browserAttackSummary(deviceData)

  return(

    <div className="bg-gray-950 min-h-screen text-gray-200 p-10">

      <div className="max-w-[1600px] mx-auto space-y-8">

        <h1 className="text-4xl font-bold">
          AI Security Analytics Dashboard
        </h1>

        <KPICards stats={stats}/>

        <LoginBreakdown data={timeData}/>

        <div className="grid grid-cols-2 gap-6">
          <CountryAttackChart data={countryData}/>
          <ProtocolAnalysis data={sessionData}/>
        </div>

        <div className="grid grid-cols-2 gap-6">
          <DeviceChart data={deviceChart}/>
          <BrowserChart data={browserChart}/>
        </div>

        <HighRiskRegions data={geoData}/>

      </div>

    </div>

  )

}