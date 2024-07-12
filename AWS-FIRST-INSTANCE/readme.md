# AWS First Instance with Terraform

This repository contains Terraform configuration files to create an AWS EC2 instance and set up an Nginx server with a custom index page. This README file will guide you through understanding the purpose of each file and the steps required to set up your first AWS instance using Terraform.

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Files Description](#files-description)
- [Setup Instructions](#setup-instructions)
- [Usage](#usage)
- [Conclusion](#conclusion)

## Introduction

Terraform is an open-source infrastructure as code software tool created by HashiCorp. It enables users to define and provision data center infrastructure using a high-level configuration language known as HashiCorp Configuration Language (HCL), or optionally JSON.

In this repository, we have a Terraform script that helps in automating the creation of an AWS EC2 instance and setting up an Nginx web server with a custom welcome page.

## Prerequisites

Before you begin, ensure you have the following installed:

- Terraform
- AWS CLI
- An AWS account with the necessary permissions to create resources

## Files Description

### provider.tf

This file defines the AWS provider configuration.

```hcl
provider "aws" {
  region     = "us-west-2"
}
```

### variables.tf

This file defines the variables used in the Terraform configuration. Variables make your configuration flexible and reusable.

```hcl
variable "aws_access_key" {
  description = "AWS access key"
}

variable "aws_secret_key" {
  description = "AWS secret key"
}

variable "key_name" {
  description = "Name of the SSH key pair"
}
```

### terraform.tfvars

This file contains the values for the variables defined in `variables.tf`. It should be created by the user to store sensitive data.

```hcl
aws_access_key = "your_access_key"
aws_secret_key = "your_secret_key"
key_name       = "your_key_name"
```

### key-pair.tf

This file defines the key pair resource.

```hcl
resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = file("~/.ssh/id_rsa.pub")
}
```

### security-groups.tf

This file defines the security group with the necessary inbound and outbound rules.

```hcl
resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

### instance.tf

This file defines the EC2 instance resource and includes the user data script to install Nginx and replace the default index page.

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = var.key_name
  security_groups = [aws_security_group.allow_ssh_http.name]

  user_data = file("script.sh")

  tags = {
    Name = "WebServer"
  }
}
```

### script.sh

This is the user data script that will be executed on the EC2 instance to install Nginx and replace the default index page with a custom message.

```sh
#!/bin/bash
yum update -y
yum install -y nginx
systemctl start nginx
systemctl enable nginx
echo "Hey SAPAN" > /usr/share/nginx/html/index.html
```

### outputs.tf

This file defines the outputs of your Terraform configuration. Outputs are used to display information after your infrastructure is provisioned.

```hcl
output "instance_id" {
  value = aws_instance.web.id
}

output "public_ip" {
  value = aws_instance.web.public_ip
}
```

## Setup Instructions

### Step 1: Create an AWS Key Pair

Generate a new RSA key pair for SSH access to your instance:

```sh
ssh-keygen -t rsa -f ~/.ssh/id_rsa
```

### Step 2: Create IAM User and Get Credentials

Create an IAM user in AWS and obtain the access key and secret key. These will be used in the `terraform.tfvars` file.

### Step 3: Initialize Terraform

Run the following command to initialize Terraform. This will download the necessary provider plugins.

```sh
terraform init
```
![image](https://github.com/user-attachments/assets/15713140-25eb-4366-b8fc-7952d22fb7a2)


### Step 4: Plan the Infrastructure

Generate and show an execution plan to check what resources will be created.

```sh
terraform plan
```
![image](https://github.com/user-attachments/assets/a23e0075-baa2-4def-a196-7fb95f1d1dfe)

### Step 5: Apply the Configuration

Apply the changes required to reach the desired state of the configuration.

```sh
terraform apply
```
![image](https://github.com/user-attachments/assets/35ffe8fa-46ed-430a-af75-e4cf489ba815)

## Usage

After running `terraform apply`, Terraform will create an EC2 instance on AWS, install Nginx, and replace the default index page with a custom message. You can connect to your instance using the SSH key you generated:
![image](https://github.com/user-attachments/assets/87da38e5-e487-4c1d-a1d8-6ddb6a214efa)


```sh
ssh -i ~/.ssh/id_rsa ec2-user@<public_ip>
```

Replace `<public_ip>` with the actual public IP of your instance, which will be displayed as an output.

To see the custom message, open your web browser and go to:

```
http://<public_ip>
```
![image](https://github.com/user-attachments/assets/ecb386fe-1241-4f2c-b184-c6b468cb3cb4)

You should see the message "Hey SAPAN".

## Conclusion

This repository provides a simple example of how to use Terraform to automate the creation of AWS resources and set up a web server with a custom index page. By following the instructions, you can easily set up and manage your infrastructure as code.

---
