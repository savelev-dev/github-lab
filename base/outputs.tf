output "organization_id" {
  description = "The ID of the GitHub organization"
  value       = local.org_name
}

output "teams_ids" {
  description = "Set of team IDs in the organization"
  value = toset([
    github_team.devops_team.id,
    github_team.nodejs_team.id,
    github_team.security_team.id
  ])
}

output "security_manager_team_slug" {
  description = "The slug/name of the security manager team"
  value       = github_team.security_team.slug
}

output "secret_names" {
  description = "Set of organization secret names"
  value = toset([
    github_actions_organization_secret.username.secret_name,
    github_actions_organization_secret.password.secret_name
  ])
}

output "base_repository_name" {
  description = "The name of the base repository"
  value       = github_repository.tf_github_lab_base_repository.name
}