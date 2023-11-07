resource "aws_vpc" "org" {
  cidr_block = var.vpc_net
  tags = {
    Name = "org network"
  }
}

locals {
  reserved_net    = cidrsubnet(var.vpc_net, 4, 0)
  eks_cluster_net = cidrsubnet(var.vpc_net, 4, 1)
  eks_node_net    = cidrsubnet(var.vpc_net, 4, 2)
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.org.id
  tags = {
    Name = "default gw"
  }
}

resource "aws_eip" "nat_gw" {}

resource "aws_nat_gateway" "default" {
  allocation_id = aws_eip.nat_gw.id
  subnet_id     = aws_subnet.network_infra.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.default]
}

resource "aws_route_table_association" "vpc_default" {
  subnet_id      = aws_subnet.network_infra.id
  route_table_id = aws_route_table.default.id
}

resource "aws_route_table_association" "eks_cluster" {
  count = length(aws_subnet.eks_cluster)

  subnet_id      = aws_subnet.eks_cluster[count.index].id
  route_table_id = aws_route_table.default.id
}

resource "aws_route_table_association" "eks_node_group" {
  count = length(aws_subnet.eks_node_group)

  subnet_id      = aws_subnet.eks_node_group[count.index].id
  route_table_id = aws_route_table.default.id
}

resource "aws_route_table" "default" {
  vpc_id = aws_vpc.org.id

  route = [
    {
      cidr_block = "0.0.0.0/0"
      #ipv6_cidr_block           = ""
      gateway_id                 = ""
      egress_only_gateway_id     = ""
      instance_id                = ""
      nat_gateway_id             = aws_nat_gateway.default.id
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_peering_connection_id  = ""
      carrier_gateway_id         = ""
      destination_prefix_list_id = ""
      ipv6_cidr_block            = ""
      local_gateway_id           = ""
      vpc_endpoint_id            = ""
    }
  ]

  tags = {
    Name = "default"
  }
}

resource "aws_subnet" "network_infra" {
  cidr_block = cidrsubnet(local.reserved_net, 4, 1)
  vpc_id     = aws_vpc.org.id

  tags = {
    Name = "network_infra"
  }
}

resource "aws_subnet" "eks_cluster" {
  count = length(data.aws_availability_zones.available.names)

  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.org.id
  cidr_block        = cidrsubnet(local.eks_cluster_net, 4, count.index)

  tags = {
    Name = "eks1"
  }
}

resource "aws_subnet" "eks_node_group" {
  count = length(data.aws_availability_zones.available.names)

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet(local.eks_node_net, 4, count.index)
  vpc_id            = aws_vpc.org.id

  tags = {
    "kubernetes.io/cluster/${aws_eks_cluster.org.name}" = "shared"
  }
}