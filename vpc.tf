resource "aws_vpc" "lab_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name       = local.vpc_name
    Managed_by = local.managed_by_tag
  }
}

resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.lab_vpc.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name       = "${terraform.workspace}-public-subnet-${count.index + 1}"
    Managed_by = local.managed_by_tag
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.lab_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name       = "${terraform.workspace}-private-subnet-${count.index + 1}"
    Managed_by = local.managed_by_tag
  }
}

#Internet Gateway (IGW)
resource "aws_internet_gateway" "labigw" {
  vpc_id = aws_vpc.lab_vpc.id

  tags = {
    Name       = "${terraform.workspace}-igw"
    Managed_by = local.managed_by_tag
  }
}

#NAT Public Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name       = "${terraform.workspace}-eip"
    Managed_by = local.managed_by_tag
  }
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name       = "${terraform.workspace}-nat"
    Managed_by = local.managed_by_tag
  }
}