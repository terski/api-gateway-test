variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"  # Change to your preferred region
}

variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
  default     = "wiscode-dev"  # Default profile if none specified
}

variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
  default     = "provider-notification-api"
}

variable "stage_name" {
  description = "Stage name for the API deployment"
  type        = string
  default     = "test"
}
