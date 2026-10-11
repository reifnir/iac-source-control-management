locals {
  repos = {
    "reifnir-public-projects/iac" = {
      "aws-automation-identity" = {
        "description" = "Manages the AWS identity that we'll use for automation jobs"
      }
      "dns" = {
        "description"       = "Need a place to manage DNS zones and more-stable DNS records like email, etc"
        "automation-access" = ["Reifnir-Aggregator"]
      }
      "github-fiddling" = {
        "description" = "I have a lot more experience with GitLab automation than GitHub, so I need a project to use as a sandbox for learning."
      }
      "gitlab-runner-local" = {
        "description" = "Don't want to pay for more minutes on the included runners, so making it easier to run one locally while I'm fiddling."
      }
      "job-templates" = {
        "description" = "Job templates for Gitlab initially, but GitHub later if I need to run some automation there at some point"
      }
      "source-control-management" = {
        "description" = "Need a project to manage creating and syncing repos across Gitlab and GitHub, and the tedious work of setting default properties, etc"
      }
      "terraform-state" = {
        "description" = "Need a place to store terraform state, so have to bootstrap it somewhere"
      }
    }

    "reifnir-public-projects/iac/aws-organization" = {
      "aws-access-management" = {
        "description"       = "Need a project to declaratively manage AWS IAM Identity Center users and permission set assignments"
        "automation-access" = ["*"]
      }
      "org-build-out" = {
        "description" = "Place to manage the overall deployment and progress in setting up my AWS org (with a few shortcuts for cost savings reasons)"
      }
    }
  }

  # Flatten the nested group -> project structure into a single map keyed by
  # the full project path, suitable for use with for_each.
  git_repos = merge([
    for group_path, projects in local.repos : {
      for project_name, project in projects :
      "${group_path}/${project_name}" => {
        gitlab_parent_group_path = group_path
        gitlab_project_name      = project_name
        project_description      = project.description
        # Not yet implemented in the git_repo module, so not passed in below.
        automation_access = lookup(project, "automation-access", [])
      }
    }
  ]...)
}

module "git_repo" {
  source   = "./modules/git_repo"
  for_each = local.git_repos

  gitlab_parent_group_path = each.value.gitlab_parent_group_path
  gitlab_project_name      = each.value.gitlab_project_name
  project_description      = each.value.project_description
}
