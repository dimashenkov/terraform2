# ----root/main.tf------

provider "aws" {
  region = "${var.aws_region}"
}

#Za po sigurno i backup, se pravi Remote State
terraform {
	backend "s3" {
	  bucket = "tf-s3-course-state"
	  key = "terraform/terraform.tfstate"
	  region = "eu-west-1"
	}
}

# Deploy storage resource

module "storage" {
  source       = "./storage"
  project_name = "${var.project_name}"
}

# Deploy networking resource

module "networking" {
  source       = "./networking"
  vpc_cidr     = "${var.vpc_cidr}"
  public_cidrs = "${var.public_cidrs}"
  accessip     = "${var.accessip}"
}

# Deploy Compute Resource
module "compute" {
  source          = "./compute"
  instance_count  = "${var.instance_count}"
  key_name        = "${var.key_name}"
  public_key_path = "${var.public_key_path}"
  instance_type   = "${var.server_instance_type}"
  subnets         = "${module.networking.public_subnets}"
  security_group  = "${module.networking.public_sg}"
  subnet_ips      = "${module.networking.subnet_ips}"
}
