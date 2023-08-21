/**
 * Copyright (c) HashiCorp, Inc.
 * SPDX-License-Identifier: MPL-2.0
 */

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
  link.setAttribute("download", `hcdiag_${product}_configuration.hcl`);
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
    if (typeof dictionary === "object" && dictionary !== null && key in dictionary) {
      dictionary = dictionary[key];
    } else {
      return defaultVal;
    }
  }
  return dictionary;
}
function findKey(dictionary, value) {
  const matches = [];
  for (let key in dictionary["vault"]) {
    const [base, query] = key.split("?");
    if (base === value) {
      matches.push("vault." + key + ".result.response.data.total.clients");
    }
  }
  return matches;
}
function formatUsage(data, baseKey = "GET /v1/sys/internal/counters/activity") {
  const keys = findKey(data, baseKey);
  let results = `<table class="count-results">`;
  for (const key of keys) {
    const query = key.split("?")[1];
    const start = query.split("&")[0];
    const startDate = start.split("T")[0];
    const end = query.split("&")[1];
    const endDate = end.split("T")[0];
    const count = deepGet(data, key);
    results += `
      <tr>
        <td>${startDate}</td>
        <td>${endDate}</td>
        <td>${count}</td>
      </tr>
    `;
  }
  results += "</table>";
  return results;
}
function formatTerraformJSON(data) {
  const errorOutput = document.getElementById("errorOutput");
  try {
    // Clear elements
    errorOutput.innerHTML = "";
    document.getElementById("tfeVersion").innerHTML = "";
    //document.getElementById("licenseExpiredResult").innerHTML = ""; // Not available via API
    document.getElementById("workspaceCountResult").innerHTML = "";
    document.getElementById("sentinelChecksCompletedResult").innerHTML = "";
    document.getElementById("costEstimationsCompletedResult").innerHTML = "";
    document.getElementById("runTasksTotal").innerHTML = "";
    const tfeVersion = String(deepGet(data, "terraform-ent.GET /api/v2/admin/release.result.response.release"));
    //const licenseExpiredResult = String(deepGet(data, "terraform-ent.replicatedctl license inspect.result.json[0].IsExpired")).replace("False", "No").replace("True", "Yes"); // Not available via API
    const workspaceCountResult = String(deepGet(data, "terraform-ent.GET /api/v2/admin/workspaces?page%5Bsize%5D=1.result.response.meta.status-counts.total"));
    const sentinelChecksCompletedResult = String(deepGet(data, "terraform-ent.GET /api/v2/admin/runs?page%5Bsize%5D=1.result.response.meta.status-counts.policy-checked"));
    const costEstimationsCompletedResult = String(deepGet(data, "terraform-ent.GET /api/v2/admin/runs?page%5Bsize%5D=1.result.response.meta.status-counts.cost-estimated"));
    const runTasksPreApplyCompleted = deepGet(data, "terraform-ent.GET /api/v2/admin/runs?page%5Bsize%5D=1.result.response.meta.status-counts.pre-apply-completed");
    const runTasksPostPlanCompleted = deepGet(data, "terraform-ent.GET /api/v2/admin/runs?page%5Bsize%5D=1.result.response.meta.status-counts.post-plan-completed");
    // Sum the run tasks
    const runTasksTotal = runTasksPreApplyCompleted + runTasksPostPlanCompleted;
    // Update the results table
    document.getElementById("tfeVersion").innerHTML = tfeVersion;
    //document.getElementById("licenseExpiredResult").innerHTML = licenseExpiredResult; // Not available via API
    document.getElementById("workspaceCountResult").innerHTML = workspaceCountResult;
    document.getElementById("sentinelChecksCompletedResult").innerHTML = sentinelChecksCompletedResult;
    document.getElementById("costEstimationsCompletedResult").innerHTML = costEstimationsCompletedResult;
    document.getElementById("runTasksTotal").innerHTML = runTasksTotal;
  } catch (error) {
    errorOutput.innerHTML = `<p id="warning">Invalid JSON: ${error.message}`;
  }
}
function formatVaultJSON(data) {
  const errorOutput = document.getElementById("errorOutput");
  const resultOutput = document.getElementById("resultOutput");
  try {
    // Clear elements
    errorOutput.innerHTML = "";
    document.getElementById("vaultEnterpriseVersionResult").innerHTML = "";
    document.getElementById("licenseExpiryDateResultHuman").innerHTML = "";
    document.getElementById("vaultEnterpriseUsageClients").innerHTML = "";
    document.getElementById("disasterRecoveryReplicationConfigured").innerHTML = "";
    document.getElementById("namedSnapshotsConfigured").innerHTML = "";
    document.getElementById("redundancyZonesConfigured").innerHTML = "";
    document.getElementById("storageAutopilotUpgrades").innerHTML = "";
    // Check some easy to read key paths
    const vaultEnterpriseVersionResult = String(deepGet(data, "vault.GET /v1/sys/health.result.response.version"));
    const licenseExpiryDateResult = String(deepGet(data, "vault.GET /v1/sys/health.result.response.license.expiry_time"));
    const disasterRecoveryReplicationConfiguration = String(deepGet(data, "vault.GET /v1/sys/health.result.response.replication_dr_mode"));
    const namedSnapshotsConfiguration = String(deepGet(data, "vault.GET /v1/sys/storage/raft/snapshot-auto/config?list=true.result.response.data.keys"));
    const redundancyZonesConfiguration = String(deepGet(data, "vault.GET /v1/sys/storage/raft/autopilot/state.result.response.data.redundancy_zones"));
    // Check the Vault Enterprise usage by finding the number of activity keys and looping through them :(
    const vaultEnterpriseUsageClients = formatUsage(data);
    // Convert the license expiry date to a human readable format
    const licenseExpiryDateResultHuman = licenseExpiryDateResult === "Unknown" ? "Unknown" : new Date(licenseExpiryDateResult).toLocaleDateString("en-US", { day: "2-digit", month: "long", year: "numeric" });
    // Determine some Yes/No answers based on the results
    const storageAutopilotUpgrades = String(deepGet(data, "vault.GET /v1/sys/storage/raft/autopilot/configuration.result.response.data.disable_upgrade_migration")).replace("false", "Yes").replace("true", "No");
    const disasterRecoveryReplicationConfigured = disasterRecoveryReplicationConfiguration === "disabled" || disasterRecoveryReplicationConfiguration === "unknown" ? "No" : "Yes";
    const namedSnapshotsConfigured = namedSnapshotsConfiguration.length > 7 ? "Yes" : "No";
    const redundancyZonesConfigured = redundancyZonesConfiguration.length > 7 ? "Yes" : "No";
    // Update the results table
    document.getElementById("vaultEnterpriseVersionResult").innerHTML = vaultEnterpriseVersionResult;
    document.getElementById("licenseExpiryDateResultHuman").innerHTML = licenseExpiryDateResultHuman;
    document.getElementById("vaultEnterpriseUsageClients").innerHTML = `${vaultEnterpriseUsageClients}`;
    document.getElementById("disasterRecoveryReplicationConfigured").innerHTML = `${disasterRecoveryReplicationConfigured} <span class="raw-result">${disasterRecoveryReplicationConfiguration}</span>`;
    document.getElementById("namedSnapshotsConfigured").innerHTML = `${namedSnapshotsConfigured} <span class="raw-result">${namedSnapshotsConfiguration}</span>`;
    document.getElementById("redundancyZonesConfigured").innerHTML = `${redundancyZonesConfigured} <span class="raw-result">${redundancyZonesConfiguration}</span>`;
    document.getElementById("storageAutopilotUpgrades").innerHTML = storageAutopilotUpgrades;
  } catch (error) {
    errorOutput.innerHTML = `<p id="warning">Invalid JSON: ${error.message}`;
  }
}
