### Top 10 for Health Assessment
# 1. Run as vault user not root user. Status: Results.json > '.host."ps -u vault".result' + '.host."ps -u root".result'
# 2. End-to-End TLS. Status: Results.json > '.vault."vault read sys/config/state/sanitized -format=json".result.data.listeners'
# 3. Disable swap / use mlock. Status: Results.json > '.host."systemctl show vault --property=LimitMEMLOCK".result'
# 4. Disable core dumps. Status: Results.json > '.host."systemctl show vault --property=LimitCORE".result'
# 5. Upgrade Frequently (within one major release). Status: Results.json > '.vault."vault version".result'
# 6. Check for production hardening. Status: Results.json '.host[] | select(.runner.command | contains ("systemctl"))'
# 7. 2+ audit devices configured. Status: Results.json > '.vault."vault audit list -format=json".result'
# 8. Check nomad and consul servers are not installed and running: Results.json > '.host."nomad agent-info".result' + '.host."consul info".result'
# 9. Check vault is installed via package not binary. Status: Results.json > '.host."dpkg-query -W vault-enterprise".result'
# 10. Check ownership on /opt/vault. Status: Results.json > '.host."ls -ldF /opt/vault".result'

### Usage & License Assessment
# 11. Check vault usage on Vault 1.6+. Status: Results.json > '.vault."vault operator usage -format=json".result'
# 12. Check license details. Status: Results.json > '.vault."vault license get -format=json".result'

host {
# select specific commands to run
  selects = ["ps -u root", #1
             "ps -u vault", #1
             "systemctl show vault --property=LimitMEMLOCK", #3
             "systemctl show vault --property=LimitCORE", #4
             "systemctl show vault --property=ProtectSystem", #6
             "systemctl show vault --property=PrivateTmp", #6
             "systemctl show vault --property=CapabilityBoundingSet", #6
             "systemctl show vault --property=AmbientCapabilities", #6
             "systemctl show vault --property=ProtectHome", #6
             "systemctl show vault --property=PrivateDevices", #6
             "systemctl show vault --property=NoNewPrivileges", #6
             "consul info", #8
             "nomad agent-info", #8
             "dpkg-query -W vault-enterprise", #9
             "ls -ldF /opt/vault"] #10

# check vault is running as vault user
  command {
    run = "ps -u root"
    format = "string"
  }
  command {
    run = "ps -u vault"
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
    run ="nomad agent-info"
    format = "string"
  } 
  command {
    run ="consul info"
    format = "string"
  } 
# check vault is installed using package not binary
  command {
    run = "dpkg-query -W vault-enterprise"
    format = "string"
  }
# check ownership on /opt/vault
  command {
    run = "ls -ldF /opt/vault"
    format = "string"
  }
}

product "vault" {
# select specific commands to run
  selects = ["vault read sys/config/state/sanitized -format=json", #2
             "vault version", #5
             "vault audit list -format=json", #7
             "vault operator usage -format=json", #11
             "vault license get -format=json",
             "GET /v1/sys/health",
             "GET /v1/sys/storage/raft/snapshot-auto/config?list=true",
             "GET /v1/sys/storage/raft/autopilot/state", 
             "GET /v1/kmip/config",
             "vault secrets list -format=json",
             "GET /v1/sys/ha-status",
             "GET /v1/sys/sealwrap/rewrap",
             "GET /v1/sys/rotate/config",
             "GET /v1/sys/replication/status"]

]

# check vault usage on vault 1.6+
  command {
    run = "vault operator usage -format=json"
    format = "json"
  }

# check vault license
  command {
    run = "vault license get -format=json"
    format = "json"
  }

# check 2+ audit devices
  command {
    run = "vault audit list -format=json"
    format = "json"
  }

# get vault config outside of vault debug
  command {
    run = "vault read sys/config/state/sanitized -format=json"
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

# check replication status
  command {
    run = "vault read sys/replication/status -format=json"
    format = "json"
  }
  command {
    run = "vault read sys/replication/performance/status -format=json"
    format = "json"
  }
  command {
    run = "vault read sys/replication/dr/status -format=json"
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

# license status
  command {
    run = "vault read sys/license/status -format=json"
    format = "json"
  }

# check vault ent license
  GET {
    path = "/v1/sys/health"
  }

# check snapshot config
  GET {
    path = "/v1/sys/storage/raft/snapshot-auto/config?list=true"
  }

# check storage autopilot, redundancy zones, and automated upgrades
  GET {
    path = "/v1/sys/storage/raft/autopilot/state"
  }

# read kmpi secrets engine
  GET {
    path = "/v1/kmip/config"
  }

# read high availability mode status
  GET {
    path = "/v1/sys/ha-status"
  }

# read kmip secrets engine
  command {
    run = "vault secrets list -format=json"
    format = "json"
  }

# check seal wrapping
  GET {
    path = "/v1/sys/sealwrap/rewrap"
  } 

# check automated encryption key rotation
  GET {
    path = "/v1/sys/rotate/config"
  }

  # check replication status
  GET {
    path = "/v1/sys/replication/status"
  }  

}
