# Private_DNS_Terraform
Private Azure DNS Zone in Terraform

This repo showcases a simple example on how to set-up a private DNS Zone in Azure using Terraform Code


Navigate to the repo and run:
- terraform init
- terraform plan -var-file="vars/values.tfvars"
- terraform apply -auto-approve -var-file="vars/values.tfvars" 
- terraform destroy -var-file="vars/values.tfvars"