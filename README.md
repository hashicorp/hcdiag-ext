# hcdiag-ext

Modified hcdiag configuration for use by HashiCorp Technical Field Operations.

Process to run hcdiag and share the results with HashiCorp:

- Use your package manager to install hcdiag (0.5.0-1) or download [hcdiag v0.5.0](https://releases.hashicorp.com/hcdiag/0.5.0/) manually:
  ```sh
  # Example package install steps
  curl -fsSL https://apt.releases.hashicorp.com/gpg > /tmp/hashicorp.key
  apt-key add < /tmp/hashicorp.key
  apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
  apt-get update --fix-missing
  apt-get install hcdiag="0.5.0-1" --yes
  ```
- Download  [hcdiag-ext v0.4.0 release package](https://github.com/hashicorp/hcdiag-ext/archive/refs/tags/v0.4.0.zip) of this extended configuration [^1]
- Extract the hcdiag binary from the package and the `hcdiag_<tool>.hcl` file from the zip (from step 2) on the server instances running the respective product
- Set the necessary environment variables so hcdiag can query the product:
  - For Vault Enterprise, the `VAULT_TOKEN` and `VAULT_ADDR` environment variables must be set
    - An example policy for hcdiag-ext (`hcdiag_vault_policy.hcl`) is contained in this release to limit the scope hcdiag has within Vault 
  - For Terraform Enterprise, the `TFE_TOKEN` and `TFE_HTTP_ADDR` environment variables must be set
  - For Consul Enterprise, the `CONSUL_TOKEN` and `CONSUL_HTTP_ADDR` environment variables must be set
- hcdiag is best run by a superuser account or the account running the respective product
- Run hcdiag with specific configuration:
  - Vault Enterprise: `hcdiag run -vault -config /path/to/hcdiag_vault.hcl`
  - Terraform Enterprise: `hcdiag run -terraform-ent -config /path/to/hcdiag_terraform.hcl`
  - Consul Enterprise: `hcdiag run -consul -config /path/to/hcdiag_consul.hcl`
- Submit the bundle to HashiCorp via the HashiCorp SendSafely portal link shared by your HashiCorp contact

[^1]: SHA256SUM: TBC
