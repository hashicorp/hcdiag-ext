# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Terraform Enterprise checks

host {
  selects = ["true"]
  command {
    run = "true"
    format = "string"
  }
}

product "terraform-ent" {
  selects = [
              "replicatedctl license inspect",
              "GET /api/v2/admin/runs?page%5Bsize%5D=1",
              "GET /api/v2/admin/workspaces?page%5Bsize%5D=1",
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
}
