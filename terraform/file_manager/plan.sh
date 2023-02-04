#!/bin/bash

export TF_VAR_region="eu-central-1"
export TF_VAR_artifactory_base_url="http://artifactory"
export TF_VAR_artifactory_repo="file-manager"
export TF_VAR_artifactory_username="ali"
export TF_VAR_artifactory_password="1234"

terraform plan