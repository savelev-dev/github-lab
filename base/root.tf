terraform {

}

provider "github" {
  owner = "terraform-lab-savelev"
  token = var.gh_token
}
