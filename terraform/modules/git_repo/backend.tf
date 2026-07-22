terraform {
  required_providers {
    github = { source = "integrations/github" }
    gitlab = { source = "gitlabhq/gitlab" }
  }
  # Need 1.11+ for ephemeral variables
  required_version = ">= 1.11"
}
