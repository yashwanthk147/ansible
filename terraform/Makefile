help:		## Print Help Message
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' -e 's/clean //' | sed -e 's/##//'

clean:
	@rm -rf .terraform*

dev-apply:	clean ## Create Infra for Dev Env
	@terraform init -backend-config=environments/dev-backend.tfvars -no-color
	@terraform apply -auto-approve -var-file=environments/dev.tfvars -no-color

prod-apply:	clean ## Create Infra for Prod Env
	@terraform init -backend-config=environments/prod-backend.tfvars -no-color
	@terraform apply -auto-approve -var-file=environments/prod.tfvars -no-color

dev-destroy:	clean ## Delete Infra for Dev Env
	@terraform init -backend-config=environments/dev-backend.tfvars -no-color
	@terraform destroy -auto-approve -var-file=environments/dev.tfvars -no-color

prod-destroy:	clean ## Delete Infra for Prod Env
	@terraform init -backend-config=environments/prod-backend.tfvars -no-color
	@terraform destroy -auto-approve -var-file=environments/prod.tfvars -no-color