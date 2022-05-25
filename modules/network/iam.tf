resource "aws_iam_role" "ecs_instances" {
    name = "ecs_instances_profile-${var.environment}-ecs"
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

resource "aws_iam_policy_attachment" "ecs_role_policy" {
    name = "ecs_instances_policy-${var.environment}-ecs"
    roles = ["${aws_iam_role.ecs_instances.name}"]
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs" {
    name = "ecs_role-${var.environment}-ecs"
    role = aws_iam_role.ecs_instances.name 
}

# IAM Role and policy for ECS services
resource "aws_iam_role" "ecs_services" {
    name = "ecs_services_role-${var.environment}-ecs"
    assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "ecs_services_policy" {
    name = "ecs_services_policy-${var.environment}-dev"
    roles = ["${aws_iam_role.ecs_services.name}"]
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}