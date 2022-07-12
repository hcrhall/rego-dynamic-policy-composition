package terraform.policies

import future.keywords.in
import input as tfplan

valid_actions := [
	["no-op"],
	["create"],
	["update"],
]

allowed_database_size := 128

all_databases := [resource_changes |
	resource_changes := tfplan.resource_changes[_]
	resource_changes.type == "fakewebservices_database"
	resource_changes.mode == "managed"
]

all_database_size_violations := [resources |
	resources := all_databases[_]
	not resources.change.after.size == allowed_database_size
]

# METADATA
# title: FWS-DB-001
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
rule[outcome] {
	count(all_database_size_violations) != 0
	outcome := {
		"policy": rego.metadata.rule().title,
		"description": rego.metadata.rule().description,
		"severity": rego.metadata.rule().custom.severity,
		"enforcement_level": rego.metadata.rule().custom.enforcement_level,
	}
}
