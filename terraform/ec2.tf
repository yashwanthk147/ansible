resource "aws_instance" "app-instance" {
  count                  = length(var.APP_COMPONENTS)   #no of values are 10 so using length function it automatically create 10 insatnces
  ami                    = "ami-074df373d6bafa625"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-0d4eef67aaa1df62d"]

  tags                   = {
    Name                 = "${element(var.APP_COMPONENTS, count.index)}-${var.ENV}"
    Monitor              = "yes"          # i want to pick the value from the above count and keep it in the name tag. by using element function with index number
  }
}

resource "aws_instance" "db-instance" {
  count                  = length(var.DB_COMPONENTS) #no of values are 10 so using length function it automatically create 10 insatnces
  ami                    = "ami-074df373d6bafa625"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-0d4eef67aaa1df62d"]

  tags                   = {
    Name                 = "${element(var.DB_COMPONENTS, count.index)}-${var.ENV}" # i want to pick the value from the above count and keep it in the name tag. by using element function with index number
  }
}


resource "aws_route53_record" "app-records" {
  count                 = length(var.APP_COMPONENTS)
  name                  = "${element(var.APP_COMPONENTS, count.index)}-${var.ENV}"
  type                  = "A"
  zone_id               = "Z0503812D1634TD1MLB0"
  ttl                   = 300
  records               = [element(aws_instance.app-instance.*.private_ip, count.index)]
}

resource "aws_route53_record" "db-records" {
  count                 = length(var.DB_COMPONENTS)
  name                  = "${element(var.DB_COMPONENTS, count.index)}-${var.ENV}"
  type                  = "A"
  zone_id               = "Z0503812D1634TD1MLB0"
  ttl                   = 300
  records               = [element(aws_instance.db-instance.*.private_ip, count.index)]
}

locals{
  COMPONENTS = concat(aws_instance.db-instance.*.private_ip, aws_instance.app-instance.*.private_ip)
}


#COMPONENTS = ["mysql", "mongodb", "rabbitmq", "redis", "cart", "user", "catalogue", "shipping", "payment", "fr
resource "local_file" "inv-file" {
  content     = "[FRONTEND]\n${local.COMPONENTS[9]}\n[PAYMENT]\n${local.COMPONENTS[8]}\n[SHIPPING]\n${local.COMPONENTS[7]}\n[CATALOGUE]\n${local.COMPONENTS[6]}\n[USER]\n${local.COMPONENTS[5]}\n[CART]\n${local.COMPONENTS[4]}\n[REDIS]\n${local.COMPONENTS[3]}\n[RABBITMQ]\n${local.COMPONENTS[2]}\n[MONGODB]\n${local.COMPONENTS[1]}\n[MYSQL]\n${local.COMPONENTS[0]}\n"
  filename = "/tmp/inv-roboshop-${var.ENV}"
}