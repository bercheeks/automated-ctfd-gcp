# CTFd Automated Deployment for Google Cloud

This repo is meant for anybody trying to host a CTF on a cloud platform. This repo makes use
Google Cloud Platform with Terraform to eliminate any manual configuration needed for deploying
CTFd onto the Cloud.

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

```python
import foobar

# returns 'words'
foobar.pluralize('word')

# returns 'geese'
foobar.pluralize('goose')

# returns 'phenomenon'
foobar.singularize('phenomena')
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)
This repo is meant for complete project initialization for people trying to bootstrap CTFd infrastructure on Google Cloud (GCP).

Make sure to have a service account key within the project directory so "credentials" variable can call it. If you are using Basic roles for the service account, grant "Owner" as App Engine relies on the Owner role to create GAE applications.
	- Also add Storage Object Viewer Perm
	- + Flexible Env App Engine Perm

Make sure to use the init terra module first, as it purely initializes the services used in this project

Terraform Start:
	1. terraform init
	2. terraform apply

Note: App Engine applications cannot be deleted once they're created; you have to delete the entire project to delete the application. Terraform will report the application has been successfully deleted; this is a limitation of Terraform, and will go away in the future. Terraform is not able to delete App Engine applications.