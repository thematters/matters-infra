# matters-infra

## Setup infrastructure

### Terragrunt commands (staging environment)

- Install `terraform` and `terragrunt`
- `aws configure`
- To setup staging environment, go to each of the following sub-folders:
  - `terraform/stage/networks`
  - `terraform/stage/databases`
  - `terraform/stage/webservers`
- Run the following commands:
  - `terraform init`
  - `terraform plan`
  - `terraform apply`

### Setup ES

Follow the README of elasticsearch setup in [https://github.com/thematters/matters-docker/tree/master/docker/elasticsearch](matters-docker/docker/elasticsearch/README.md)

### Setup IPFS

Follow the READMD of IPFS setup in [https://github.com/thematters/matters-docker/tree/master/docker/ipfs]()

- Ansible
- `docker-compose up -d`

### Setup DB

- `pg_dump` from develop DB, then
- psql < dumpfile.sql

## TODO

change default security group rules for DB accessing
lambda
