module "postgresql_cluster" {
  source = "github.com/cds-snc/terraform-modules//rds?ref=v7.3.2"
  name   = "test-rds-postgres"

  database_name  = "test_postgres"
  engine         = "aurora-postgresql"
  engine_version = "15.2"
  instances      = 2
  instance_class = "db.t3.medium"
  username       = var.postgresql_username
  password       = var.postgresql_password

  security_group_ids = [aws_security_group.postgresql_cluster.id]

  prevent_cluster_deletion = false
  skip_final_snapshot      = true

  backup_retention_period      = 1
  preferred_backup_window      = "01:00-03:00"
  preferred_maintenance_window = "sun:06:00-sun:07:00" # timezone is UTC

  vpc_id     = module.test_vpn_vpc.vpc_id
  subnet_ids = module.test_vpn_vpc.private_subnet_ids

  billing_tag_value = "platform-core"
}

resource "aws_security_group" "postgresql_cluster" {
  name        = "test_database"
  description = "Test database security group"
  vpc_id      = module.test_vpn_vpc.vpc_id
}

resource "aws_security_group_rule" "postgresql_cluster_ingress_vpn" {
  description              = "Ingress from VPN task to database"
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.postgresql_cluster.id
  source_security_group_id = aws_security_group.this.id
}