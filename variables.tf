variable "region" {
  type = string
}

variable "acm_region" {
  default   = "us-east-1"
  type      = string
}

# Route 53 Variables
variable "domain_name" {
  default       = "lousautoglass.com"
  description   = "domain name"
  type          = string
}

variable "record_name" {
  default       = "www"
  description   = "sub domain"
  type          = string
}