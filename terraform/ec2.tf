resource "aws_instance" "instance" {
  count                  = local.LENGTH  #no of values are 10 so using length function it automatically create 10 insatnces
  ami                    = "ami-074df373d6bafa625"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-0d4eef67aaa1df62d"]

  tags                   = {
    Name                 = element(var.COMPONENTS, count.index) # i want to pick the value from the above count and keep it in the name tag. by using element function with index number
  }
}

resource "aws_route53_record" "records" {
  count                 = local.LENGTH
  name                  = element(var.COMPONENTS, count.index)
  type                  = "A"
  zone_id               = "Z0503812D1634TD1MLB0"
  ttl                   = 300
  records               = [element(aws_instance.instance.*.private_ip, count.index)]
}

locals {
  LENGTH             = length(var.COMPONENTS)
}

#COMPONENTS = ["mysql", "mongodb", "rabbitmq", "redis", "cart", "user", "catalogue", "shipping", "payment", "fr
resource "local_file" "inv-file" {
  content     = "[FRONTEND]\n${aws_instance.instance.*.private_ip[9]}\n[PAYMENT]\n${aws_instance.instance.*
  .private_ip[8]}\n[SHIPPING]\n${aws_instance.instance.*.private_ip[7]}\n[CATALOGUE]\n${aws_instance.instance.*
  .private_ip[6]}\n[USER]\n${aws_instance.instance.*.private_ip[5]}\n[CART]\n${aws_instance.instance.*
  .private_ip[4]}\n[REDIS]\n${aws_instance.instance.*.private_ip[3]}\n[RABBITMQ]\n${aws_instance.instance.*
  .private_ip[2]}\n[MONGODB]\n${aws_instance.instance.*.private_ip[1]}\n[MYSQL]\n${aws_instance.instance.*
  .private_ip[0]}\n"
  filename = "/tmp/inv-roboshop-${var.ENV}"
}