#!/bin/bash

docker-compose -f docker-compose.yml run --rm terraform init && terraform destroy -auto-approve