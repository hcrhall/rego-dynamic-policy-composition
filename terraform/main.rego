package terraform.main

# METADATA
# title: FWS-SEC-001
# description: Ensure that all resources that have been created using the Terraform 'Fake Web Services' Provider are compliant.
# related_resources:
# - ref: https://github.com/hashicorp/terraform-provider-fakewebservices
# authors:
# - name: Ryan Hall
# - email: mailme@example.com
# organizations:
# - HashiCorp
main[outcome] {
	outcome := {
        rego.metadata.rule().title: {
		    "description": rego.metadata.rule().description,
		    "violations": data.terraform.policies.rule,
	    }
    }
}
