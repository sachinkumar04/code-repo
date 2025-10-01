# variables.tf

variable "instance_type" {
  description = "The type of instance to launch"
  type        = string
  default     = "t2.micro" # Default value can be overridden in terraform.tfvars
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}

