# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Vault Enterprise checks

host {
  selects = ["dpkg-query -W vault-enterprise","rpm -q vault-enterprise"]
  command {
    run = "dpkg-query -W vault-enterprise"
    format = "string"
  }
  command {
    run = "rpm -q vault-enterprise"
    format = "string"
  }
}

product "vault" {
  selects = [
              "GET /v1/sys/health",
              "GET /v1/sys/internal/counters/activity",
              "GET /v1/sys/storage/raft/autopilot/configuration",
              "GET /v1/sys/storage/raft/autopilot/state",
              "GET /v1/sys/storage/raft/snapshot-auto/config?list=true"
            ]

# check health endpoint for version, license.expiry_time, replication_dr_mode
  GET {
    path = "/v1/sys/health"
  }

# check vault usage on vault 1.6+
  GET {
    path = "/v1/sys/internal/counters/activity"
  }

# check storage autopilot redundancy zones and automated upgrades
  GET {
    path = "/v1/sys/storage/raft/autopilot/configuration"
  }
  GET {
    path = "/v1/sys/storage/raft/autopilot/state"
  }

# check if snapshots are configured
  GET {
    path = "/v1/sys/storage/raft/snapshot-auto/config?list=true"
  }
}
