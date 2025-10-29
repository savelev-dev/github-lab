# Security Team
resource "github_team" "security_team" {
  name        = "security-team"
  description = "Security team for organization security management"
  privacy     = "closed"
}

# Security Manager Organization Membership
resource "github_membership" "security_manager" {
  username = "ivan-savelev"
  role     = "member"
}

# Security Manager Team Membership
resource "github_team_membership" "security_manager_team" {
  team_id  = github_team.security_team.id
  username = "ivan-savelev"
  role     = "maintainer"
}