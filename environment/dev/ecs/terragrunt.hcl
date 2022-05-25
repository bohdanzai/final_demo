terraform {
  # source = "/home/bohdan/Dev_ops/demo3_tg/modules//ecs"
  source = "../../../modules//ecs"
}

include "root"{
  path = find_in_parent_folders()
}

dependency "ecr" {
    config_path = "../ecr"
    mock_outputs = {
      ecr_repository_url = "873432059572.dkr.ecr.eu-central-1.amazonaws.com"
  }
}

inputs = {
    ecr_repository_url = dependency.ecr.outputs.ecr_repository_url
  }