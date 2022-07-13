package terraform.policies

import future.keywords.in
import input as tfplan

valid_actions := [
	["no-op"],
	["create"],
	["update"],
]

allowed_server_types := [
	"t2.small",
	"t2.medium",
	"t2.large",
]

all_servers := [resource_changes |
	resource_changes := tfplan.resource_changes[_]
	resource_changes.type == "fakewebservices_server"
	resource_changes.mode == "managed"
	resource_changes.change.actions in valid_actions
]

all_server_vpc_violations := [resources |
	resources := all_servers[_]
	not resources.change.after.vpc == "Primary VPC"
]

# METADATA
# title: FWS-SRV-002
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
	count(all_server_vpc_violations) != 0
	result := {
		"policy": rego.metadata.rule().title,
		"description": rego.metadata.rule().description,
		"severity": rego.metadata.rule().custom.severity,
		"enforcement_level": rego.metadata.rule().custom.enforcement_level,
		"violations": {
			"count": count(all_server_vpc_violations),
			"resources": all_server_vpc_violations[_].address,
		},
	}
}