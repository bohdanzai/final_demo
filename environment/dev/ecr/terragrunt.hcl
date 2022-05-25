terraform {
  # source = "/home/bohdan/Dev_ops/demo3_tg/modules//ecr"
  source = "../../../modules//ecr"
}

include "root"{
  path = find_in_parent_folders()
}

inputs = {
  working_dir = format("%s/../../../app", get_terragrunt_dir())
}
