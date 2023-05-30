# hcdiag-ext

Modified hcdiag configuration for use by HashiCorp with Customers.

ℹ️ hcdiag-ext (with hcdiag) can now be run on a host remotely (eg laptop or desktop) as long as the host has network access to the cluster being queried. This removes the need to install anything on the cluster, significantly easing use and reducing concerns around security and change management.

## Install the hcdiag binary or package on your local machine or a product instance

- Download [hcdiag v0.5.0](https://releases.hashicorp.com/hcdiag/0.5.0/) manually and install on your PATH _or_ use a package manager:

  ```sh
  # Example RHEL package install steps
  yum install -y yum-utils unzip
  yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
  yum install hcdiag-0.5.0-1 -y

  # Example Debian package install steps
  apt update && apt install --yes curl gpg unzip
  curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor > /tmp/hashicorp.gpg
  mv /tmp/hashicorp.gpg /usr/share/keyrings/hashicorp-archive-keyring.gpg
  chmod 644 /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
  apt update
  apt install hcdiag="0.5.0-1" --yes
  ```

## Install hcdiag-ext configuration on your local machine or a product instance

- Download and unpack the [latest hcdiag-ext release package](https://github.com/hashicorp/hcdiag-ext/releases/latest) on your local machine or an instance in the product cluster:

  ```sh
  # Example Linux steps
  curl -Lk https://github.com/hashicorp/hcdiag-ext/archive/refs/tags/v0.5.0.zip -o hcdiag-ext-0.5.0.zip
  unzip hcdiag-ext-0.5.0.zip
  ```

- If you are running this on an instance in the product cluster and it is [air gapped](https://en.wikipedia.org/wiki/Air_gap_(networking)), run the above commands through your web proxy and then copy the relevant hcl files to the target so hcdiag can access them prior to execution.
- On your local machine or an instance in the product cluster, export the necessary environment variables so hcdiag can query the product:
  - For Vault Enterprise, the `VAULT_TOKEN` and `VAULT_ADDR` environment variables must be set
    - An example policy for hcdiag-ext (`hcdiag_vault_policy.hcl`) is contained in this release to limit the scope hcdiag has within Vault
  - For Terraform Enterprise, the `TFE_TOKEN` and `TFE_HTTP_ADDR` environment variables must be set
    - The token should be a user token for an account with administrator privileges so the admin API can be queried
  - For Consul Enterprise, the `CONSUL_TOKEN` and `CONSUL_HTTP_ADDR` environment variables must be set

## Run hcdiag with the hcdiag-ext configuration

ℹ️ Current hcdiag-ext configurations only make API requests and do not make hcdiag attempt to run any other commands. Privileged access to the product API(s) is required to provide complete results.

1. Run hcdiag with specific configuration:
    - Vault Enterprise: `hcdiag run -vault -config /path/to/hcdiag_vault.hcl`
    - Terraform Enterprise: `hcdiag run -terraform-ent -config /path/to/hcdiag_terraform.hcl`
    - Consul Enterprise: `hcdiag run -consul -config /path/to/hcdiag_consul.hcl`
1. Submit the bundle to HashiCorp via the HashiCorp SendSafely portal link shared by your HashiCorp contact.
