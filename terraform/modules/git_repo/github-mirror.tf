locals {
  gitlab_project_full_path = "${var.gitlab_parent_group_path}/${var.gitlab_project_name}"
  github_project_name      = replace(trimprefix(local.gitlab_project_full_path, "reifnir-public-projects/"), "/", "-")
}

resource "github_repository" "mirror" {
  name        = local.github_project_name
  description = var.project_description

  visibility = "public"
}

# GitHub's published SSH host keys, from https://api.github.com/meta
data "github_ssh_keys" "meta" {}

resource "github_repository_deploy_key" "gitlab_mirror" {
  repository = github_repository.mirror.name
  title      = "GitLab push mirror"
  key        = data.gitlab_project_mirror_public_key.github.public_key
  read_only  = false
}

resource "gitlab_project_push_mirror" "github" {
  project     = gitlab_project.this.id
  url         = "ssh://${replace(github_repository.mirror.ssh_clone_url, ":", "/")}"
  auth_method = "ssh_public_key"
  enabled     = true

  # Bare-format keys use the hostname from the mirror URL
  host_keys = data.github_ssh_keys.meta.keys
}

# GitLab generates the mirror's SSH keypair server-side; the private key never
# leaves GitLab and nothing sensitive is stored in Terraform state.
data "gitlab_project_mirror_public_key" "github" {
  project_id = gitlab_project.this.id
  mirror_id  = gitlab_project_push_mirror.github.mirror_id
}
