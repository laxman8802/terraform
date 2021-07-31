#creat the vpc

resource "aws_vpc" "petclinic" {
  cidr_block       = var.cidr
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = "${var.envname}"
  }
}

#subnets

resource "aws_subnet" "pubsubnet" {
  count = length(var.azs)
  vpc_id     = aws_vpc.petclinic.id
  cidr_block = element(var.pubsubnets,count.index) #"10.1.0.0/24"
  availability_zone = element(var.azs,count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.envname}-pubsubnet"
  }
}


resource "aws_subnet" "privatesubnet" {
  count = length(var.azs)
    vpc_id     = aws_vpc.petclinic.id
    cidr_block = element(var.privatesubnets,count.index) #"10.1.3.0/24"
    availability_zone = element(var.azs,count.index)

  tags = {
    Name = "${var.envname}-privatesubnet"
  }
}


resource "aws_subnet" "datasubnet" {
    count = length(var.azs)
    vpc_id     = aws_vpc.petclinic.id
    cidr_block = element(var.datasubnets,count.index) #"10.1.6.0/24"
    availability_zone = element(var.azs,count.index)

  tags = {
    Name = "${var.envname}-datasubnet"
  }
}


#igw & vpc

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.petclinic.id

  tags = {
    Name = "${var.envname}-igw"
  }
}

#eip
resource "aws_eip" "nat-ip" {

  vpc      = true
  tags = {
    Name = "${var.envname}-nat-ip"
  }
  
}

#nat-gw in pubsubnet
resource "aws_nat_gateway" "NatGw" {
  allocation_id = aws_eip.nat-ip.id
  subnet_id     = aws_subnet.pubsubnet[0].id

  tags = {
    Name = "${var.envname}-nat-ip"
  }

}

#route tables

resource "aws_route_table" "publicroute" {
  vpc_id = aws_vpc.petclinic.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }


   tags = {
    Name = "${var.envname}-publicroute"
  }

}

resource "aws_route_table" "privateroute" {
  vpc_id = aws_vpc.petclinic.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NatGw.id
  }


   tags = {
    Name = "${var.envname}-privateroute"
  }

}


resource "aws_route_table" "dataroute" {
  vpc_id = aws_vpc.petclinic.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NatGw.id
  }


   tags = {
    Name = "${var.envname}-dataroute"
  }

}

#association in route tables

resource "aws_route_table_association" "publicassociation" {
  count = length (var.pubsubnets)
  subnet_id      = element(aws_subnet.pubsubnet.*.id,count.index)
  route_table_id = aws_route_table.publicroute.id
}

resource "aws_route_table_association" "privateassociation" {
  count = length (var.privatesubnets)
  subnet_id      = element(aws_subnet.privatesubnet.*.id,count.index)
  route_table_id = aws_route_table.privateroute.id
}


resource "aws_route_table_association" "dataassociation" {
  count = length (var.datasubnets)
  subnet_id      = element(aws_subnet.datasubnet.*.id,count.index)
  route_table_id = aws_route_table.dataroute.id
}
