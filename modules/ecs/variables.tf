variable "aws_region" {}

variable "remote_state_bucket" {}

variable "environment" {}

variable "app_name" {}

variable "ecs_task_role_name" {
  default = "TaskRole"
}

variable "ecs_task_execution_role_name" {
  default = "TaskExRole"
}

variable "task_cpu" {
  default = "1 vCPU"
}

variable "task_ram" {
  default = "0.5GB"
}

variable "container_cpu" {
  type = number
  default = 256
}

variable "container_ram" {
  type = number
  default = 256
}

variable "service_desired_count" {
  default = 2
}

variable "container_port" {
  type = number
  default = 80
}

variable "host_port" {
  type = number
  default = 80
}

variable "ecr_repository_url" {
  type = string
  # default = "873432059572.dkr.ecr.eu-central-1.amazonaws.com"
}

variable "image_tag" {
  type = string
  default = "0.0.1"
}