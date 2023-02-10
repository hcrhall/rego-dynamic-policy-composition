build:
	opa build ./terraform --revision "0.1" --output ./bundles/bundle.tar.gz
eval:
	opa eval -f pretty --fail --bundle ./terraform --input ./input/plan.json "data.terraform.main"
format:
	opa fmt -w $(shell find . -name "*.rego" -type f)
inspect:
	opa inspect ./bundles/bundle.tar.gz --annotations --format json
server:
	opa run --bundle ./bundles/bundle.tar.gz --server --config-file ./config/tfc.yaml --log-format json-pretty --log-level debug