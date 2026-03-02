import Papa from "papaparse";

export const loadCSV = async (path) => {
  const response = await fetch(path);
  const text = await response.text();

  return new Promise((resolve) => {
    Papa.parse(text, {
      header: true,
      dynamicTyping: true,
      complete: (results) => resolve(results.data),
    });
  });
};