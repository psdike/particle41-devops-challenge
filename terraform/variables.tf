variable "aws_region" {
  default = "us-east-1"
}

variable "project_name" {
  default = "simpletimeservice"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "container_image" {
  description = "Docker image to deploy"
  default     = "your-dockerhub-username/simpletimeservice:latest"
}
