variable "userage" {
    type    = map(number)
    default = {
        sapan    = 20
        priyanka = 19
    }
}

variable "username" {
    type = string
    # default = "sapan"  # Optional default value
}

output "userage" {
    value = "my name is ${var.username} and my age is ${lookup(var.userage, var.username)}"
}
