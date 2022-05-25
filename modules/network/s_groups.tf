#===================================MAIN_SG==============================================
resource "aws_security_group" "mainSG" {
  name   = "Security group for all components"
  vpc_id = aws_vpc.dev_vpc.id
  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = var.protocol
      cidr_blocks = var.allowed_cidr
    }
  }
  dynamic "egress" {
    for_each = var.allowed_ports
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = var.protocol
      cidr_blocks = var.allowed_cidr
    }
  }

  tags = {
    Name = "${var.app_name}-${var.environment}-main-SG"
  }
}

#===============================ALB_SG===================================================

resource "aws_security_group" "albSG" {

  name        = "${var.app_name}-${var.environment}-ALB-SG"
  description = "app load balancer security group"
  vpc_id      = aws_vpc.dev_vpc.id

  dynamic "ingress" {
    for_each = var.alb_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = var.protocol
      cidr_blocks = var.allowed_cidr
    }
  }
  dynamic "egress" {
    for_each = var.alb_ports
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = var.protocol
      cidr_blocks = var.allowed_cidr
    }    
  }
}