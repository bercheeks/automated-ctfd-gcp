variable "project" {}

variable "credentials" {}

variable "location" {
  default = "northamerica-northeast1"
}

# api needed to be enabled
variable "api" {
  type = list(string)

# list of apis
  default = [ 
    "appengine.googleapis.com",
    "appengineflex.googleapis.com"
     ]
}