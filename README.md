# hcdiag-ext

Modified hcdiag configuration for use by HashiCorp Customer Success.

Process to run hcdiag and share the results with HashiCorp:

- Download [hcdiag v0.3.0](https://releases.hashicorp.com/hcdiag/0.3.0/) or use your package manager to install version 0.3.0-1
- Download this extended configuration for hcdiag from https://github.com/hashicorp/hcdiag-ext/archive/refs/tags/v0.3.0.zip [^1]
- Extract the hcdiag binary from the package and the `hcdiag_<tool>.hcl` file from the zip (from step 2) on the server instances running the respective product
- Set the necessary environment variables so hcdiag can query the product:
  - For Vault Enterprise, the `VAULT_TOKEN` and `VAULT_ADDR` environment variables must be set
  - For Terraform Enterprise, the `TFE_TOKEN` and `TFE_HTTP_ADDR` environment variables must be set
  - For Consul Enterprise, the `CONSUL_TOKEN` and `CONSUL_HTTP_ADDR` environment variables must be set
- hcdiag is best run by a superuser account or the account running the respective product
- Run hcdiag with specific configuration:
  - Vault Enterprise: `hcdiag -vault -config /path/to/hcdiag_vault.hcl`
  - Terraform Enterprise: `hcdiag -terraform -config /path/to/hcdiag_terraform.hcl`
  - Consul Enterprise: `hcdiag -consul -config /path/to/hcdiag_consul.hcl`
- Submit the bundle to HashiCorp via the HashiCorp SendSafely portal link shared by your CSM

[^1]: SHA256SUM: 9a47199a622259ec97eaec6a2ae379feab864d8a4241f4ab818c773b17d3a314
