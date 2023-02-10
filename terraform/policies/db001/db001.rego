package policies.db001

import data.metadata.db001 as policy
import future.keywords.in
import input.plan as tfplan

actions := [
	["no-op"],
	["create"],
	["update"],
]

db_size := 128

resources := [resource_changes |
	resource_changes := tfplan.resource_changes[_]
	resource_changes.type == "fakewebservices_database"
	resource_changes.mode == "managed"
	resource_changes.change.actions in actions
]

violations := [resource |
	resource := resources[_]
	not resource.change.after.size == db_size
]

violators[address] {
	address := violations[_].address
}

# METADATA
# title: DB001
# description: Ensure that all databases are sized accordingly
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
		"policy": policy.id,
		"description": policy.description,
		"severity": policy.severity,
		"enforcement_level": policy.enforcement_level,
		"resources": {
			"count": count(violations),
			"addresses": violators,
		},
	}
}
