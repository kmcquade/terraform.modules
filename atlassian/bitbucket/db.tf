################################# DATABASE #####################################

resource "aws_db_subnet_group" "bitbucket" {
    name = "${var.prefix}-${var.name}"
    subnet_ids = ["${var.db_subnet_ids}"]

    tags {
        Name = "${var.prefix}-${var.name}-db-subnet-group"
        Created = "${var.owner}"
        Terraform = "Terraform"
    }
}

resource "aws_db_instance" "bitbucket" {
  engine                      = "postgres"
  engine_version              = "${var.db_version}"
  identifier                  = "${var.prefix}-${var.name}"
  instance_class              = "${var.db_instance}"
  name                        = "${var.db_name}"
  username                    = "${var.db_username}"
  password                    = "${var.db_password}"
  allocated_storage           = "${var.db_storage}"
  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = true


  final_snapshot_identifier   = "${var.prefix}-${var.name}-final"
  copy_tags_to_snapshot       = true
  backup_retention_period     = "${var.db_backup_retention}"
  backup_window               = "${var.db_backup_window}"
  maintenance_window          = "${var.db_maintenance_window}"
  multi_az                    = false

  vpc_security_group_ids      = ["${var.db_security_groups}", "${aws_security_group.db_bitbucket.id}"]
  db_subnet_group_name        = "${aws_db_subnet_group.bitbucket.name}"

  apply_immediately           = true

  #lifecycle {
  #  ignore_changes = ["vpc_security_group_ids"]
  #}

  tags = {
    Name      = "${var.prefix}-${var.name}"
    Created   = "${var.owner}"
    Terraform = "Terraform"
  }
}

output "bitbucket-database" {
  value = "${aws_db_instance.bitbucket.endpoint}"
}
