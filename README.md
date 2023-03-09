# hcdiag-ext

Modified hcdiag configuration for use by HashiCorp with Customers.

Process to run hcdiag and share the results with HashiCorp:

1. Use your package manager to install hcdiag (0.5.0-1) or download [hcdiag v0.5.0](https://releases.hashicorp.com/hcdiag/0.5.0/) manually:
    ```sh
    # Example Debian package install steps
    curl -fsSL https://apt.releases.hashicorp.com/gpg > /tmp/hashicorp.key
    apt-key add < /tmp/hashicorp.key
    apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    apt-get update --fix-missing
    apt-get install hcdiag="0.5.0-1" --yes
    
    # Example RHEL package install steps
    yum install -y yum-utils git jq unzip ca-certificates
    yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
    yum install hcdiag-0.5.0-1 -y
    ```
1. Download  [hcdiag-ext v0.4.1 release package](https://github.com/hashicorp/hcdiag-ext/archive/refs/tags/v0.4.1.zip) of this extended configuration [^1]
1. Extract the `hcdiag_<tool>.hcl` file from the hcdiag-ext zip (from the above step) on the server instances running the respective product
1. Set the necessary environment variables so hcdiag can query the product:
    - For Vault Enterprise, the `VAULT_TOKEN` and `VAULT_ADDR` environment variables must be set
      - An example policy for hcdiag-ext (`hcdiag_vault_policy.hcl`) is contained in this release to limit the scope hcdiag has within Vault 
    - For Terraform Enterprise, the `TFE_TOKEN` and `TFE_HTTP_ADDR` environment variables must be set
    - For Consul Enterprise, the `CONSUL_TOKEN` and `CONSUL_HTTP_ADDR` environment variables must be set
1. hcdiag is best run by a superuser account or the account running the respective product
1. Run hcdiag with specific configuration:
    - Vault Enterprise: `hcdiag run -vault -config /path/to/hcdiag_vault.hcl`
    - Terraform Enterprise: `hcdiag run -terraform-ent -config /path/to/hcdiag_terraform.hcl`
    - Consul Enterprise: `hcdiag run -consul -config /path/to/hcdiag_consul.hcl`
1. Submit the bundle to HashiCorp via the HashiCorp SendSafely portal link shared by your HashiCorp contact

[^1]: SHA256SUM: 30a90d249964987ae18f3f0106bcb13aa57b428ef34b52e65bb4922e3e2542cf
