SHELL:=/bin/bash
TERRAFORM_VERSION=0.12.24
TERRAFORM=docker run --rm -v "${PWD}:/work" -v "${HOME}:/root" -e AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) -e http_proxy=$(http_proxy) --net=host -w /work hashicorp/terraform:$(TERRAFORM_VERSION)

.PHONY: all clean test docs format

all: test docs format

clean:
	rm -rf .terraform/

test:
	$(TERRAFORM) init && $(TERRAFORM) validate && \
		$(TERRAFORM) init modules/cloudfront-request-rewrite && $(TERRAFORM) validate modules/cloudfront-request-rewrite
		$(TERRAFORM) init modules/dynamodb-table-import && $(TERRAFORM) validate modules/dynamodb-table-import
		$(TERRAFORM) init modules/dynamodb-table-put && $(TERRAFORM) validate modules/dynamodb-table-put
		$(TERRAFORM) init modules/ec2-ami-deletion && $(TERRAFORM) validate modules/ec2-ami-deletion
		$(TERRAFORM) init modules/ec2-instance-cycle && $(TERRAFORM) validate modules/ec2-instance-cycle
		$(TERRAFORM) init modules/iam-user-keyrotation && $(TERRAFORM) validate modules/iam-user-keyrotation
		$(TERRAFORM) init modules/rds-cluster-cycle && $(TERRAFORM) validate modules/rds-cluster-cycle
		$(TERRAFORM) init modules/rds-cluster-snapshot && $(TERRAFORM) validate modules/rds-cluster-snapshot
		$(TERRAFORM) init modules/rds-instance-cycle && $(TERRAFORM) validate modules/rds-instance-cycle
		$(TERRAFORM) init modules/rds-instance-snapshot && $(TERRAFORM) validate modules/rds-instance-snapshot

docs:
	docker run --rm -v "${PWD}:/work" tmknom/terraform-docs markdown ./ >./README.md && \
		docker run --rm -v "${PWD}:/work" tmknom/terraform-docs markdown ./modules/cloudfront-request-rewrite >./modules/cloudfront-request-rewrite/README.md
		docker run --rm -v "${PWD}:/work" tmknom/terraform-docs markdown ./modules/dynamodb-table-import >./modules/dynamodb-table-import/README.md
		docker run --rm -v "${PWD}:/work" tmknom/terraform-docs markdown ./modules/dynamodb-table-put >./modules/dynamodb-table-put/README.md
		docker run --rm -v "${PWD}:/work" tmknom/terraform-docs markdown ./modules/ec2-ami-deletion >./modules/ec2-ami-deletion/README.md
		docker run --rm -v "${PWD}:/work" tmknom/terraform-docs markdown ./modules/ec2-instance-cycle >./modules/ec2-instance-cycle/README.md
		docker run --rm -v "${PWD}:/work" tmknom/terraform-docs markdown ./modules/iam-user-keyrotation >./modules/iam-user-keyrotation/README.md
		docker run --rm -v "${PWD}:/work" tmknom/terraform-docs markdown ./modules/rds-cluster-cycle >./modules/rds-cluster-cycle/README.md
		docker run --rm -v "${PWD}:/work" tmknom/terraform-docs markdown ./modules/rds-cluster-snapshot >./modules/rds-cluster-snapshot/README.md
		docker run --rm -v "${PWD}:/work" tmknom/terraform-docs markdown ./modules/rds-instance-cycle >./modules/rds-instance-cycle/README.md
		docker run --rm -v "${PWD}:/work" tmknom/terraform-docs markdown ./modules/rds-instance-snapshot >./modules/rds-instance-snapshot/README.md

format:
	$(TERRAFORM) fmt -list=true ./ && \
		$(TERRAFORM) fmt -list=true ./modules/cloudfront-request-rewrite
		$(TERRAFORM) fmt -list=true ./modules/dynamodb-table-import
		$(TERRAFORM) fmt -list=true ./modules/dynamodb-table-put
		$(TERRAFORM) fmt -list=true ./modules/ec2-ami-deletion
		$(TERRAFORM) fmt -list=true ./modules/ec2-instance-cycle
		$(TERRAFORM) fmt -list=true ./modules/iam-user-keyrotation
		$(TERRAFORM) fmt -list=true ./modules/rds-cluster-cycle
		$(TERRAFORM) fmt -list=true ./modules/rds-cluster-snapshot
		$(TERRAFORM) fmt -list=true ./modules/rds-instance-cycle
		$(TERRAFORM) fmt -list=true ./modules/rds-instance-snapshot
