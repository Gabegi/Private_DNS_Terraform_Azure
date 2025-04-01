# Application Network Security in Azure
This repo showcases a simple example on how to set-up networking security for an application hosted in Azure.

It leverages the following services:
- vnet
- subnet
- private endpoints
- private links
- private dns zone
- private dns network link
- network security groups

## Architecture
Here's what we are building.
![Architecture](architecture.jpeg)

## Getting started

You need to add a folder called vars and add a tfvars file in there.



Potential improvement is to use modules


Navigate to the repo and run:
- terraform init
- terraform plan -var-file="vars/values.tfvars"
- terraform apply -auto-approve -var-file="vars/values.tfvars" 
- terraform destroy -var-file="vars/values.tfvars"

## Testing
Using Ssh

```
curl -o response.html https://dns-app2.azurewebsites.net
curl -w "\nHTTP Status Code: %{http_code}\n" -o response.html https://dns-app2.azurewebsites.net && cat response.html

 tracert -d dns-app2.azurewebsites.net

```



Using an http client
- navigate to the src repo, to Application_1 and replace xxxx with the dns-app2 Function App Key (found in Azure)
```
https://dns-app2.azurewebsites.net/api/ReceiveCall?code=xxxx"
```



