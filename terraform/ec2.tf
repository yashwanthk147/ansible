resource "aws_instance" "instance" {
  count                  = local.LENGTH  #no of values are 10 so using length function it automatically create 10 insatnces
  ami                    = "ami-074df373d6bafa625"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-0d4eef67aaa1df62d"]

  tags                   = {
    Name                 = element(var.COMPONENTS, count.index)   # i want to pick the value from the above count and keep it in the name tag. by using element function with index number
  }
}

resource "aws_route53_record" "records" {
  count                 = local.LENGTH
  name                  = element(var.COMPONENTS, count.index )
  type                  = "A"
  zone_id               = "Z0503812D1634TD1MLB0"
  ttl                   = 300
  records               = [element(aws_instance.instance.*.private_ip, count.index)]
}

locals {
  LENGTH             = length(var.COMPONENTS)
}