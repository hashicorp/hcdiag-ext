# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Consul Enterprise checks

product "consul" {
  selects = [
              "consul version -format=json",
              "consul license get",
              "consul catalog services | grep -i 'consul-snapshot'",
              "consul operator autopilot get-config",
              "GET /v1/agent/self",
              "GET /v1/agent/metrics",
            ]

# check consul version is recent
  command {
    run = "consul version -format=json"
    format = "json"
  }

# check consul license
  command {
    run = "consul license get"
    format = "string"
  }

# check if consul snapshot service is running for automated backups
  shell {
    run ="consul catalog services | grep -i 'consul-snapshot'"
  }

# get autopilot configuration for review
  command {
    run = "consul operator autopilot get-config"
    format = "string"
  }

# check ACLs, end-to-end TLS and audit logs in use '.DebugConfig.ACLsEnabled' & '.DebugConfig.TLS.HTTPS' & '.DebugConfig.EnterpriseRuntimeConfig.AuditEnabled' & '.DebugConfig.EnterpriseRuntimeConfig.AuditSinks'
  GET {
    path = "/v1/agent/self" 
  }

# check metrics are enabled
  GET {
    path = "/v1/agent/metrics"
  }
}
