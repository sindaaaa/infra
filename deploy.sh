#!/bin/bash

docker-compose -f docker-compose.yml run --rm terraform init && terraform apply -auto-approve
