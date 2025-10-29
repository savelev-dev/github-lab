resource "github_repository" "tf_github_lab_base_repository" {
  name                 = "tf-lab-devops"
  description          = "${local.org_name}, repository for DevOps team"
  vulnerability_alerts = true
  visibility           = "private"
  auto_init            = true
}