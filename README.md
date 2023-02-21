# hcdiag-ext

Modified hcdiag configuration for use by HashiCorp Technical Field Operations.

Process to run hcdiag and share the results with HashiCorp:

- Download [hcdiag v0.5.0](https://releases.hashicorp.com/hcdiag/0.5.0/) or use your package manager to install version 0.5.0-1
- Download this extended configuration for hcdiag from https://github.com/hashicorp/hcdiag-ext/archive/refs/tags/v0.5.0.zip [^1]
- Extract the hcdiag binary from the package and the `hcdiag_<tool>.hcl` file from the zip (from step 2) on the server instances running the respective product
- Set the necessary environment variables so hcdiag can query the product:
  - For Vault Enterprise, the `VAULT_TOKEN` and `VAULT_ADDR` environment variables must be set
  - For Terraform Enterprise, the `TFE_TOKEN` and `TFE_HTTP_ADDR` environment variables must be set
  - For Consul Enterprise, the `CONSUL_TOKEN` and `CONSUL_HTTP_ADDR` environment variables must be set
- hcdiag is best run by a superuser account or the account running the respective product
- Run hcdiag with specific configuration:
  - Vault Enterprise: `hcdiag run -vault -config /path/to/hcdiag_vault.hcl`
  - Terraform Enterprise: `hcdiag run -terraform-ent -config /path/to/hcdiag_terraform.hcl`
  - Consul Enterprise: `hcdiag run -consul -config /path/to/hcdiag_consul.hcl`
- Submit the bundle to HashiCorp via the HashiCorp SendSafely portal link shared by your HashiCorp contact

[^1]: SHA256SUM: TBC
