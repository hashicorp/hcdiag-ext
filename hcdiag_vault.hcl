# hcdiag beta: Vault Enterprise checks

host {
  selects = [ # Executive Checks
              "ps u -C vault",
              "systemctl show vault --property=LimitMEMLOCK",
              "systemctl show vault --property=LimitCORE",  
  
              # Configuration Checks
              "systemctl show vault --property=ProtectSystem",
              "systemctl show vault --property=PrivateTmp",
              "systemctl show vault --property=CapabilityBoundingSet",
              "systemctl show vault --property=AmbientCapabilities",
              "systemctl show vault --property=ProtectHome",
              "systemctl show vault --property=PrivateDevices",
              "systemctl show vault --property=NoNewPrivileges",
              "consul info",
              "nomad agent-info",
              "rpm -qi vault-enterprise || dpkg-query -W vault-enterprise",
              "apt-cache policy vault-enterprise | grep -B 2 /var/lib/dpkg/status",
              "yum info vault-enterprise | grep -E ^From",
              "ls -ldF /opt/vault"
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

# check systemctl for other vault production hardening
  command {
    run = "systemctl show vault --property=ProtectSystem"
    format = "string"
  }
  command {
    run = "systemctl show vault --property=PrivateTmp"
    format = "string"
  }
  command {
    run = "systemctl show vault --property=CapabilityBoundingSet"
    format = "string"
  }
  command {
    run = "systemctl show vault --property=AmbientCapabilities"
    format = "string"
  }
  command {
    run = "systemctl show vault --property=ProtectHome"
    format = "string"
  }
  command {
    run = "systemctl show vault --property=PrivateDevices"
    format = "string"
  }
  command {
    run = "systemctl show vault --property=NoNewPrivileges"
    format = "string"
  }

# check for nomad and consul
  command {
    run = "nomad agent-info"
    format = "string"
  } 
  command {
    run = "consul info"
    format = "string"
  } 

# check vault is installed using package not binary
  shell {
    run = "rpm -qi vault-enterprise || dpkg-query -W vault-enterprise"
  }

# check vault package repo source (apt)
  shell {
    run = "apt-cache policy vault-enterprise | grep -B 2 /var/lib/dpkg/status"
  }

# check vault package repo source (yum/dnf)
  shell {
    run = "yum info vault-enterprise | grep -E ^From"
  }

# check ownership on /opt/vault
  command {
    run = "ls -ldF /opt/vault"
    format = "string"
  }
}

product "vault" {
  selects = [ # Executive Checks
              "GET /v1/sys/health",
              "GET /v1/sys/license/status",
              "GET /v1/sys/storage/raft/snapshot-auto/config?list=true",
              "vault operator usage -format=json",
              "GET /v1/sys/config/state/sanitized",

              # Configuration Checks
              "vault audit list -format=json",
              "vault auth list -format=json",
              "vault namespace list -format=json",
              "vault plugin list -format=json",
              "vault policy list -format=json",
              "vault secrets list -format=json",
              "vault operator raft list-peers -format=json",
              "vault operator raft autopilot state -format=json",
              "vault operator raft autopilot get-config -format=json",
              "GET /v1/kmip/config",
              "GET /v1/sys/seal-status"
              "GET /v1/sys/sealwrap/rewrap",
              "GET /v1/sys/rotate/config",
              "GET /v1/sys/replication/status"
            ]

# check health endpoint for version, license.expiry_time, replication_dr_mode
  GET {
    path = "/v1/sys/health"
  }

# check license status
  GET {
    path = "/v1/sys/license/status"
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

# get vault config outside of vault debug
  GET {
    path = "/v1/sys/config/state/sanitized" # '.data.listeners'
  }

# check 2+ audit devices
  command {
    run = "vault audit list -format=json"
    format = "json"
  }

# some basic commands to check how vault is being used
  command {
    run = "vault auth list -format=json"
    format = "json"
  }
  command {
    run = "vault namespace list -format=json"
    format = "json"
  }
  command {
    run = "vault plugin list -format=json"
    format = "json"
  }
  command {
    run = "vault policy list -format=json"
    format = "json"
  }
  command {
    run = "vault secrets list -format=json"
    format = "json"
  }

# raft storage
  command {
    run = "vault operator raft list-peers -format=json"
    format = "json"
  }
  command {
    run = "vault operator raft autopilot state -format=json"
    format = "json"
  }
  command {
    run = "vault operator raft autopilot get-config -format=json"
    format = "json"
  }

# Check if KMIP is in use
  GET {
    path = "/v1/kmip/config"
    }

# Check seal wrap config
  GET {
    path = "/v1/sys/seal-status"
  }

# Check if seal rewrapping is in progress
  GET {
    path = "/v1/sys/sealwrap/rewrap"
  }

# Check key rotation
  GET {
    path = "/v1/sys/rotate/config"
  }

# Check replication status
  GET {
    path = "/v1/sys/replication/status"
  }
}
