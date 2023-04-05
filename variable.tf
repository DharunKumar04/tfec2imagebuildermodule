variable "account_id" {
  type    = number
  default = 123456789
}

variable "infra_config_name" {
  type = string
  description = "Specify the name of the infrastructure configuration for EC2 Image Builder"
  default = "example_infra_config"
}

variable "recipe_name" {
  type = string
  description = "name of the image recipe that is used to build the image"
  default = "example_recipe"
}

variable "recipe_version" {
  type = string
  description = "version number of the image recipe to create"
  default = "1.0.0"
}

variable "parent_image_arn" {
  type = string
  description = "ARN (Amazon Resource Name) of the parent image to be used as a base for the new image"
  default = "arn:aws:imagebuilder:us-east-1:aws:image/amazon-linux-2-x86/x.x.x"
}

variable "device_name" {
  type = string
  description = "create an EBS volume and attach it to the instance that is launched from the AMI created by the image recipe"
  default = "/dev/xvda"
}

variable "ebs_volume_size" {
  type = number
  description = "the size of the EBS volume in gigabytes that will be attached to the instance during the image build process"
  default = 10
}

variable "ebs_delete_on_terminate" {
  type = bool
  description = "boolean value that specifies whether the EBS volume should be deleted when the instance it is attached to is terminated"
  default = true
}

variable "pipeline_name" {
  type = string
  description = "Specify the Pipeline name for the image"
  default = "example_pipeline"
}

variable "source_region" {
  type = string
  description = "Specify the Source Region where the image need to be build"
  default = "us-east-1"
}

variable "aws_imagebuilder_distribution_configuration_name" {
  type = string
  description = "Specify the name of the aws imagebuilder distribution configuration"
  default = "example_distribution_config"
}

variable "distribution_region" {
  type = string
  description = "Specify the region where the image need to be distributed"
  default = "us-east-1"
}

variable "ami_distribution_configuration_name" {
  type = string
  description = "Specify the name of the distribution configuration"
  default = "example_ami_distribution"
}