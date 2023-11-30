apply:
	cd terraform &&\
	terraform apply

fmt:
	terraform fmt -recursive

plan:
	cd terraform &&\
	terraform plan

.PHONY: apply fmt plan