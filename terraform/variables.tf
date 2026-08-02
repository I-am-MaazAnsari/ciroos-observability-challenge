variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}
variable "environment" {
  description = "Deployment Environment"
  type        = string
  default     = "demo"
}
variable "project_name" {
  description = "Project name"
  type        = string
  default     = "ciroos-observability"
}