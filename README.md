# Steps to Deploy



## Setup Environment variables to access AWS environment

export AWS_ACCESS_KEY_ID=[your_access_key]
export AWS_SECRET_ACCESS_KEY=[your_secret_key]
export AWS_DEFAULT_REGION=us-east-1

## To create image repository and push app image

```
make build_image
```

## Create AMI 

This steps creates an AMI that is used by terraform to deploy jump servers, to create the AMI execute:

```
make build_ami
```

## Deploy Infrastructure

Execute terraform apply to deploy all resources used by the application 

```
make tf_apply
```
