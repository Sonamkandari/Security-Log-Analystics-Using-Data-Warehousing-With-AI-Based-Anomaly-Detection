import ChartCard from "./ChartCard"

export default function HighRiskRegions({data}){

  const risky=data
    .filter(r=>r.failure_rate>=80)
    .slice(0,10)

  return(

    <ChartCard
      title="High Failure Regions"
      description="Regions where authentication failure rates exceed 80%, indicating potential brute-force activity."
    >

      <table className="w-full text-sm">

        <thead className="text-gray-400">

          <tr>
            <th className="text-left">Country</th>
            <th className="text-left">Region</th>
            <th className="text-left">Failure %</th>
          </tr>

        </thead>

        <tbody>

          {risky.map((r,i)=>(
            <tr key={i} className="border-t border-gray-800">

              <td>{r.country}</td>
              <td>{r.region}</td>

              <td className="text-red-400">
                {r.failure_rate}%
              </td>

            </tr>
          ))}

        </tbody>

      </table>

    </ChartCard>

  )

}