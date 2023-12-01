# Terraform AWS Client VPN
Create an AWS Client VPN that uses AWS SSO as the identify provider.  You will need to add the AWS SSO SAML Application metadata files to the `terrafrom/metadata` directory.

```hcl
# Example .tfvars file
access_group_id     = "969d7ecb-8d60-4bf9-bd86-79cd517b95b2" # IAM identity center group ID that is allowed access
availability_zone   = "ca-central-1d"                        # The AZ of the RDS writer instance
endpoint_name       = "test-vpn"
postgresql_username = "root_username"
postgresql_password = "root_password"
```

As part of this example an Aurora Postgres cluster is created in the private subnets that allows access while connected to the client VPN.

# Credit
- [fivexl/terraform-aws-client-vpn-endpoint](https://github.com/fivexl/terraform-aws-client-vpn-endpoint)
