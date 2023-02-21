# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Vault Enterprise checks token policy

# check health endpoint for version, license.expiry_time, replication_dr_mode
path "sys/health" {
  capabilities = ["read"]
}

# check if snapshots are configured
path "sys/storage/raft/snapshot-auto/config?list=true" {
  capabilities = ["read"]
}

# check vault usage on vault 1.6+
path "sys/internal/counters/activity" {
  capabilities = ["read"]
}

# get vault config outside of vault debug and check '.data.listeners' for TLS 
path "sys/config/state/sanitized" {
  capabilities = ["read"]
}
