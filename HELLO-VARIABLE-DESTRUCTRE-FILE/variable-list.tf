output printfirst{

    value = "first user is ${var.users[0]}"
}

output printSeconde{

    value = "${join("-->", var.users)}"
}

output printThird{

    value = "${upper(var.users[0])}"
}



# input > ["sapan" ,"priyanka" ,"paltu"]
# it's useful, when you create ec2 instance and allow multiple security groups