variable "ami_id" {
  type        = string
  description = "AMI ID for EC2 instance (e.g., ami-01f79b1e4a5c64257)"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type (e.g., t3.micro)"
  default     = "t3.micro"

  validation {
    condition     = can(regex("^[a-z0-9]+\\.[a-z0-9]+$", var.instance_type))
    error_message = "Invalid instance type format."
  }
}

variable "aws_region" {
  type        = string
  description = "AWS region for resources"
  default     = "eu-central-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d{1}$", var.aws_region))
    error_message = "Invalid AWS region format."
  }
}