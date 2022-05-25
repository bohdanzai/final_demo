terraform {
  # source = "/home/bohdan/Dev_ops/demo3_tg/modules//network"
  source = "../../../modules//network"
}


include {
  path = find_in_parent_folders()
}


