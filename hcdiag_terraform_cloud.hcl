# This sample script illustrates the use of the Terraform Cloud API to gather 
# information about an organization's entitlements and activation status. The 
# purpose is to help an administrator validate the feature set assembled to 
# support workflow activities.
# The TFE_HTTP_ADDR points to the baseline URL is expressed as follows:
#
# export TFE_HTTP_ADDR=https://app.terraform.io 
#
# We use TFE_TOKEN instead of TFC_TOKEN to maintain legacy compatibility in 
# the naming convention. hcdiag is hard-coded to interpret TFE_TOKEN.
#
# export TFE_TOKEN="YOUR_TFC_TOKEN_HERE"
#
# For this diagnostics exercises, the name of the TFC organization needs to be
# expressed. Because hcdiag does not support variable inheritance from the 
# command line, we need to replace the `TFE_ORG` placeholder in this template
# with your expressed variable.
# 
# export TFE_ORG="YOUR_TFC_ORGANIZATION_NAME"
#
# In OSX or Linux you can use the following command, or just run find/replace.
#
# sed -i '' "s|TFE_ORG|${TFE_ORG}|g" hcdiag_terraform_cloud.hcl
# 
# ---
# hcdiag beta: Terraform Enterprise checks

host {
  selects = [ # Basic OS Configuration Check
              "uname -a",
              "command -v jq"
            ]

  # Check the operating environment from which
  # we are running these commands.

  command {
    run = "uname -a"
    format = "string"
  }

  # Check for the `jq` utility operator, used 
  # to apply filtering commands on JSON data responses.

  command {
    run = "command -v jq"
    format = "string"
  }
}

# Check for features and entitlements in a Terraform Cloud organization

product "terraform-ent" {
  selects = [ # Executive Checks

              # Configuration Checks
              "GET /_health_check?full=1",

              # Terraform Cloud Entitlements
              "GET /api/v2/organizations/TFE_ORG",
              "GET /api/v2/organizations/TFE_ORG/entitlement-set",
              "GET /api/v2/organizations/TFE_ORG/subscription",
              "GET /api/v2/organizations/TFE_ORG/agent-pools",
              "GET /api/v2/organizations/TFE_ORG/varsets",
              "GET /api/v2/organizations/TFE_ORG/tasks",
              "GET /api/v2/organizations/TFE_ORG/policies",
              "GET /api/v2/organizations/TFE_ORG/policy-sets",
              "GET /api/v2/organizations/TFE_ORG/registry-modules",
              "GET /api/v2/organizations/TFE_ORG/teams",
              "GET /api/v2/organizations/TFE_ORG/vcs-events"
            ]

# Show the full set for a Terraform Cloud Organization
  GET {
    path = "/api/v2/organizations/TFE_ORG"
  }

# Get subscription entitlement
  GET {
    path = "/api/v2/organizations/TFE_ORG/entitlement-set"
  }

# Show the subscription leves for a Terraform Cloud Organization
  GET {
    path = "/api/v2/organizations/TFE_ORG/subscription"
  }

# This endpoint allows you to list agent pools, their agents, and their 
# TFE_TOKENs for the organization identified.
  GET {
    path = "/api/v2/organizations/TFE_ORG/agent-pools"
  }

# List all variable sets for an organization.
  GET {
    path = "/api/v2/organizations/TFE_ORG/varsets"
  }

# This endpoint lists all run taks available in the organization. 
# This endpoint supports pagination.
  GET {
    path = "/api/v2/organizations/TFE_ORG/tasks"
  }

# This endpoint lists the policies linked in organization.
  GET {
    path = "/api/v2/organizations/TFE_ORG/policies"
  }

# This endpoint lists the policy sets linked in the organization.
  GET {
    path = "/api/v2/organizations/TFE_ORG/policy-sets"
  }

# This enpoint lists the modules that are available to a given organization. 
# This includes the full list of publicly curated and private modules and is filterable.
  GET {
    path = "/api/v2/organizations/TFE_ORG/registry-modules"
  }

# This endpoint lists all available teams in an organization. Users can view 
# visible teams and any secret teams and their membership.
  GET {
    path = "/api/v2/organizations/TFE_ORG/teams"
  }

# This endpoint lists VCS events for an organization. 
  GET {
    path = "/api/v2/organizations/TFE_ORG/vcs-events"
  }
}
