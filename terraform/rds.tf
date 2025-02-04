resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [for subnet in module.vpc.private_subnets : subnet.id]
}

resource "aws_db_instance" "mariadb" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mariadb"
  engine_version       = "10.6.10"
  instance_class       = "db.t2.micro"
  parameter_group_name = "mariadb"
  username             = var.db_username
  password             = var.db_password
  skip_final_snapshot  = true

  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
}

resource "aws_db_instance" "mariadb_replica" {
  replicate_source_db        = aws_db_instance.mariadb.identifier
  replica_mode               = "mounted"
  auto_minor_version_upgrade = false
  instance_class             = "db.t2.micro"
}
