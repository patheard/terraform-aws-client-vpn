module "test_vpn_vpc" {
  source = "github.com/cds-snc/terraform-modules//vpc?ref=v7.3.2"
  name   = "test-vpn-vpc"

  high_availability  = true
  enable_flow_log    = true
  single_nat_gateway = true

  allow_https_request_out          = true
  allow_https_request_out_response = true
  allow_https_request_in           = true
  allow_https_request_in_response  = true

  billing_tag_value = "platform-core"
}
