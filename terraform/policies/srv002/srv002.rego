package policies.srv002

import future.keywords.in
import input.plan as tfplan

actions := [
	["no-op"],
	["create"],
	["update"],
]

resources := [resource_changes |
	resource_changes := tfplan.resource_changes[_]
	resource_changes.type == "fakewebservices_server"
	resource_changes.mode == "managed"
	resource_changes.change.actions in actions
]

violations := [resource |
	resource := resources[_]
	not resource.change.after.vpc == "Primary VPC"
]

violators[address] {
	address := violations[_].address
}

# METADATA
# title: SRV002
# description: Ensure that servers are connected to the 'Primary VPC' network
# enforcement_level: advise
# custom:
#  severity: high
#  enforcement_level: mandatory
# related_resources:
# - ref: https://github.com/hcrhall/rego-dynamic-policy-composition/
# authors:
# - name: Ryan Hall
# - email: mailme@example.com
# organizations:
# - HashiCorp
rule[result] {
	count(violations) != 0
	result := {
		"policy": rego.metadata.rule().title,
		"description": rego.metadata.rule().description,
		"severity": rego.metadata.rule().custom.severity,
		"enforcement_level": rego.metadata.rule().custom.enforcement_level,
		"resources": {
			"count": count(violations),
			"addresses": violators,
		},
	}
}
