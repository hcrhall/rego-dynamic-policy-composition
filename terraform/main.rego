package terraform

policies := [
	"srv001",
	"srv002",
	"db001",
]

results[result] {
	some i
	policy := policies[i]
	result := data.policies[policy].rule
}

# METADATA
# title: SEC001
# description: Ensure that all resources that have been created using the Terraform 'Fake Web Services' Provider are compliant.
# related_resources:
# - ref: https://github.com/hashicorp/terraform-provider-fakewebservices
# authors:
# - name: Ryan Hall
# - email: mailme@example.com
# organizations:
# - HashiCorp
main := results
