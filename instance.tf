# Adding http & ssh inbound rule to security group
resource "aws_security_group" "lous_autoglass_sg" {
  name          = "lous_autoglass_sg"
  description   = "security group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_iam_instance_profile" "instance_profile" {
  name    = "lous_autoglass_iam"
  role    = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name                = "lous_autoglass_role"
  path                = "/"
  managed_policy_arns = [aws_iam_policy.allow_secrets_read.arn]
  assume_role_policy  = <<EOF
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

resource "aws_iam_policy" "allow_secrets_read" {
  name        = "lous_autoglass_secrets"

  policy      = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action   = ["secretsmanager:GetSecretValue"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_instance" "lous_autoglass" {
  count                  = 1
  ami                    = "ami-0e4d9ed95865f3b40"
  instance_type          = "t2.micro"
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  user_data              = filebase64("${path.module}/files/userdata.tpl")
  security_groups        = [ "${aws_security_group.lous_autoglass_sg.name}" ]
  key_name               = "deploy" 

}
