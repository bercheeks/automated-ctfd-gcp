# CTFd Automated Deployment for Google Cloud

This repo is meant for anybody trying to host a CTF on a cloud platform. This repo makes use
Google Cloud Platform with Terraform to eliminate any manual configuration needed for deploying
CTFd onto the Cloud. I personally used this automated repo to host the 2023 ISSessions CTF hosted 
by Sheridan College Students.


## Installation

This repo assumes you are using linux!**

Software Needed:

This repo
```bash
git clone https://github.com/bercheeks/terra-gcp-template.git
```

[Google-Cloud-CLI](https://cloud.google.com/sdk/docs/install)

[Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

## Usage

Head over to the Terraform directory to initialize and configure all Google Cloud required services.


## Credits

This repo would not be possible without the help of all the previous Infrastructure Developers
part of ISSessions along with the current challenge devs who are building out the coolest CTF challenges ever!

Kudos to Samuel C. (developer part of DownUnderCTF) for helping me out with creating the configuration needed for CTFd's App Enginge.
Check out his repo for [App-Engine](https://github.com/DownUnderCTF/ctfd-appengine) configuration.






Make sure to have a service account key within the project directory so "credentials" variable can call it. If you are using Basic roles for the service account, grant "Owner" as App Engine relies on the Owner role to create GAE applications.
	- Also add Storage Object Viewer Perm
	- + Flexible Env App Engine Perm

Make sure to use the init terra module first, as it purely initializes the services used in this project

Terraform Start:
	1. terraform init
	2. terraform apply

Note: App Engine applications cannot be deleted once they're created; you have to delete the entire project to delete the application. Terraform will report the application has been successfully deleted; this is a limitation of Terraform, and will go away in the future. Terraform is not able to delete App Engine applications.