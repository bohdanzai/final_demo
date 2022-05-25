resource "aws_alb" "main" {
  name            = "${var.app_name}-${var.environment}-lb"
  subnets         = [for subnet in aws_subnet.publicsubnet : subnet.id]
  security_groups = [aws_security_group.albSG.id]
}

resource "aws_alb_target_group" "app" {
  name        = "${var.app_name}-${var.environment}-tg"
  port        = var.host_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.dev_vpc.id
  target_type = "instance"

  health_check {
    healthy_threshold   = "2"
    interval            = "20"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.main.id
  port              = var.app_port
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.app.id
    type             = "forward"
  }
}