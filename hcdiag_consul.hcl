# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

host {
  selects = [ # Configuration Checks
              "ps u -C consul", "ps u -C nomad", "ps u -C vault", "nomad agent-info",
              "dpkg-query -W consul-enterprise"]

# check which HashiCorp products are installed
# and if they are running as dedicated user
  command {
    run = "ps u -C consul"
    format = "string"
  }
  command {
    run = "ps u -C nomad"
    format = "string"
  }
  command {
    run = "ps u -C vault"
    format = "string"
  }
  command {
    run = "nomad agent-info"
    format = "string"
  }

# check consul is installed via package not binary
  command {
    run = "dpkg-query -W consul-enterprise"
    format = "string"
  }
}

product "consul" {
  selects = [ # Executive Checks
              "consul version -format=json",
              "consul license get",
              "consul catalog services | grep -i 'consul-snapshot'",
              "consul operator autopilot get-config",
              "GET /v1/agent/self",
              "GET /v1/agent/metrics",

              # Configuration Checks
              "consul validate /etc/consul.d/",
              "consul keyring -list",
              "consul acl auth-method list",
              "consul members",
              "ls -ldF /opt/consul",
              "GET /v1/catalog/datacenters",
              "GET /v1/partitions",
              "GET /v1/namespaces",
              "GET /v1/catalog/services",
              "GET /v1/catalog/nodes"
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

# check ACLs, end-to-end TLS and audit logs in use
  GET {
    path = "/v1/agent/self" # '.DebugConfig.ACLsEnabled' & '.DebugConfig.TLS.HTTPS' & '.DebugConfig.EnterpriseRuntimeConfig.AuditEnabled' & '.DebugConfig.EnterpriseRuntimeConfig.AuditSinks'
  }

# check metrics are enabled
  GET {
    path = "/v1/agent/metrics" # '.'
  }

# check configuration is valid
  command {
    run = "consul validate /etc/consul.d/"
    format = "string"
  }

# check gossip is encrypted
  command {
    run = "consul keyring -list"
    format = "string"
  }

# check for SSO and k8s auth
  command {
    run = "consul acl auth-method list"
    format = "string"
  }

# check for Network Segments
  command {
    run = "consul members"
    format = "string"
  }

# check ownership of /opt/consul
  command {
    run = "ls -ldF /opt/consul"
    format = "string"
  }

# check
  GET {
    path = "/v1/catalog/datacenters" # '.'
  }

# check
  GET {
    path = "/v1/partitions" # '.'
  }

# check
  GET {
    path = "/v1/namespaces" # '.'
  }

# check
  GET {
    path = "/v1/catalog/services" # '.'
  }

# check
  GET {
    path = "/v1/catalog/nodes" # '.'
  }
}
