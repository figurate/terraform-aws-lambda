SHELL:=/bin/bash
TERRAFORM_VERSION=0.12.24
TERRAFORM=docker run --rm -v "${PWD}:/work" -v "${HOME}:/root" -e AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) -e http_proxy=$(http_proxy) --net=host -w /work hashicorp/terraform:$(TERRAFORM_VERSION)

TERRAFORM_DOCS=docker run --rm -v "${PWD}:/work" tmknom/terraform-docs

CHECKOV=docker run --rm -t -v "${PWD}:/work" bridgecrew/checkov

TFSEC=docker run --rm -it -v "${PWD}:/work" liamg/tfsec

DIAGRAMS=docker run -t -v "${PWD}:/work" figurate/diagrams python

EXAMPLE=$(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))

.PHONY: all clean validate test docs format

all: validate test docs format

clean:
	rm -rf .terraform/

validate:
	$(TERRAFORM) init && $(TERRAFORM) validate && \
		$(TERRAFORM) init modules/cloudfront-request-rewrite && $(TERRAFORM) validate modules/cloudfront-request-rewrite && \
		$(TERRAFORM) init modules/dynamodb-table-import && $(TERRAFORM) validate modules/dynamodb-table-import && \
		$(TERRAFORM) init modules/dynamodb-table-put && $(TERRAFORM) validate modules/dynamodb-table-put && \
		$(TERRAFORM) init modules/ec2-ami-deletion && $(TERRAFORM) validate modules/ec2-ami-deletion && \
		$(TERRAFORM) init modules/ec2-instance-cycle && $(TERRAFORM) validate modules/ec2-instance-cycle && \
		$(TERRAFORM) init modules/iam-user-keyrotation && $(TERRAFORM) validate modules/iam-user-keyrotation && \
		$(TERRAFORM) init modules/rds-cluster-cycle && $(TERRAFORM) validate modules/rds-cluster-cycle && \
		$(TERRAFORM) init modules/rds-cluster-snapshot && $(TERRAFORM) validate modules/rds-cluster-snapshot && \
		$(TERRAFORM) init modules/rds-instance-cycle && $(TERRAFORM) validate modules/rds-instance-cycle && \
		$(TERRAFORM) init modules/rds-instance-snapshot && $(TERRAFORM) validate modules/rds-instance-snapshot

test: validate
	$(CHECKOV) -d /work && \
		$(CHECKOV) -d /work/modules/cloudfront-request-rewrite && \
		$(CHECKOV) -d /work/modules/dynamodb-table-import && \
		$(CHECKOV) -d /work/modules/dynamodb-table-put && \
		$(CHECKOV) -d /work/modules/ec2-ami-deletion && \
		$(CHECKOV) -d /work/modules/ec2-instance-cycle && \
		$(CHECKOV) -d /work/modules/iam-user-keyrotation && \
		$(CHECKOV) -d /work/modules/rds-cluster-cycle && \
		$(CHECKOV) -d /work/modules/rds-cluster-snapshot && \
		$(CHECKOV) -d /work/modules/rds-instance-cycle && \
		$(CHECKOV) -d /work/modules/rds-instance-snapshot

	$(TFSEC) /work && \
		$(TFSEC) /work/modules/cloudfront-request-rewrite && \
		$(TFSEC) /work/modules/dynamodb-table-import && \
		$(TFSEC) /work/modules/dynamodb-table-put && \
		$(TFSEC) /work/modules/ec2-ami-deletion && \
		$(TFSEC) /work/modules/ec2-instance-cycle && \
		$(TFSEC) /work/modules/iam-user-keyrotation && \
		$(TFSEC) /work/modules/rds-cluster-cycle && \
		$(TFSEC) /work/modules/rds-cluster-snapshot && \
		$(TFSEC) /work/modules/rds-instance-cycle && \
		$(TFSEC) /work/modules/rds-instance-snapshot


diagram:
	$(DIAGRAMS) diagram.py

docs: diagram
	$(TERRAFORM_DOCS) markdown ./ >./README.md && \
		$(TERRAFORM_DOCS) markdown ./modules/cloudfront-request-rewrite >./modules/cloudfront-request-rewrite/README.md && \
		$(TERRAFORM_DOCS) markdown ./modules/dynamodb-table-import >./modules/dynamodb-table-import/README.md && \
		$(TERRAFORM_DOCS) markdown ./modules/dynamodb-table-put >./modules/dynamodb-table-put/README.md && \
		$(TERRAFORM_DOCS) markdown ./modules/ec2-ami-deletion >./modules/ec2-ami-deletion/README.md && \
		$(TERRAFORM_DOCS) markdown ./modules/ec2-instance-cycle >./modules/ec2-instance-cycle/README.md && \
		$(TERRAFORM_DOCS) markdown ./modules/iam-user-keyrotation >./modules/iam-user-keyrotation/README.md && \
		$(TERRAFORM_DOCS) markdown ./modules/rds-cluster-cycle >./modules/rds-cluster-cycle/README.md && \
		$(TERRAFORM_DOCS) markdown ./modules/rds-cluster-snapshot >./modules/rds-cluster-snapshot/README.md && \
		$(TERRAFORM_DOCS) markdown ./modules/rds-instance-cycle >./modules/rds-instance-cycle/README.md && \
		$(TERRAFORM_DOCS) markdown ./modules/rds-instance-snapshot >./modules/rds-instance-snapshot/README.md

format:
	$(TERRAFORM) fmt -list=true ./ && \
		$(TERRAFORM) fmt -list=true ./modules/cloudfront-request-rewrite && \
		$(TERRAFORM) fmt -list=true ./modules/dynamodb-table-import && \
		$(TERRAFORM) fmt -list=true ./modules/dynamodb-table-put && \
		$(TERRAFORM) fmt -list=true ./modules/ec2-ami-deletion && \
		$(TERRAFORM) fmt -list=true ./modules/ec2-instance-cycle && \
		$(TERRAFORM) fmt -list=true ./modules/iam-user-keyrotation && \
		$(TERRAFORM) fmt -list=true ./modules/rds-cluster-cycle && \
		$(TERRAFORM) fmt -list=true ./modules/rds-cluster-snapshot && \
		$(TERRAFORM) fmt -list=true ./modules/rds-instance-cycle && \
		$(TERRAFORM) fmt -list=true ./modules/rds-instance-snapshot

example:
	$(TERRAFORM) init examples/$(EXAMPLE) && $(TERRAFORM) plan examples/$(EXAMPLE)
