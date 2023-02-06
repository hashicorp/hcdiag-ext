# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# hcdiag beta: Terraform Enterprise checks

host {
  selects = [ # Configuration Checks
              "docker version --format '{{.Client.Version}}'",
              "docker version --format '{{.Server.Version}}'"
            ]

  command {
    run = "docker version --format '{{.Client.Version}}'"
    format = "string"
  }
  command {
    run = "docker version --format '{{.Server.Version}}'"
    format = "string"
  }
}

product "terraform-ent" {
  selects = [ # Executive Checks
              "replicatedctl license inspect",
              "GET /api/v2/admin/runs?page%5Bsize%5D=1",
              "GET /api/v2/admin/workspaces?page%5Bsize%5D=1",
              "replicatedctl preflight run --output json",
              "replicatedctl app-config export --template '{{.production_type.Value}}'",
              "replicatedctl app-config export --template '{{.log_forwarding_enabled.Value}}'",
              "replicatedctl app-config export --template '{{.metrics_endpoint_enabled.Value}}'",

              # Configuration Checks
              "GET /_health_check?full=1",
              "replicatedctl params export",
              "replicatedctl app-config export --template 'Concurrency\t{{.capacity_concurrency.Value}}\nMemory\t{{.capacity_memory.Value}}\nCPU_limit\t{{.capacity_cpus.Value}}\n'",
              "GET /api/v2/admin/general-settings",
              "GET /api/v2/admin/runs?page%5Bsize%5D=1",
              "GET /api/v2/admin/organizations?page%5Bsize%5D=1",
              "replicatedctl snapshot ls --output json",
              "GET /api/v2/admin/cost-estimation-settings"
            ]

# check license and version
  command {
    run = "replicatedctl license inspect"
    format = "json"
  }

# check features in use
  GET {
    path = "/api/v2/admin/runs?page%5Bsize%5D=1" # '.meta."status-counts"."policy-checked"' & '.meta."status-counts"."cost-estimated"' & '.meta."status-counts"."post-plan-completed"'
  }

# check workspace count
  GET {
    path = "/api/v2/admin/workspaces?page%5Bsize%5D=1" # '.meta."status-counts"."total"'
  }

# check for red flags
## preflight failure
  command {
    run = "replicatedctl preflight run --output json" # '.MaxSeverity'
    format = "json"
  }

## check external services is used for cloud deployments 
## or mounted disk for "on-premise" deployments
  command {
    run = "replicatedctl app-config export --template '{{.production_type.Value}}'"
    format = "string"
  }

## recommend log forwarding for better observability
  command {
    run = "replicatedctl app-config export --template '{{.log_forwarding_enabled.Value}}'"
    format = "string"
  }

## check metrics collection is enabled
  command {
    run = "replicatedctl app-config export --template '{{.metrics_endpoint_enabled.Value}}'"
    format = "string"
  }

# services health check
  GET {
    path = "/_health_check?full=1"
  }

# check replicated configuration parameters
  command {
    run = "replicatedctl params export"
    format = "json"
  }

# check capacity configuration
  command {
    run = "replicatedctl app-config export --template 'Concurrency\t{{.capacity_concurrency.Value}}\nMemory\t{{.capacity_memory.Value}}\nCPU_limit\t{{.capacity_cpus.Value}}\n'"
    format = "string"
  }

# check general settings
  GET {
    path = "/api/v2/admin/general-settings"
  }

# check organization defaults
  GET {
    path = "/api/v2/admin/organizations?page%5Bsize%5D=1"
  }

# check snapshots are configured and in use
  command {
    run = "replicatedctl snapshot ls --output json"
    format = "json"
  }

# check cost estimation is configured and in use
  GET {
    path = "/api/v2/admin/cost-estimation-settings" # '.data.attributes.enabled'
  }

# check SAML is configured and in use
  GET {
    path = "/api/v2/admin/saml-settings" # '.data.attributes.enabled'
  }
}
