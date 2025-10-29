# Organization Teams
resource "github_team" "devops_team" {
  name        = "devops-team"
  description = "DevOps team for infrastructure and deployment management"
  privacy     = "secret"
}

resource "github_team" "nodejs_team" {
  name        = "nodejs-team"
  description = "Node.js development team"
  privacy     = "secret"
}

# Organization Members
resource "github_membership" "ivan_savelev" {
  username = "ivan-savelev"
  role     = "member"
}

# Team Memberships
resource "github_team_membership" "ivan_savelev_devops" {
  team_id  = github_team.devops_team.id
  username = "ivan-savelev"
  role     = "member"
}
