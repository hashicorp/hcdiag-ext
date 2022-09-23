# hcdiag-ext
Extensions for hcdiag.

The below steps explain how to run hcdiag and share the results with HashiCorp.

- Download [hcdiag v3](https://releases.hashicorp.com/hcdiag/0.3.0/) or use your package manager
- Download the extended configuration for hcdiag from https://github.com/hashicorp/hcdiag-ext/archive/refs/tags/v0.3.0.zip
- SHA256SUM: 9a47199a622259ec97eaec6a2ae379feab864d8a4241f4ab818c773b17d3a314
- Extract the hcdiag binary from the package and the `hcdiag_<tool>.hcl` file from the zip (from step 2) on the server instances running the respective tool.
- The hcdiag binary is best run by a superuser account
- Set environment variables:
  - For Vault Enterprise, the VAULT_TOKEN and VAULT_ADDR environment variables must be set
  - For Terraform Enterprise, the TFE_TOKEN and TFE_HTTP_ADDR environment variables must be set
  - For Consul Enterprise, the CONSUL_TOKEN and CONSUL_HTTP_ADDR environment variables must be set
- Run hcdiag:
  - Vault Enterprise: `hcdiag -vault -config /path/to/hcdiag_vault.hcl`
  - Terraform Enterprise: `hcdiag -terraform -config /path/to/hcdiag_terraform.hcl`
  - Consul Enterprise: `hcdiag -consul -config /path/to/hcdiag_consul.hcl`
- Submit the bundle to HashiCorp via the HashiCorp SendSafely portal link shared by your CSM

