# null-tester

This module checks during the plan step whether a non-null, or possibly non-null, input value was provided.

This is extremely useful when using a conditional count value for a resource in a module, where the presence of an input variable is used to determine whether a resource should be created. Normally, this can only be done if the value of that input variable is known during the plan step; this module allows you to use that same pattern even if the input value isn't known until the apply step.

## Usage

For a sample use case, consider the scenario where you have a module that needs a random string for internal use. We want to have an option for the random string to be externally generated and passed as an input variable. If no string is passed as an input, it should generate a new random string internally.

Your external (calling) file might look like this:

```
resource "random_string" "external" {
  length = 16
}

// Use the demo module, where an externally generated value IS provided
module "existing" {
  source                 = "./demo"
  existing_random_string = random_string.external.result
}

// Use the demo module, where an externally generated value IS NOT provided
module "non_existing" {
  source                 = "./demo"
}
```

### Problem

For the module, you might initially try something like this:

```
variable "existing_random_string" {
  type    = string
  default = null
}

// If the input variable is `null` (no external value provided), generate a value internally.
resource "random_string" "internal" {
  count  = var.existing_random_string == null ? 1 : 0
  length = 16
}

// Do something with the random string value (the external one if an external one was provided, or
// the internal one if no external one was provided).
output "random_string" {
  value = var.existing_random_string != null ? var.existing_random_string : random_string.internal[0].result
}
```

Unfortunately, we get an error because whether or not the input variable is `null` isn't known during the plan step, and therefore the `count` of the `random_string` resource isn't known during the plan step.

```
│ Error: Invalid count argument
│
│   on demo\main.tf line 8, in resource "random_string" "internal":
│    8:   count  = var.existing_random_string == null ? 1 : 0
│
│ The "count" value depends on resource attributes that cannot be determined until apply, so Terraform cannot predict how many instances will be created. To work around this, use the -target argument to first    
│ apply only the resources that the count depends on.
```

This module solves this problem.

This module was derived from https://registry.terraform.io/modules/Invicton-Labs/input-provided/null/latest