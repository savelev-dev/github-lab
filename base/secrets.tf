resource "github_actions_organization_secret" "username" {
  secret_name     = "API_USERNAME"
  visibility      = "selected"
  plaintext_value = var.username
}

resource "github_actions_organization_secret" "password" {
  secret_name     = "API_PASSWORD"
  visibility      = "selected"
  plaintext_value = var.password
}
