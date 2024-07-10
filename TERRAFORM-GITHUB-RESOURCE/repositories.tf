resource "github_repository" "example" {
  name        = "first-repo-from-terraform"
  description = "First Repo created from GitHub"
  visibility  = "public"
  auto_init   = true
}

resource "github_repository" "example2" {
  name        = "second-repo-from-terraform"
  description = "Second Repo created from GitHub"
  visibility  = "public"
  auto_init   = true
}

output "terraform-first-repo-url" {
  value = github_repository.example.html_url
}
