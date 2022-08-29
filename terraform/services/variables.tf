variable "project" {}

variable "credentials" {}

# api needed to be enabled
variable "api" {
  type = list(string)

# list of apis
  default = [ 
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "appengine.googleapis.com",
    "appengineflex.googleapis.com",
    "servicenetworking.googleapis.com",
    "sqladmin.googleapis.com"
     ]
}