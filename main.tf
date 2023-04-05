locals {
  infra_config_name              = var.infra_config_name
  recipe_name                    = var.recipe_name
  recipe_version                 = var.recipe_version
  component_arn                  = "arn:aws:imagebuilder:us-east-1:${var.account_id}:component/example"
  parent_image_arn               = var.parent_image_arn
  device_name                    = var.device_name
  ebs_volume_size                = var.ebs_volume_size
  ebs_delete_on_terminate        = var.ebs_delete_on_terminate
  pipeline_name                  = var.pipeline_name
  source_region                  = var.source_region
  source_distribution_config_arn = aws_imagebuilder_distribution_configuration.example.arn
  source_image_recipe_arn        = aws_imagebuilder_image_recipe.example.arn
  infrastructure_config_name     = local.infrtruea_config_name
  distribution_config_name       = aws_imagebuilder_distribution_configuration.example.name
  distribution_configuration_arn = aws_imagebuilder_distribution_configuration.example.arn
}

resource "aws_imagebuilder_image_recipe" "example" {
  name         = local.recipe_name
  description  = "Example image recipe for EC2 Image Builder"
  parent_image = local.parent_image_arn

  block_device_mapping {
    device_name = local.device_name
    ebs {
      volume_size           = local.ebs_volume_size
      delete_on_termination = local.ebs_delete_on_terminate
    }
  }

  version = local.recipe_version


  component {
    component_arn = local.component_arn
  }
}


resource "aws_imagebuilder_distribution_configuration" "example" {
  name        = var.aws_imagebuilder_distribution_configuration_name
  description = "Example distribution configuration for EC2 Image Builder"

  distribution {
    region = var.distribution_region
    ami_distribution_configuration {
      name = var.ami_distribution_configuration_name
    }
  }

  tags = {
    Environment = "Dev"
  }
}

resource "aws_imagebuilder_infrastructure_configuration" "example" {
  name        = local.infra_config_name
  description = "Example infrastructure configuration for EC2 Image Builder"

  instance_profile_name = "example_instance_profile"
  instance_types        = ["t3.small", "t3.medium"]
  subnet_id             = "subnet-0123456789abcdef"
  security_group_ids    = ["sg-0123456789abcdef"]

  key_pair = "example_key_pair"

  logging {
    s3_logs {
      s3_bucket_name = "example_bucket"
      s3_key_prefix  = "logs/"
    }
  }
}

resource "aws_imagebuilder_image_pipeline" "example" {
  name                             = local.pipeline_name
  description                      = "Example Image Pipeline"
  image_recipe_arn                 = local.source_image_recipe_arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.example.arn
  distribution_configuration_arn   = local.distribution_configuration_arn

  schedule {
    pipeline_execution_start_condition = "EXPRESSION_MATCH_AND_DEPENDENCY_UPDATES_AVAILABLE"
    schedule_expression                = "cron(* * * * * *)"
  }
}

