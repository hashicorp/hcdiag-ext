# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Consul Enterprise checks

host {
  selects = [":"] # noop to ensure no other default hcdiag host commands are auto-loaded
  shell {
    run = ":"
  }
}

product "consul" {
  selects = [
              "GET /v1/agent/self",
              "GET /v1/catalog/services",
              "GET /v1/catalog/services?filter='ServiceName==%22consul-snapshot%22'",
              "GET /v1/operator/autopilot/configuration",
              "GET /v1/operator/license",
              "GET /v1/operator/usage?global=true"
            ]

# check consul version is recent
  GET {
    path = "/v1/agent/self"
  }

# get services list and count
  GET {
    path = "/v1/catalog/services"
  }

# check if consul snapshot service is running for automated backups
  GET {
    path = "/v1/catalog/services?filter='ServiceName==%22consul-snapshot%22'"
  }

# check autopilot is configured
  GET {
    path = "/v1/operator/autopilot/configuration"
  }
  
# check consul license
  GET {
    path = "/v1/operator/license"
  }

# check consul usage
  GET {
    path = "/v1/operator/usage?global=true"
  }
}
