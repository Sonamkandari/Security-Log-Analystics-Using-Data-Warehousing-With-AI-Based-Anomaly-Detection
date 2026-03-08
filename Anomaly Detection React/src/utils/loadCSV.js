import Papa from "papaparse";

export function loadCSV(path, setData) {
  Papa.parse(path, {
    download: true,
    header: true,
    dynamicTyping: true,
    complete: (res) => {
      const clean = res.data.filter((r) => Object.keys(r).length > 1);
      setData(clean);
    }
  });
}