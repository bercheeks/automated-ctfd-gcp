This repo is meant for complete project initialization for people trying to bootstrap CTFd infrastructure on Google Cloud (GCP).

Make sure to have a service account key within the project directory so "credentials" variable can call it. If you are using Basic roles for the service account, grant "Owner" as App Engine relies on the Owner role to create GAE applications.

Make sure to use the init terra module first, as it purely initializes the services used in this project

Terraform Start:
	1. terraform init
	2. terraform apply

Note: App Engine applications cannot be deleted once they're created; you have to delete the entire project to delete the application. Terraform will report the application has been successfully deleted; this is a limitation of Terraform, and will go away in the future. Terraform is not able to delete App Engine applications.