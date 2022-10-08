# hcdiag beta: Vault Enterprise checks

host {
  selects = [ # Configuration Checks
              "kubectl exec vault-0 -- ps u -o user",
              "kubectl get statefulset --all-namespaces -o json",
              "kubectl get cm --all-namespaces -o json",
              "kubectl get pods --selector='app.kubernetes.io/name=consul'"
            ]
# check vault is running as vault user
  command {
    run = "kubectl exec vault-0 -- ps u -o user"
    format = "string"
  }

# check the stateful set - to see the version of the  helm chart
  command {
    run = "kubectl get statefulset --all-namespaces -o json"
    format = "json"
  }

# check for the configmap to verify passed helm chart variables
  command {
    run = "kubectl get cm --all-namespaces -o json"
    format = "json"
  }


# check for consul
  command {
    run ="kubectl get pods --selector='app.kubernetes.io/name=consul'"
    format = "string"
  }
}


product "vault" {
  selects = [ # Executive Checks
              "GET /v1/sys/health",
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
              "GET /v1/sys/sealwrap/rewrap",
              "GET /v1/sys/rotate/config",
              "GET /v1/sys/replication/status"
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

# Check if seal wrap is in use
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
