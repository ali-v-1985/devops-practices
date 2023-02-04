/*Give me terraform scripts for deploying an aws lambda function in python which let user upload a photo which is not
larger than 5 mb and an aws api gateway for connecting to that lambda function, an S3 bucket which lambda function will
upload the file there. Uploading the file would fire an event to aws kenisis which that event would be consumed
by another gateway and would trigger another lambda function which save a record in the a mongodb with the
user name, name of the file, size of the file, date and time of upload and address of the file on s3 bucket on an aws dynamodb.
Another lambda function accessible through api gateway let the user download the file on s3 bucket with the id to the file.
This function should go fetch the url of the file from aws dynamodb and then use the url to download the file.
The api gateway utilise amazon IAM for user authentication. The IAM should have 3 user groups admin with access
to everything, and uploader user to access to upload api and the downloader to acess the download api.*/
variable "region" {
  type        = string
  description = "The AWS region to deploy the infrastructure to"
}

provider "aws" {
  region = var.region
}

variable "artifactory_base_url" {
  type = string
  description = "Artifactory base url to download the artifacts"
}

variable "artifactory_repo" {
  type = string
  description = "Artifactory base repository."
}

variable "artifactory_username" {
  type = string
  description = "The username to connect to the artifactory."
}

variable "artifactory_password" {
  type = string
  description = "The password to connect to the artifactory."
}

locals {
  artifactory_headers = {
    Authorization = "Basic ${base64encode(var.artifactory_username + ":" + var.artifactory_password)}"
  }
}

module "iam" {
  source = "iam"
}

module "s3" {
  source = "s3"
}

module "api" {
  source = "api"
}

module "db" {
  source = "db"
}

module "lambda" {
  source = "lambda"
}