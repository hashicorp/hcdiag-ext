### Top 10 for Health Assessment
# 1. Check preflight run is all green. Status: Results.json > '."terraform-ent"."replicatedctl preflight run".result'
# 2. Check health-check is passing. Status: Results.json > '."terraform-ent"."replicated admin health-check".result'
# 3. Check replicated configuration parameters. Status: Results.json > '."terraform-ent"."replicatedctl params export".result'
# 4. Check installation type is production. Status: Results.json > '."terraform-ent"."replicatedctl app-config view --group installation".result[].Value'
# 5. Check production storage is suitable. Status: Results.json > '."terraform-ent"."replicatedctl app-config view --group production".result[].Value'
# 6. Check log forwarding is in place. Status: Results.json > '."terraform-ent"."replicatedctl app-config view --group log_forwarding".result[].Value'
# 7. Check advanced configuration for metrics collection. Status: Results.json > '."terraform-ent"."replicatedctl app-config view --group advanced".result[].Value'
# 8. Check capacity configuration for sensible values. Status: Results.json > '."terraform-ent"."replicatedctl app-config view --group capacity".result[].Value'
# 9. Check run health and if there are Sentinel policies in use. Status: Results.json > '."terraform-ent"."GET /api/v2/admin/runs".result.meta."status-counts"'
# 10. Check if there are multiple organizations configured. Status: Results.json > '."terraform-ent"."GET /api/v2/admin/organizations".result.meta."status-counts"'

### Usage Assessment
# 11. Check workspace count. Status: Results.json > '."terraform-ent"."GET /api/v2/admin/workspaces?page%5Bsize%5D=1".result.meta.pagination."total-count"'
# 12. Check license expiration time. Status: Results.json > '."terraform-ent"."replicatedctl license inspect".result[].ExpirationTime'

product "terraform-ent" {
# select specific commands to run
  selects = ["replicatedctl preflight run", #1
             "replicated admin health-check", #2
             "replicatedctl params export", #3
             "replicatedctl app-config view --group installation", #4
             "replicatedctl app-config view --group production", #5
             "replicatedctl app-config view --group log_forwarding", #6
             "replicatedctl app-config view --group advanced", #7
             "replicatedctl app-config view --group capacity", #8
             "GET /api/v2/admin/runs", #9
             "GET /api/v2/admin/organizations", #10
             "GET /api/v2/admin/workspaces?page%5Bsize%5D=1", #11
             "replicatedctl license inspect"] #12

# admin API requests
  GET {
    path = "/api/v2/admin/runs"
  }
  GET {
    path = "/api/v2/admin/organizations"
  }
  GET {
    path = "/api/v2/admin/workspaces?page%5Bsize%5D=1"
  }

# check health-check items are green
  command {
    run = "replicated admin health-check"
    format = "string"
  }

# check preflight is still passing
  command {
    run = "replicatedctl preflight run"
    format = "string"
  }

# check replicated configuration parameters
  command {
    run = "replicatedctl params export"
    format = "json"
  }

# check production mode is set
  command {
    run = "replicatedctl app-config view --group installation"
    format = "json"
  }

# check external services is used for cloud deployments 
# or mounted disk for "on-premise" deployments
  command {
    run = "replicatedctl app-config view --group production"
    format = "json"
  }

# recommend log forwarding for better observability
  command {
    run = "replicatedctl app-config view --group log_forwarding"
    format = "json"
  }

# check metrics collection is enabled
  command {
    run = "replicatedctl app-config view --group advanced"
    format = "json"
  }

# check capacity configuration
  command {
    run = "replicatedctl app-config view --group capacity"
    format = "json"
  }

# check license and version
  command {
    run = "replicatedctl license inspect"
    format = "json"
  }
}
