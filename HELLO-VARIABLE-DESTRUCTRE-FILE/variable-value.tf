output printname {

    value = "Hello, ${var.username}"
}

# RUN
# terraform plan -var "username=Sapan Mohanty"
# run it non interactive mode define the variable