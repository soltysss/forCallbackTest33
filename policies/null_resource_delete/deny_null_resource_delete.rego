package terraform

import rego.v1

# Artificial delay function
delay(n) = true if {
    count([x | x := 1..n]) > 0
}

deny[reason] if {
  resource := input.tfplan.resource_changes[_]
  action := resource.change.actions[count(resource.change.actions) - 1]

  resource.type == "null_resource"
  action == "delete"
  # Introduce a delay loop
  delay(1000000)  # Adjust this number to control the delay duration

  reason := sprintf(
   "Confirm the deletion of the null_resource %q",
   [resource.address],
  )
}
