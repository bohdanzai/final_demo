

resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}-${var.environment}-cluster"
}


resource "aws_ecs_task_definition" "app" {
  family                   = "${var.app_name}-${var.environment}-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = var.task_cpu
  memory                   = var.task_ram
  # container_definitions = "${file("./modules/ecs/task_def.json.tpl")}"
  container_definitions = jsonencode([{
    name        = "${var.app_name}-${var.environment}-container"
    # image       = "${var.ecr_repository_url}/${var.app_name}-${var.environment}:${var.image_tag}"
    image       = "${var.ecr_repository_url}:${var.image_tag}"
    essential   = true
    cpu         = var.container_cpu
    memory      = var.container_ram

    portMappings = [
      {
        containerPort = var.container_port
        hostPort      = var.host_port
      }
    ]
  }])

}

resource "aws_ecs_service" "main" {
  name            = "${var.app_name}-${var.environment}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.service_desired_count
  launch_type     = "EC2"
}