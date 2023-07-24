# hcdiag-ext

Modified hcdiag configuration for use by HashiCorp with Customers.

ℹ️ The hcdiag-ext configuration (with hcdiag) can now be run on a remote host (eg laptop or desktop) as long as the host has network access to the cluster being queried. When querying a Vault or Consul cluster, the remote host currently also needs a vault or consul binary to pass [an initial hcdiag startup check](https://github.com/hashicorp/hcdiag/blob/main/agent/agent.go#L443-L467). This is not necessary for Terraform and we are looking to remove this requirement for all hcdiag-ext v0.5.x "API-only" use cases. The remote execution ability removes the need to install anything on the cluster, significantly easing use and reducing concerns around security and change management.

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

- For hcdiag-ext remote execution with Vault or Consul: Install the vault or consul binary or package on your local machine:

  ```sh
  # Example RHEL package install steps
  yum install vault consul -y
  ```

  ```sh
  # Example Debian package install steps
  apt install vault consul --yes
  ```
  
  ```sh
  # Example Homebrew package install steps
  brew install vault consul
  ```
  
  ```sh
  # Example Chocolatey package install steps
  choco install vault consul
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
1. Submit the bundle to HashiCorp via the HashiCorp SendSafely portal link shared by your HashiCorp contact.
