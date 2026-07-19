provider "gitlab" {
  token = var.gitlab_token
}

provider "github" {
  token = var.github_admin_token
}
