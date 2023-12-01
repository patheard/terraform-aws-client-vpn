# Terraform AWS Client VPN
Create an AWS Client VPN that uses AWS SSO as the identify provider.  You will need to add the AWS SSO SAML Application metadata files to the `terrafrom/metadata` directory.

```hcl
# Example .tfvars file
access_group_id     = "some_uuid"     # IAM identity center group ID
availability_zone   = "ca-central-1d" # AZ of the RDS writer instance
endpoint_name       = "test-vpn"
postgresql_username = "root_username"
postgresql_password = "root_password"
```

As part of this example an Aurora Postgres cluster is created in the private subnets that allows access while connected to the client VPN.

# Credit
- [Authenticate AWS Client VPN users with AWS IAM Identity Center](https://aws.amazon.com/blogs/security/authenticate-aws-client-vpn-users-with-aws-single-sign-on/)
- [fivexl/terraform-aws-client-vpn-endpoint](https://github.com/fivexl/terraform-aws-client-vpn-endpoint)
