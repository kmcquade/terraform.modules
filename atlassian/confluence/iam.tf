################################# IAM PROFILE ##################################
resource "aws_iam_instance_profile" "confluence" {
    name = "${var.prefix}-${var.name}"
    roles = ["${aws_iam_role.confluence.name}"]
}

resource "aws_iam_role" "confluence" {
    name = "${var.prefix}-${var.name}"
    path = "/"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}
