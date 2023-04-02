resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = "dimpul"
  password             = "dimpul123"
  parameter_group_name = var.parameter_group_name
  skip_final_snapshot  = true
  tags       = merge(
    local.common_tags,
    { name = "${var.env}-rds_cluster" }
  )
}