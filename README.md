# hcdiag-ext

Modified hcdiag configuration for use by HashiCorp with Customers.

ℹ️ The hcdiag-ext configuration (with hcdiag) can now be run on a remote host (eg laptop or desktop) as long as the host has network access to the cluster being queried and the necessary environment variables set. When querying a Vault cluster, the remote host currently also needs a vault binary to pass [an initial hcdiag startup check](https://github.com/hashicorp/hcdiag/blob/v0.5.0/agent/agent.go#L443-L467). This is not necessary for Terraform and we are looking to remove this requirement for all hcdiag-ext v0.5.x "API-only" use cases. The remote execution ability removes the need to install anything on the cluster, significantly easing use and reducing concerns around security and change management.

## Execution summary

The installation and execution can be summarised in just a few steps, but is explained in detail below this summary.

1. Install hcdiag on your local machine or product instance, either manually or using the HashiCorp package respositories
1. Configure your local machine or product instance with the necessary environment variables to connect and authenticate
1. **New in v0.6.x**: Download the hcdiag-ext configuration on your local machine or product instance from the GitHub page linked to this repository: [Vault](https://hashicorp.github.io/hcdiag-ext/vault-ent.html) or [Terraform](https://hashicorp.github.io/hcdiag-ext/terraform-ent.html)
    - Note: there are some constraints to consider for both products which are explained in the full instructions below
1. Run hcdiag with the necessary arguments to use the hcdiag-ext specific configuration file
1. Share the results with your HashiCorp contact using our secure portal

## Install the hcdiag binary or package on your local machine or a product instance

- Download [hcdiag v0.5.0](https://releases.hashicorp.com/hcdiag/0.5.0/) manually and install on your PATH _or_ use a package manager:

  ```sh
  # Example RHEL package install steps
  yum install -y yum-utils unzip
  yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
  yum install hcdiag-0.5.0-1 -y
  ```
  
  ```sh
  # Example Debian package install steps
  apt update && apt install --yes curl gpg unzip
  curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor > /tmp/hashicorp.gpg
  mv /tmp/hashicorp.gpg /usr/share/keyrings/hashicorp-archive-keyring.gpg
  chmod 644 /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
  apt update
  apt install hcdiag="0.5.0-1" --yes
  ```

- For hcdiag-ext remote execution, you need to have the Vault binary locally to pass [an initial hcdiag startup check](https://github.com/hashicorp/hcdiag/blob/v0.5.0/agent/agent.go#L443-L467):

  ```sh
  # Example RHEL package install steps
  yum install vault
  ```

  ```sh
  # Example Debian package install steps
  apt install vault
  ```
  
  ```sh
  # Example Homebrew package install steps
  brew install vault
  ```
  
  ```sh
  # Example Chocolatey package install steps
  choco install vault
  ```

## Install hcdiag-ext configuration on your local machine or a product instance

### For Terraform Enterprise
  
- Access the hcdiag-ext configuration at https://hashicorp.github.io/hcdiag-ext/terraform-ent.html
- Either download the hcl file using the download button, or if you want to paste the file contents directly into a file, copy the hcl file contents to your clipboard using the copy button
- On your local machine or an instance in the product cluster, export the `TFE_TOKEN` and `TFE_HTTP_ADDR` environment variables so hcdiag can query the product
  - The token should be a user token for an account with administrator privileges so the admin API can be queried

### For Vault Enterprise

ℹ️ To get accurate data, you must know the Vault subscription start time in the format `YYYY-MM-DD`

- Access the hcdiag-ext configuration and pass in the start time at https://hashicorp.github.io/hcdiag-ext/vault-ent.html
- Either download the hcl file using the download button, or if you want to paste the file contents directly into a file, copy the hcl file contents to your clipboard using the copy button
- On your local machine or an instance in the product cluster, export the `VAULT_TOKEN` and `VAULT_ADDR` environment variables so hcdiag can query the product
  - An example policy for hcdiag-ext (`hcdiag_vault_policy.hcl`) is contained in this release to limit the scope hcdiag has within Vault

## Run hcdiag with the hcdiag-ext configuration

ℹ️ Current hcdiag-ext configurations only make API requests and do not make hcdiag attempt to run any other commands. Privileged access to the product API(s) is required to provide complete results.

1. Run hcdiag with specific configuration you have downloaded in the earlier steps:
    - Vault Enterprise: `hcdiag run -vault -config /path/to/vault-ent.hcl`
    - Terraform Enterprise: `hcdiag run -terraform-ent -config /path/to/terraform-ent.hcl`
1. Submit the bundle to HashiCorp via the HashiCorp SendSafely secure portal link shared by your HashiCorp contact
