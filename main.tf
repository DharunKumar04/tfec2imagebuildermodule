locals {
  infra_config_name              = "example_infra_config"
  recipe_name                    = "example_recipe"
  recipe_version                 = "1.0.0"
  component_arn                  = "arn:aws:imagebuilder:us-east-1:${var.account_id}:component/example"
  parent_image_arn               = "arn:aws:imagebuilder:us-east-1:aws:image/amazon-linux-2-x86/x.x.x"
  device_name                    = "/dev/xvda"
  ebs_volume_size                = 10
  ebs_delete_on_terminate        = true
  pipeline_name                  = "example_pipeline"
  source_region                  = "us-east-1"
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
  name        = "example_distribution_config"
  description = "Example distribution configuration for EC2 Image Builder"

  distribution {
    region = "us-east-1"
    ami_distribution_configuration {
      name = "example_ami_distribution"
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

