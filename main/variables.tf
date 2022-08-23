variable "project" {}

variable "credentials" {}

variable "region" {
  default = "northamerica-northeast2"
}

variable "zone" {
  default = "northamerica-northeast2-a"
}

# api needed to be enabled
variable "api" {
  type = list(string)

# list of apis
  default = [ 
    "compute.googleapis.com"
     ]
}