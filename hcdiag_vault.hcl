# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Vault Enterprise checks

host {
  selects = [
              "ps u -C vault",
              "systemctl show vault --property=LimitMEMLOCK",
              "systemctl show vault --property=LimitCORE"
            ]

# check vault is running as vault user
  command {
    run = "ps u -C vault"
    format = "string"
  }

# check if swap is disabled
  command {
    run = "systemctl show vault --property=LimitMEMLOCK"
    format = "string"
  }

# check if core dump is possible
  command {
    run = "systemctl show vault --property=LimitCORE"
    format = "string"
  }
}

product "vault" {
  selects = [
              "GET /v1/sys/health",
              "GET /v1/sys/storage/raft/snapshot-auto/config?list=true",
              "vault operator usage -format=json",
              "GET /v1/sys/config/state/sanitized"
            ]

# check health endpoint for version, license.expiry_time, replication_dr_mode
  GET {
    path = "/v1/sys/health"
  }

# check if snapshots are configured
  GET {
    path = "/v1/sys/storage/raft/snapshot-auto/config?list=true"
  }

# check vault usage on vault 1.6+
  command {
    run = "vault operator usage -format=json"
    format = "json"
  }

# get vault config outside of vault debug and check '.data.listeners' for TLS 
  GET {
    path = "/v1/sys/config/state/sanitized"
  }
}
