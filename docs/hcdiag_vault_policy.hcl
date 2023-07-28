# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Vault Enterprise checks token policy

# check health endpoint for version, license.expiry_time, replication_dr_mode
path "sys/health" {
  capabilities = ["read"]
}

# check vault usage on vault 1.6+
path "sys/internal/counters/activity" {
  capabilities = ["read"]
}

# check storage autopilot redundancy zones and automated upgrades
path "sys/storage/raft/autopilot/configuration" {
  capabilities = ["read"]
}
path "sys/storage/raft/autopilot/state" {
  capabilities = ["read"]
}

# check if snapshots are configured
path "sys/storage/raft/snapshot-auto/config?list=true" {
  capabilities = ["read"]
}
