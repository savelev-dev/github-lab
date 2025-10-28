variable "gh_token" {
  description = "GitHub personal access token for authentication"
  type        = string
  sensitive   = true
}

variable "username" {
  description = "Dummy API username"
  type        = string
  sensitive   = true
}

variable "password" {
  description = "Dummy API password"
  type        = string
  sensitive   = true
}