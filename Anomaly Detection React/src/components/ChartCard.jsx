export default function ChartCard({title,description,children}){

  return (
    <div className="
      bg-gray-900
      rounded-2xl
      border border-gray-800
      p-6
      shadow-lg
      space-y-3
    ">

      <div>
        <h2 className="text-lg font-semibold text-gray-200">
          {title}
        </h2>

        <p className="text-sm text-gray-400">
          {description}
        </p>
      </div>

      {children}

    </div>
  )
}