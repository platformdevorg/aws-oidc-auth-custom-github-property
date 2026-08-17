variable "account_id" {
  description = "AWS account ID that owns the GitHub OIDC provider."
  type        = string
  default     = "99999999"
}

variable "github_org_id" {
  description = "GitHub organization ID."
  type        = string
  default     = "11111111"
}

variable "github_team_id" {
  description = "GitHub team ID used in the repository custom property."
  type        = string
  default     = "999ABC"
}

variable "project_name" {
  description = "Name used to identify project resources."
  type        = string
  default     = "aws-auth-sample"
}

variable "github_org" {
  description = "GitHub organization name."
  type        = string
  default     = "platformdevorg"
}
