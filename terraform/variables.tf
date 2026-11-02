variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "clusterName" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "vprofile-eks"
}


variable "github_principal_arn" {
  type        = string
  description = "GitHub Actions IAM principal ARN passed from GitHub Secrets"
}

######
