resource "aws_security_group" "eks_cluster" {
  name        = "eks"
  description = "EKS cluster traffic"
  vpc_id      = aws_vpc.org.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    //    cidr_blocks      = [aws_vpc.org.cidr_block]
    //    ipv6_cidr_blocks = [aws_vpc.org.ipv6_cidr_block]
    //    prefix_list_ids  = ""
    //    security_groups  = ""
    //    self             = ""
  }

  ingress {
    description = "EKS"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    //    cidr_blocks      = [aws_vpc.org.cidr_block]
    //    ipv6_cidr_blocks = [aws_vpc.org.ipv6_cidr_block]
    //    prefix_list_ids  = ""
    //    security_groups  = ""
    //    self             = ""
  }

  # TODO restrict traffic to AWS ranges https://ip-ranges.amazonaws.com/ip-ranges.json for ECR and S3
  egress {
    description      = "Allow all"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    //    prefix_list_ids  = ""
    //    security_groups  = ""
    //    self             = ""
  }

  tags = {
    Name = "eks_cluster"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.org.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.org.cidr_block]
    //    ipv6_cidr_blocks = [aws_vpc.org.ipv6_cidr_block]
    //    prefix_list_ids  = ""
    //    security_groups  = ""
    //    self             = ""
  }

  egress {
    description      = "Allow all"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    //    prefix_list_ids  = ""
    //    security_groups  = ""
    //    self             = ""
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.org.id

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.org.cidr_block]
    //    ipv6_cidr_blocks = [aws_vpc.org.ipv6_cidr_block]
    //    prefix_list_ids  = ""
    //    security_groups  = ""
    //    self             = ""
  }

  //  egress {
  //    description      = "Allow all"
  //    from_port        = 0
  //    to_port          = 0
  //    protocol         = "-1"
  //    cidr_blocks      = ["0.0.0.0/0"]
  //    ipv6_cidr_blocks = ["::/0"]
  ////    prefix_list_ids  = ""
  ////    security_groups  = ""
  ////    self             = ""
  //  }

  tags = {
    Name = "allow_ssh"
  }
}
