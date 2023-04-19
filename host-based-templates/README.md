## Push Docker Image to Google Cloud:
Ensure that you have a Dockerfile in the directory from which you are running this command.
```bash
gcloud builds submit --tag gcr.io/${CHALLENGE_CATEGORY}/${CHALLENGE_NAME}:1.0.0 .
```

## Web Instructions
Command to create ip: 
```bash
gcloud compute addresses create ingress-webapps --global
```

1. apply the managed cert
2. apply the service with deployment
3. apply the ingress
4. "kubectl get ingress" to get the ip of ingress
5. configure cloudflare to point the ip address of the load balancer