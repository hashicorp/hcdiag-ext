# hcdiag-ext

Modified hcdiag configuration for use by HashiCorp with Customers.

The hcdiag-ext configuration (with hcdiag) can now be run on a remote host (eg laptop or desktop) as long as the host has network access to the cluster being queried and the necessary environment variables set. The remote execution ability removes the need to install anything on the cluster, significantly easing use and reducing concerns around security and change management.

You can either use the online version of these scripts hosted in GitHub pages at https://hashicorp.github.io/hcdiag-ext or download this repository and run the html files locally. All configuration generation and results parsing is handled with client side javascript. The only remote request is to load some fonts from https://fonts.googleapis.com to match HashiCorp branding.

## Execution summary

The installation and execution can be summarised in just a few steps, but is explained in detail below this summary.

**New for v0.6.x**

1. Install hcdiag on your local machine or product instance, either manually or using the HashiCorp package respositories
1. Configure your local machine or product instance with the necessary environment variables to connect and authenticate
1. Generate the hcdiag-ext configuration specific to your [Vault](https://hashicorp.github.io/hcdiag-ext/vault-ent-configuration.html) and/or [Terraform](https://hashicorp.github.io/hcdiag-ext/terraform-ent-configuration.html) use case
    - Note: there are some constraints to consider for both products which are explained in the full instructions below
1. Run hcdiag with the necessary arguments to use the hcdiag-ext specific configuration file
1. Use the [Vault](https://hashicorp.github.io/hcdiag-ext/vault-ent-parser.html) and/or [Terraform](https://hashicorp.github.io/hcdiag-ext/terraform-ent-parser.html) results parsers to generate the results snapshot to share with your HashiCorp contact

## Detailed execution instructions

### Install the hcdiag binary or package on your local machine or a product instance

- Download [hcdiag v0.5.0](https://releases.hashicorp.com/hcdiag/0.5.0/) manually and install on your PATH _or_ use a [package manager](https://www.hashicorp.com/official-packaging-guide):

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

### Install and run hcdiag-ext configuration on your local machine or a product instance

The configurations generated in hcdiag-ext v0.6.x only make GET API requests and do not make hcdiag attempt to run any other commands. Privileged access to the product APIs is required to provide complete results.

#### For Terraform Enterprise
  
- Access the hcdiag-ext [Configuration Generator for Terraform Enterprise](https://hashicorp.github.io/hcdiag-ext/terraform-ent-configuration.html)
- Either download the hcl file using the download button, or if you want to paste the file contents directly into a file, copy the hcl file contents to your clipboard using the copy button and create `hcdiag_terraform_configuration.hcl`
- On your local machine or an instance in the product cluster, export the `TFE_TOKEN` and `TFE_HTTP_ADDR` environment variables so hcdiag can query the product
  - The token should be a user token for an account with administrator privileges so the admin API can be queried
- Run hcdiag with specific configuration you have downloaded in the earlier steps `hcdiag run -terraform-ent -config /path/to/hcdiag_terraform_configuration.hcl`


#### For Vault Enterprise

ℹ️ To get accurate data, you must know the Vault subscription start time in the format `YYYY-MM-DD`.

- Access the hcdiag-ext [Configuration Generator for Vault Enterprise](https://hashicorp.github.io/hcdiag-ext/vault-ent-configuration.html)
- Either download the hcl file using the download button, or if you want to paste the file contents directly into a file, copy the hcl file contents to your clipboard using the copy button and create `hcdiag_vault_configuration.hcl`
- On your local machine or an instance in the product cluster, export the `VAULT_TOKEN` and `VAULT_ADDR` environment variables so hcdiag can query the product
  - An example Vault policy for hcdiag-ext read-only access to the Vault API is contained in this release [`hcdiag_vault_policy.hcl`](hcdiag_vault_policy.hcl) to ensure the principle of least privilege
- Run hcdiag with specific configuration you have downloaded in the earlier steps `hcdiag run -vault -config /path/to/hcdiag_vault_configuration.hcl`

### Parse the results file to create a summary table of product data

- Unpack the hcdiag tar.gz bundle that was generated during the hcdiag run
- If running hcdiag on the product instance, copy the `results.json` file from the product instance to your local machine
- Use the [Vault](https://hashicorp.github.io/hcdiag-ext/vault-ent-parser.html) and/or [Terraform](https://hashicorp.github.io/hcdiag-ext/terraform-ent-parser.html) results parsers to generate the results snapshot to share with your HashiCorp contact
