package terraform.policies

import future.keywords.in
import input as tfplan

valid_actions := [
	["no-op"],
	["create"],
	["update"]
]

allowed_server_types := [
	"t2.small",
	"t2.medium",
	"t2.large"
]

all_servers := [ resource_changes |
    resource_changes := tfplan.resource_changes[_]
    resource_changes.type == "fakewebservices_server"
 	resource_changes.mode == "managed"
    resource_changes.change.actions in valid_actions
]

all_server_type_violations := [ resources |
    resources := all_servers[_]
    not resources.change.after.type in allowed_server_types
]

# METADATA
# scope: rule
# title: FWS-SRV-001
# description: Ensure that only allowed server type values are defined
# custom:
#  severity: medium
#  enforcement_level: mandatory
# related_resources:
# - ref: https://github.com/hcrhall/rego-dynamic-policy-composition/
# authors:
# - name: Ryan Hall
# - email: mailme@example.com
# organizations:
# - HashiCorp
rule[msg] {
    count(all_server_type_violations) != 0
    msg := {
        "policy": rego.metadata.rule().title,
        "description": rego.metadata.rule().description,
        "severity": rego.metadata.rule().custom.severity,
        "enforcement_level": rego.metadata.rule().custom.enforcement_level
    }
}