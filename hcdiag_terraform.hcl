# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Terraform Enterprise checks

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
  selects = [
              "replicatedctl license inspect",
              "GET /api/v2/admin/runs?page%5Bsize%5D=1",
              "GET /api/v2/admin/workspaces?page%5Bsize%5D=1",
              "replicatedctl preflight run --output json",
              "replicatedctl app-config export --template '{{.log_forwarding_enabled.Value}}'",
              "replicatedctl app-config export --template '{{.metrics_endpoint_enabled.Value}}'",
              "GET /_health_check?full=1",
              "replicatedctl snapshot ls --output json",
            ]

# check license and version
  command {
    run = "replicatedctl license inspect"
    format = "json"
  }

# check features in use '.meta."status-counts"."policy-checked"' & '.meta."status-counts"."cost-estimated"' & '.meta."status-counts"."post-plan-completed"'
  GET {
    path = "/api/v2/admin/runs?page%5Bsize%5D=1"
  }

# check workspace count '.meta."status-counts"."total"'
  GET {
    path = "/api/v2/admin/workspaces?page%5Bsize%5D=1" 
  }

# check for preflight failure '.MaxSeverity'
  command {
    run = "replicatedctl preflight run --output json"
    format = "json"
  }

# check log forwarding for better observability
  command {
    run = "replicatedctl app-config export --template '{{.log_forwarding_enabled.Value}}'"
    format = "string"
  }

# check metrics collection is enabled for better observability
  command {
    run = "replicatedctl app-config export --template '{{.metrics_endpoint_enabled.Value}}'"
    format = "string"
  }

# services health check
  GET {
    path = "/_health_check?full=1"
  }

# check snapshots are configured and in use
  command {
    run = "replicatedctl snapshot ls --output json"
    format = "json"
  }
