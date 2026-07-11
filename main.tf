terraform {
  backend "http" {
    address        = "https://k8.servehttp.com:30443/api/v1/repos/terraform-states/gipromez/state"
    lock_address   = "https://k8.servehttp.com:30443/api/v1/repos/terraform-states/gipromez/lock"
    unlock_address = "https://k8.servehttp.com:30443/api/v1/repos/terraform-states/gipromez/unlock"
  }
}
