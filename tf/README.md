# How to build infrastructure

Needs AWS subscription to EKS.

Export vars for authentication.

```bash
export AWS_ACCESS_KEY_ID="<REPLACE_WITH_KEY_ID>"
export AWS_SECRET_ACCESS_KEY="<REPLACE_WITH_ACCESS_KEY>"
export AWS_DEFAULT_REGION="eu-west-2"
```

Update path to ssh public key file in `terraform.tfvars` file.

```terraform
ssh_public_key_file = "/path/to/home/.ssh/id_rsa.pub"
```

Initialise terraform.

```bash
terraform init
```

Plan and apply to create infra.

```bash
terraform plan
terraform apply
```