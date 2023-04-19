# CTFd Automated Deployment for Google Cloud

This repository is intended for anyone looking to host a CTF on a cloud platform. The repository utilizes Google Cloud Platform with Terraform to automate the deployment of CTFd to the cloud, eliminating the need for manual configuration. I personally used this automated repository to host the 2023 ISSessions CTF, which was hosted by Sheridan College students.


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

When setting up a project directory, ensure that a service account key is present so that the "credentials" variable can access it. If Basic roles are being used for the service account, it is important to grant the "Owner" role as App Engine depends on it for creating GAE applications. In addition, it is recommended to add the Storage Object Viewer permission and the Flexible Environment App Engine permission. By following these steps, you can ensure that your project directory is properly configured and ready to use.

Terraform Start:
	1. terraform init
	
	2. terraform apply

Note: App Engine applications cannot be deleted once they're created; you have to delete the entire project to delete the application. Terraform will report the application has been successfully deleted; this is a limitation of Terraform, and will go away in the future. Terraform is not able to delete App Engine applications.


## Credits

The assistance of previous Infrastructure Developers who were part of ISSessions has been crucial in making this repository possible, along with the ongoing efforts of the current challenge developers who are creating the most exciting CTF challenges to date.