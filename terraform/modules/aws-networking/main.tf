resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_hostnames = "true"
  # provides an internal host name
  tags = {
    Name = var.project_name
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "private" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index * 2)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.project_name}_private-${data.aws_availability_zones.available.names[count.index]}"
  }
}

resource "aws_subnet" "public" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index * 2 + 1)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}_public-${data.aws_availability_zones.available.names[count.index]}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.project_name}_igw"
  }
}

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.project_name}_rt_public"
  }
}

resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.vpc.id

  route = []
  tags = {
    Name = "${var.project_name}_rt_private"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.rt_private.id
}

# setting the route table to be the main one
resource "aws_main_route_table_association" "public_main" {
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_network_acl" "private" {
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.vpc.cidr_block
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.vpc.cidr_block
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${var.project_name}_nacl_private"
  }
}

resource "aws_network_acl" "public" {
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = [for subnet in aws_subnet.public : subnet.id]

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${var.project_name}_nacl_public"
  }
}
