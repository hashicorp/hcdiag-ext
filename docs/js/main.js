function validDate(dateString) {
  // Regex to match YYYY-MM-DD 
  const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
  if (!dateRegex.test(dateString)) {
    return false; 
  }
  // Check if valid date with moment
  if (!moment(dateString).isValid()) {
    return false;
  }
  // Check if date is in the future
  if (moment(dateString).isAfter(moment())) {
    return false;
  }
  return true;
}
function downloadCode(product) {
  const code = document.querySelector(".code-block code").innerText;
  const blob = new Blob([code], { type: "text/plain" });
  const url = URL.createObjectURL(blob);
  const link = document.createElement("a");

  link.setAttribute("href", url);
  link.setAttribute("download", `hcdiag_${product}.hcl`);
  link.style.display = "none";

  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
  URL.revokeObjectURL(url);
}
function copyCode() {
  const code = document.querySelector(".code-block code").innerText;
  const button = document.querySelector("#copyCode");
  navigator.clipboard
    .writeText(code)
    .then(() => {
      button.style.color = "rgb(0, 120, 30)";
      button.style.backgroundColor = "rgb(242, 251, 246)";
      button.style.transition = "background-color 0.2s";
    })
    .catch((error) => {
      console.error("Failed to copy code:", error);
    });
}
function copyTable() {
  const table = document.querySelector("#resultOutput").innerText;
  const button = document.querySelector("#copyResult");
  navigator.clipboard
    .writeText(table)
    .then(() => {
      button.style.color = "rgb(0, 120, 30)";
      button.style.backgroundColor = "rgb(242, 251, 246)";
      button.style.transition = "background-color 0.2s";
    })
    .catch((error) => {
      console.error("Failed to copy table contents:", error);
    });
}
function deepGet(dictionary, keys, defaultVal = "Unknown") {
  const keysList = keys.split(".");
  for (const key of keysList) {
    if (
      typeof dictionary === "object" &&
      dictionary !== null &&
      key in dictionary
    ) {
      dictionary = dictionary[key];
    } else {
      return defaultVal;
    }
  }
  return dictionary;
}
function getValueByPath(obj, keyPath, defaultValue) {
  if (typeof obj !== "object" || obj === null) {
    throw new Error("obj must be an object");
  }
  if (typeof keyPath !== "string") {
    throw new Error("keyPath must be a string");
  }
  const keys = keyPath.split(".");
  return keys.reduce((value, key) => {
    return value?.[key] ?? defaultValue;
  }, obj);
}
