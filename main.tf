terraform {
  #############################################################
  ## AFTER RUNNING TERRAFORM APPLY (WITH LOCAL BACKEND)
  ## YOU WILL UNCOMMENT THIS CODE THEN RERUN TERRAFORM INIT
  ## TO SWITCH FROM LOCAL BACKEND TO REMOTE AWS BACKEND
  #############################################################
  # backend "s3" {
  #   bucket         = "devops-directive-tf-state" # REPLACE WITH YOUR BUCKET NAME
  #   key            = "03-basics/import-bootstrap/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-state-locking"
  #   encrypt        = true
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "example" {
  key_name   = "tf"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2x0i0YHEoF0EtIMkLvaG4ZQYm4FCU0oD742cWVw3atP2CdOoMS38jr9VoTIwNCikKoj8tJ+m4gSITSs0RHpQyxt87a4yLA9y1bZ6R+2aHprXMJ5wXZC0XP8ECSptvo8J96u5HUrmghHKIJIRdc6WyS/+dVPKS+MAVb9W87Wghu4gJWYV4Qtpimw6U/d42c9XgLBVx1dRw6+cXFoHzNJ/7laiVc1RAUoXHmvCZa8+vOfl1H3Qo/QPuBNApzafC1oyuHj/W38HoqCMVWfGEG8ZQ4VI3czJ69PFmCmYfgj8a96eSRh/7alH8cYEx1PjZmmWlnixvomsnd7+sBDGALzm9 sinda@pc-sinda"
} 
 
resource "aws_instance" "instance_1" {
  ami             = "ami-011899242bb902164" # Ubuntu 20.04 LTS // us-east-1
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instances.name]
  key_name      = "tf"
  user_data = file("k8s-master-install.sh")
  //user_data       = <<-EOF
              //#!/bin/bash
              //echo "Hello, World 1" > index.html
              //python3 -m http.server 8080 &
              //EOF
 tags = {
    Name = "MasterNode"
 }
 connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("/home/sinda/Bureau/hello/tf")
      timeout     = "4m"
   }
}

resource "aws_instance" "instance_2" {
  count=4 
  ami             = "ami-011899242bb902164" # Ubuntu 20.04 LTS // us-east-1
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instances.name]
  key_name      = "tf"
  user_data = file("k8s-slave-install.sh")
  //user_data       = <<-EOF
              //#!/bin/bash
              //echo "Hello, World 1" > index.html
              //python3 -m http.server 8080 &
              //EOF
  tags = {
    Name = "SlaveNode"
 }
  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("/home/sinda/Bureau/hello/tf")
      timeout     = "4m"
   }
}

data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnet_ids" "default_subnet" {
  vpc_id = data.aws_vpc.default_vpc.id
}

resource "aws_security_group" "instances" {
  name = "instance-security-group"
}