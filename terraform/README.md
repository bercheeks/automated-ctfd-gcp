# How-To

Every step is numbered in a chronological order. Follow each step fully to make sure everything behaves properly. 

Any Terraform directory must use the following commands to run the scripts:

```bash
terraform init
terraform apply
```

# Step 1: API Module
The 1.apis directory is a basic module which enables any necassary GCP APIs needed for deployment.

# Step 2: Pushing the CTFd image to Container Registry

Run the below command within 2.ctfd directory
```bash
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/ctfd:1.0.0 .
```

# Step 3: Backend Services Terraform Module
The 3.backend directory is terraform module used for creating a private SQL and private Redis instances.

Make sure to set proper Database username and password in the terraform variables file.
db_user = "username"
db_password = "password"

# Step 4: App Engine Module
There are two options you can take for App Engine Deployment(Use only one):

1. Use "4.appengine". This module will create an app engine instance used for basic testing. This module does not include any load balancing.
2. Use "4.lb_appengine". This module will create an app engine instance used for production. It will create all necassary HTTP(s) load balancing configuration needed for deployment.
