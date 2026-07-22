# Import blocks for the pre-existing repos. Driven by the same local.git_repos
# map that drives the module, so the imports stay in sync automatically.
#
# Remove this file once the initial import/apply has been completed.

locals {
  # GitHub deploy-key numeric IDs, keyed by the git_repos key. Fetched from the
  # GitHub API (GET /repos/reifnir/<name>/keys) since they're server-assigned.
  github_deploy_key_ids = {
    "reifnir-public-projects/iac/aws-automation-identity"                = 156893049
    "reifnir-public-projects/iac/dns"                                    = 156892729
    "reifnir-public-projects/iac/gitlab-runner-local"                    = 157751802
    "reifnir-public-projects/iac/job-templates"                          = 157751686
    "reifnir-public-projects/iac/source-control-management"              = 157751937
    "reifnir-public-projects/iac/terraform-state"                        = 157751733
    "reifnir-public-projects/iac/aws-organization/aws-access-management" = 157972372
    "reifnir-public-projects/iac/aws-organization/org-build-out"         = 157978011
  }

  # GitLab push-mirror IDs as "<project_id>:<mirror_id>", keyed by the
  # git_repos key. These identify the ssh:// (ssh_public_key auth) mirror.
  gitlab_push_mirror_ids = {
    "reifnir-public-projects/iac/aws-automation-identity"                = "83438997:4076329"
    "reifnir-public-projects/iac/dns"                                    = "84236788:4076322"
    "reifnir-public-projects/iac/gitlab-runner-local"                    = "84615230:4081053"
    "reifnir-public-projects/iac/job-templates"                          = "83231800:4076325"
    "reifnir-public-projects/iac/source-control-management"              = "84292806:4076305"
    "reifnir-public-projects/iac/terraform-state"                        = "83231681:4076330"
    "reifnir-public-projects/iac/aws-organization/aws-access-management" = "84615279:4081786"
    "reifnir-public-projects/iac/aws-organization/org-build-out"         = "84291477:4081824"
  }
}

# GitLab projects import by their full path, which is exactly the map key.
import {
  for_each = local.git_repos
  to       = module.git_repo[each.key].gitlab_project.this
  id       = each.key
}

# GitHub mirror repos import by repository name, which mirrors the module's
# local.github_project_name derivation.
import {
  for_each = local.git_repos
  to       = module.git_repo[each.key].github_repository.mirror
  id       = replace(trimprefix(each.key, "reifnir-public-projects/"), "/", "-")
}

# GitLab push mirrors import as "<project_id>:<mirror_id>".
import {
  for_each = local.gitlab_push_mirror_ids
  to       = module.git_repo[each.key].gitlab_project_push_mirror.github
  id       = each.value
}

# GitHub deploy keys import as "<repository>:<key_id>".
import {
  for_each = local.github_deploy_key_ids
  to       = module.git_repo[each.key].github_repository_deploy_key.gitlab_mirror
  id       = "${replace(trimprefix(each.key, "reifnir-public-projects/"), "/", "-")}:${each.value}"
}
