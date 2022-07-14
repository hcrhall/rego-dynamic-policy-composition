package terraform.main

policies := [
    "fws_srv_001",
    "fws_srv_002",
    "fws_db_001",
]

results[result] {
    some i
    policy := policies[i]
    result := data.terraform[policy].rule
}

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
	outcome := {rego.metadata.rule().title: {
		"description": rego.metadata.rule().description,
		"results": results,
	}}
}
