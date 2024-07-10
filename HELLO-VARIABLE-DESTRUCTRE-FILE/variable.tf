variable "username" {
    type = string
    # default = "sapan"  # Optional default value
    # description = "The username of the person"  # Optional description
}

variable "users" {
    type    = list(string)
    default = ["sapan", "priyanka", "paltu"]
}
