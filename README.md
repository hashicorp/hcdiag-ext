# hcdiag-ext

Modified hcdiag configuration for use by HashiCorp with Customers.

## Install HCDiag

- Use your package manager to install hcdiag (0.5.0-1) or
- Download [hcdiag v0.5.0](https://releases.hashicorp.com/hcdiag/0.5.0/) manually using RHEL:
```sh
# Example RHEL package install steps
yum install -y yum-utils git jq unzip ca-certificates
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum install hcdiag-0.5.0-1 -y
```

or Debian

```sh
# Example Debian package install steps
curl -fsSL https://apt.releases.hashicorp.com/gpg > /tmp/hashicorp.key
apt-key add < /tmp/hashicorp.key
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt-get update --fix-missing
apt-get install hcdiag="0.5.0-1" --yes
```

## Access hcdiag-ext configuration

- If sufficient access exists, download and unpack [hcdiag-ext v0.4.1 release package](https://github.com/hashicorp/hcdiag-ext/archive/refs/tags/v0.4.1.zip) of this extended configuration [^1] to the target machine(s) using
```sh
curl -#Lk https://github.com/hashicorp/hcdiag-ext/archive/refs/tags/v0.4.1.zip -o hcdiag-ext-0.4.1.zip
unzip hcdiag-ext-0.4.1.zip
```
- If the target instances are air gapped, run the above commands through your web proxy and then scp the relevant files to the target machines such that hcdiag has access to the correct configuration file prior to use.
- _On the target host(s)_, export the necessary environment variables so hcdiag can query the product:
  - For Vault Enterprise, the `VAULT_TOKEN` and `VAULT_ADDR` environment variables must be set
    - An example policy for hcdiag-ext (`hcdiag_vault_policy.hcl`) is contained in this release to limit the scope hcdiag has within Vault
  - For Terraform Enterprise, the `TFE_TOKEN` and `TFE_HTTP_ADDR` environment variables must be set
  - For Consul Enterprise, the `CONSUL_TOKEN` and `CONSUL_HTTP_ADDR` environment variables must be set

## Run hcdiag with the configuration

1. hcdiag is best run by a superuser account or the account running the respective product; current hcdiag-ext configurations do not make hcdiag attempt to run commands which require root access, but privileged access to the product API(s) are required to provide proper results.
1. Run hcdiag with specific configuration:
    - Vault Enterprise: `hcdiag run -vault -config /path/to/hcdiag_vault.hcl`
    - Terraform Enterprise: `hcdiag run -terraform-ent -config /path/to/hcdiag_terraform.hcl`
    - Consul Enterprise: `hcdiag run -consul -config /path/to/hcdiag_consul.hcl`
1. Submit the bundle to HashiCorp via the HashiCorp SendSafely portal link shared by your HashiCorp contact. If you do not have this, please contact your HashiCorp Solution Architect or Customer Success Manager

[^1]: SHA256SUM: 30a90d249964987ae18f3f0106bcb13aa57b428ef34b52e65bb4922e3e2542cf
