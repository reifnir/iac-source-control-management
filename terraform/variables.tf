variable "gitlab_token" {
  description = "GitLab personal access token with API scope"
  type        = string
  sensitive   = true
  ephemeral   = true
}

variable "github_admin_token" {
  description = "GitHub personal access token with permission to manage repos under me"
  type        = string
  sensitive   = true
  ephemeral   = true
}
