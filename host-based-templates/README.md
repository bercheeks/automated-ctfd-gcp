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