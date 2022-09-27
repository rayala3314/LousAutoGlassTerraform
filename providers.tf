provider "aws" {
  region  = var.region
  # version = "~> 3.0"
  profile           = "lousautoglass"
  required_version  = "~> 3.0"
}
