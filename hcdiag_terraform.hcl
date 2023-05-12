# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Terraform Enterprise checks

host {
  selects = [":"] # noop to ensure no other default hcdiag host commands are auto-loaded
  shell {
    run = ":"
  }
}

product "terraform-ent" {
  selects = [
              "GET /api/v2/admin/release",
              "GET /api/v2/admin/runs?page%5Bsize%5D=1",
              "GET /api/v2/admin/workspaces?page%5Bsize%5D=1",
            ]

# check version
  GET {
    path = "/api/v2/admin/release"
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
