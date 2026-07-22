data "gitlab_group" "parent" {
  full_path = var.gitlab_parent_group_path
}

resource "gitlab_project" "this" {
  name         = var.gitlab_project_name
  description  = var.project_description
  namespace_id = data.gitlab_group.parent.id

  # Not managed through IaC
  avatar_url = null

  allow_merge_on_skipped_pipeline           = false
  allow_pipeline_trigger_approve_deployment = false
  analytics_access_level                    = "disabled"
  archived                                  = false
  archive_on_destroy                        = true
  auto_cancel_pending_pipelines             = "enabled"
  auto_devops_deploy_strategy               = "continuous"
  auto_devops_enabled                       = false
  auto_duo_code_review_enabled              = false
  autoclose_referenced_issues               = false
  build_git_strategy                        = "fetch"
  build_timeout                             = 3600
  builds_access_level                       = "private"
  ci_config_path                            = null # Might want to put this in .gitlab directory
  ci_default_git_depth                      = 20
  ci_delete_pipelines_in_seconds            = 0
  ci_display_pipeline_variables             = false
  ci_forward_deployment_enabled             = true
  ci_forward_deployment_rollback_allowed    = true
  ci_id_token_sub_claim_components = [
    "project_path",
    "ref_type",
    "ref",
  ]
  ci_pipeline_variables_minimum_override_role      = "developer"
  ci_push_repository_for_job_token_allowed         = false
  ci_restrict_pipeline_cancellation_role           = null
  ci_separated_caches                              = true
  container_registry_access_level                  = "disabled"
  default_branch                                   = "main"
  emails_enabled                                   = true
  environments_access_level                        = "private"
  external_authorization_classification_label      = null
  feature_flags_access_level                       = "private"
  forking_access_level                             = "enabled"
  group_runners_enabled                            = true
  infrastructure_access_level                      = "private"
  issues_access_level                              = "enabled"
  issues_template                                  = null
  keep_latest_artifact                             = true
  lfs_enabled                                      = false
  max_artifacts_size                               = 0
  merge_commit_template                            = null
  merge_method                                     = "merge"
  merge_pipelines_enabled                          = false # Prefer this, but it's a Premium+ feature
  merge_request_title_regex                        = null
  merge_request_title_regex_description            = null
  merge_requests_access_level                      = "private"
  merge_requests_template                          = null
  merge_trains_enabled                             = false
  merge_trains_skip_train_allowed                  = false
  model_experiments_access_level                   = "enabled"
  model_registry_access_level                      = "private"
  monitor_access_level                             = "private"
  only_allow_merge_if_all_discussions_are_resolved = false
  only_allow_merge_if_pipeline_succeeds            = false
  package_registry_access_level                    = "disabled"
  packages_enabled                                 = false
  pages_access_level                               = "private"
  pre_receive_secret_detection_enabled             = false
  prevent_merge_without_jira_issue                 = false
  printing_merge_request_link_enabled              = true
  protect_merge_request_pipelines                  = true
  public_jobs                                      = true
  releases_access_level                            = "private"
  remove_source_branch_after_merge                 = true
  repository_access_level                          = "enabled"
  request_access_enabled                           = true
  requirements_access_level                        = "private"
  resolve_outdated_diff_discussions                = false
  resource_group_default_process_mode              = "oldest_first"
  security_and_compliance_access_level             = "private"
  shared_runners_enabled                           = true
  snippets_access_level                            = "private"
  squash_option                                    = "never"
  topics                                           = []
  visibility_level                                 = "public"
  wiki_access_level                                = "disabled"

  lifecycle {
    prevent_destroy = true
  }
}
