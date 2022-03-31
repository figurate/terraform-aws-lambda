SHELL:=/bin/bash
include .env

EXAMPLE=$(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))
VERSION=$(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))

.PHONY: all clean validate test diagram docs format release

all: test docs format

clean:
	rm -rf .terraform/

validate:
	$(TERRAFORM) init -upgrade && $(TERRAFORM) validate && \
		$(TERRAFORM) -chdir=modules/cloudfront-request-rewrite init -upgrade && $(TERRAFORM) -chdir=modules/cloudfront-request-rewrite validate

test: validate
	$(CHECKOV) -d /work
	$(TFSEC) /work

diagram:
	$(DIAGRAMS) diagram.py

docs: diagram
	$(TERRAFORM_DOCS) markdown ./ >./README.md && \
		$(TERRAFORM_DOCS) markdown ./modules/cloudfront-request-rewrite >./modules/cloudfront-request-rewrite/README.md

format:
	$(TERRAFORM) fmt -list=true ./ && \
		$(TERRAFORM) fmt -list=true ./modules/cloudfront-request-rewrite && \
		$(TERRAFORM) fmt -list=true ./examples/dynamodb-table-import && \
		$(TERRAFORM) fmt -list=true ./examples/dynamodb-table-put && \
		$(TERRAFORM) fmt -list=true ./examples/ec2-ami-deletion && \
		$(TERRAFORM) fmt -list=true ./examples/ec2-instance-cycle && \
		$(TERRAFORM) fmt -list=true ./examples/iam-user-keyrotation && \
		$(TERRAFORM) fmt -list=true ./examples/rds-cluster-cycle && \
		$(TERRAFORM) fmt -list=true ./examples/rds-cluster-snapshot && \
		$(TERRAFORM) fmt -list=true ./examples/rds-instance-cycle && \
		$(TERRAFORM) fmt -list=true ./examples/rds-instance-snapshot

example:
	$(TERRAFORM) -chdir=examples/$(EXAMPLE) init -upgrade && $(TERRAFORM) -chdir=examples/$(EXAMPLE) plan -input=false

release: test
	git tag $(VERSION) && git push --tags
