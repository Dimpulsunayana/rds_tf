resource "aws_security_group" "rds" {
  name        = "${var.env}-rds_segrp"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.main_vpc

  ingress {
    description      = "mysql"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = var.allow_cidr
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags       = merge(
    local.common_tags,
    { Name = "${var.env}-rds_segrp" }
  )
}

resource "aws_db_subnet_group" "rds" {
  name       = "${var.env}-rds_subnetgrp"
  subnet_ids = var.subnet_ids

  tags       = merge(
    local.common_tags,
    { name = "${var.env}-rds_subnetgrp" }
  )
}

resource "aws_rds_cluster" "rds" {
  cluster_identifier      = "${var.env}-rds"
  engine                  = var.engine
  engine_version          = var.engine_version
#  database_name           = "mysql"
  master_username         = "dimpul"
  master_password         = "dimpul123"
  //storage_type              = "io1"
#  allocated_storage         = 20
#  iops                      = 1000
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  storage_encrypted = true
  skip_final_snapshot = true
  tags       = merge(
    local.common_tags,
    { name = "${var.env}-rds_cluster" }
  )
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 1
  identifier         = "aurora-cluster-rds-${count.index}"
  cluster_identifier = aws_rds_cluster.rds.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.rds.engine
  engine_version     = aws_rds_cluster.rds.engine_version

  tags       = merge(
    local.common_tags,
    { name = "${var.env}-rds_cluster" }
  )
}