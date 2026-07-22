variable "gitlab_parent_group_path" {
  description = "The full path of the Gitlab parent group under gitlab.com, e.g. 'reifnir-public-projects/iac'"
  type        = string
  nullable    = false
}

variable "gitlab_project_name" {
  description = "The name and URI path for the project being managed."
  type        = string
  nullable    = false
}

variable "project_description" {
  description = "Both the name and path of the Gitlab project, e.g. 'my-project'"
  type        = string
  nullable    = false
}
