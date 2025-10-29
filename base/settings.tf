resource "github_organization_settings" "org_settings" {
  billing_email = local.billing_email
  company       = local.org_name
  description   = local.org_description

  default_repository_permission = "read"

  members_can_create_repositories          = false
  members_can_create_public_repositories   = false
  members_can_create_private_repositories  = false
  members_can_create_internal_repositories = false

  members_can_create_pages         = false
  members_can_create_public_pages  = false
  members_can_create_private_pages = false

  members_can_fork_private_repositories = false
  web_commit_signoff_required           = false

  dependabot_alerts_enabled_for_new_repositories           = true
  dependabot_security_updates_enabled_for_new_repositories = true
  dependency_graph_enabled_for_new_repositories            = true
  advanced_security_enabled_for_new_repositories           = false
}