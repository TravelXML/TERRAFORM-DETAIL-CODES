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

### main.tf

This is the main configuration file for Terraform. It defines the resources that will be created on AWS, such as the EC2 instance and the setup of an Nginx server.

```hcl
provider "aws" {
  region     = "us-west-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_instance" "my_first_instance" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  key_name = var.key_name

  tags = {
    Name = "MyFirstInstance"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "Hey SAPAN" > /usr/share/nginx/html/index.html
              EOF
}
```

### variables.tf

This file defines the variables used in the `main.tf` file. Variables make your configuration flexible and reusable.

```hcl
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "key_name" {}
```

### terraform.tfvars

This file contains the values for the variables defined in `variables.tf`. It should be created by the user to store sensitive data.

```hcl
aws_access_key = "your_access_key"
aws_secret_key = "your_secret_key"
key_name       = "your_key_name"
```

### outputs.tf

This file defines the outputs of your Terraform configuration. Outputs are used to display information after your infrastructure is provisioned.

```hcl
output "instance_id" {
  value = aws_instance.my_first_instance.id
}

output "public_ip" {
  value = aws_instance.my_first_instance.public_ip
}
```

## Setup Instructions

### Step 1: Create an AWS Key Pair

Generate a new RSA key pair for SSH access to your instance:

```sh
ssh-keygen -t rsa -f ./id_rsa
```

### Step 2: Create IAM User and Get Credentials

Create an IAM user in AWS and obtain the access key and secret key. These will be used in the `terraform.tfvars` file.

### Step 3: Create Security Group

Create a security group in AWS with the following incoming rules:

- TCP port 22 (SSH)
- TCP port 80 (HTTP)
- TCP port 443 (HTTPS)
- TCP port 3306 (MySQL)
- TCP port 27017 (MongoDB)

Allow all outgoing traffic.

### Step 4: Initialize Terraform

Run the following command to initialize Terraform. This will download the necessary provider plugins.

```sh
terraform init
```

### Step 5: Plan the Infrastructure

Generate and show an execution plan to check what resources will be created.

```sh
terraform plan
```

### Step 6: Apply the Configuration

Apply the changes required to reach the desired state of the configuration.

```sh
terraform apply
```

## Usage

After running `terraform apply`, Terraform will create an EC2 instance on AWS, install Nginx, and replace the default index page with a custom message. You can connect to your instance using the SSH key you generated:

```sh
ssh -i ./id_rsa ec2-user@<public_ip>
```

Replace `<public_ip>` with the actual public IP of your instance, which will be displayed as an output.

To see the custom message, open your web browser and go to:

```
http://<public_ip>
```

You should see the message "Hey SAPAN".

## Conclusion

This repository provides a simple example of how to use Terraform to automate the creation of AWS resources and set up a web server with a custom index page. By following the instructions, you can easily set up and manage your infrastructure as code.
