
output "ecr_repository_url" {
  value = aws_ecr_repository.ecr_repository.repository_url
}
output "image_tag"{
    value = var.image_tag
}