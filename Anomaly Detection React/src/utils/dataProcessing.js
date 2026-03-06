export function computeKPI(timeData, deviceData, geoData, sessionData) {
  const totalLogins = timeData.reduce((a,b)=>a+b.total_logins,0);
  const attacks = timeData.reduce((a,b)=>a+b.attack_logins,0);
  const avgFailure = timeData.length
    ? (timeData.reduce((a,b)=>a+b.failure_rate,0)/timeData.length).toFixed(2)
    : 0;

  const anomalies =
    deviceData.filter(d=>d.is_anomaly===1).length +
    geoData.filter(g=>g.is_anomaly===1).length +
    sessionData.filter(s=>s.is_anomaly===1).length;

  return { totalLogins, attacks, avgFailure, anomalies };
}

export function topCountries(geoData){
  const map={};

  geoData.forEach(r=>{
    if(!map[r.country]){
      map[r.country]={country:r.country, attacks:0};
    }
    map[r.country].attacks+=r.attack_logins;
  });

  return Object.values(map)
    .sort((a,b)=>b.attacks-a.attacks)
    .slice(0,10);
}

export function deviceAttackSummary(deviceData){
  const map={};

  deviceData.forEach(r=>{
    if(!map[r.device_type]){
      map[r.device_type]={device:r.device_type, attacks:0};
    }
    map[r.device_type].attacks+=r.attack_logins;
  });

  return Object.values(map);
}

export function browserAttackSummary(deviceData){
  const map={};

  deviceData.forEach(r=>{
    if(!map[r.browser_family]){
      map[r.browser_family]={browser:r.browser_family, attacks:0};
    }
    map[r.browser_family].attacks+=r.attack_logins;
  });

  return Object.values(map);
}