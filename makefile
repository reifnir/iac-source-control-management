generate:
	python generate-pipelines/generate_pipeline.py --output child-pipeline.yml

init:
	rm -rf ./terraform/.terraform
	terraform -chdir=./terraform init \
		-backend-config="region=$(TERRAFORM_STATE_REGION)" \
		-backend-config="bucket=$(TERRAFORM_STATE_BUCKET)" \
		-backend-config="key=$(TERRAFORM_STATE_KEY)"

validate:
	terraform -chdir=./terraform validate

plan:
	# Just see the plan
	terraform -chdir=./terraform plan -lock=false
