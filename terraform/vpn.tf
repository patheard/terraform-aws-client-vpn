resource "aws_ec2_client_vpn_endpoint" "this" {
  description            = var.endpoint_name
  vpc_id                 = module.test_vpn_vpc.vpc_id
  server_certificate_arn = aws_acm_certificate.this.arn
  client_cidr_block      = var.endpoint_cidr_block
  self_service_portal    = "enabled"
  split_tunnel           = true
  transport_protocol     = "udp"
  dns_servers            = [cidrhost(module.test_vpn_vpc.cidr_block, 2)]
  security_group_ids     = [aws_security_group.this.id]
  session_timeout_hours  = 8

  authentication_options {
    type                           = "federated-authentication"
    saml_provider_arn              = aws_iam_saml_provider.aws-client-vpn.arn
    self_service_saml_provider_arn = aws_iam_saml_provider.aws-client-vpn-self-service.arn
  }

  connection_log_options {
    enabled               = true
    cloudwatch_log_group  = aws_cloudwatch_log_group.this.name
    cloudwatch_log_stream = aws_cloudwatch_log_stream.this.name
  }

  client_login_banner_options {
    enabled     = true
    banner_text = "This is a private network. Take care when connecting."
  }
}

data "aws_subnet" "private" {
  for_each = toset(module.test_vpn_vpc.private_subnet_ids)
  id       = each.key
}

locals {
  availability_zone_subnet_ids = {
    for s in data.aws_subnet.private : s.availability_zone => s.id...
  }
  availability_zone_subnet_cidr_blocks = {
    for s in data.aws_subnet.private : s.availability_zone => s.cidr_block...
  }  
}

resource "aws_ec2_client_vpn_network_association" "this_private_subnets" {
  for_each               = toset(local.availability_zone_subnet_ids[var.availability_zone])
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  subnet_id              = each.value
}

resource "aws_ec2_client_vpn_authorization_rule" "this_internal_dns" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  target_network_cidr    = "${cidrhost(module.test_vpn_vpc.cidr_block, 2)}/32"
  authorize_all_groups   = true
  description            = "Authorization for ${var.endpoint_name} to DNS"
}

resource "aws_ec2_client_vpn_authorization_rule" "this_private_subnets" {
  for_each               = toset(local.availability_zone_subnet_cidr_blocks[var.availability_zone])
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  target_network_cidr    = each.value
  access_group_id        = var.access_group_id
  description            = "Rule name: ${each.value}"
}

resource "aws_security_group" "this" {
  name        = "client-vpn-endpoint-${var.endpoint_name}"
  description = "Egress All. Used for other groups where VPN access is required."
  vpc_id      = module.test_vpn_vpc.vpc_id
}

resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}

#
# Connection logging
#
resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/client-vpn-endpoint/${var.endpoint_name}"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_stream" "this" {
  log_group_name = aws_cloudwatch_log_group.this.name
  name           = "connection-log"
}
