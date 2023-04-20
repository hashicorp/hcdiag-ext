# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Vault Enterprise checks

host {
  selects = [":"] # noop to ensure no other default hcdiag host commands are auto-loaded
  shell {
    run = ":"
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
