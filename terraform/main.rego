package terraform.main

import input as tfplan

# METADATA
# title: FWS-SEC-001
# description: Ensure that all resources that have been created using the Terraform "Fake Web Services" Provider are compliant.
# related_resources:
# - ref: https://github.com/hashicorp/terraform-provider-fakewebservices
# authors:
# - name: Ryan Hall
# - email: mailme@example.com
# organizations:
# - HashiCorp
main[msg] {
    # print(types)
    # msg := data.terraform.policies.rule
    msg := {
        rego.metadata.rule().title : {
            "description": rego.metadata.rule().description,
            "violations": data.terraform.policies.rule
        }
    }
}
