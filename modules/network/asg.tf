data "aws_ami" "aws_optimized_ecs" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn-ami*amazon-ecs-optimized"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["591542846629"] # AWS
}

# resource "aws_launch_configuration" "webserver-launch-config" {
#   name_prefix          = "webserver-launch-config"
#   image_id             = data.aws_ami.aws_optimized_ecs.id
#   instance_type        = var.instance_type
#   security_groups      = [aws_security_group.mainSG.id]
#   iam_instance_profile = aws_iam_instance_profile.ecs.name
#   lifecycle {
#     create_before_destroy = true
#   }
#   user_data = <<-EOF
# 		#!/bin/bash
#     echo 'ECS_CLUSTER=demo3-dev-cluster' >> /etc/ecs/ecs.config
# 	EOF
# }

resource "aws_launch_template" "webserver_launch_tpl" {
  name_prefix = "webserver-launch-template"
  image_id        = data.aws_ami.aws_optimized_ecs.id
  instance_type   = var.instance_type
  vpc_security_group_ids = [aws_security_group.mainSG.id]
  # iam_instance_profile = aws_iam_instance_profile.ecs.name
  iam_instance_profile {
    name = "${aws_iam_instance_profile.ecs.name}"
  }
  lifecycle {
    create_before_destroy = true
  }
  user_data = filebase64("${path.module}/user_data.sh")
}

resource "aws_autoscaling_group" "Demo-ASG-tf" {
  name                 = "${var.app_name}-${var.environment}-ASG"
  desired_capacity     = 2
  max_size             = 3
  min_size             = 2
  force_delete         = true
  target_group_arns    = ["${aws_alb_target_group.app.arn}"]
  health_check_type    = "EC2"
  # launch_configuration = aws_launch_configuration.webserver-launch-config.name
  launch_template {
    id = aws_launch_template.webserver_launch_tpl.id
    version = "1"
  }
   vpc_zone_identifier  = [for subnet in aws_subnet.privatesubnet : subnet.id]
  # vpc_zone_identifier  = [for subnet in aws_subnet.publicsubnet : subnet.id]

  tag {
    key                 = "Name"
    value               = "${var.app_name}-${var.environment}-ASG"
    propagate_at_launch = true
  }
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  metrics_granularity = "1Minute"
}

#========================Scale_UP===========================
resource "aws_autoscaling_policy" "ec2-scale-up" {
  name                   = "ec2-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.Demo-ASG-tf.name
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu-high" {
  alarm_name          = "cpu-high-util"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period            = "60"
  statistic         = "Average"
  threshold         = "40"
  alarm_description = "This metric monitors ec2 memory for high utilization on agent hosts"
  alarm_actions = [
    "${aws_autoscaling_policy.ec2-scale-up.arn}"
  ]
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.Demo-ASG-tf.name}"
  }
  actions_enabled = true
}

#========================Scale_DOWN===========================
resource "aws_autoscaling_policy" "ec2-scale-down" {
  name                   = "ec2-scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.Demo-ASG-tf.name
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu-low" {
  alarm_name          = "cpu-low-util"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "39"
  alarm_description   = "This metric monitors ec2 memory for low utilization on agent hosts"
  alarm_actions = [
    "${aws_autoscaling_policy.ec2-scale-down.arn}"
  ]
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.Demo-ASG-tf.name}"
  }
  actions_enabled = true
}
