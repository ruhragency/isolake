module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name = "${var.resource_prefix}-data-plane-VPC"
  cidr = var.vpc_cidr_range
  azs  = var.availability_zones

  enable_dns_hostnames   = true
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  create_igw             = true

  public_subnets      = var.public_subnets_cidr
  public_subnet_names = [for az in var.availability_zones : format("%s-public-%s", var.resource_prefix, az)]
  private_subnets      = var.private_subnets_cidr
  private_subnet_names = [for az in var.availability_zones : format("%s-private-%s", var.resource_prefix, az)]

}

data "aws_prefix_list" "s3" {
  filter {
    name   = "prefix-list-name"
    values = ["com.amazonaws.${var.region}.s3"]
  }
}


// SG
resource "aws_security_group" "sg" {

  vpc_id     = module.vpc.vpc_id
  depends_on = [module.vpc]

  dynamic "ingress" {
    for_each = var.sg_ingress_protocol
    content {
      from_port = 0
      to_port   = 65535
      protocol  = ingress.value
      self      = true
    }
  }

  # Ingress rule for OpenVPN traffic from Hetzner VPN server
  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["116.203.199.21/32"]  # Hetzner VPN server's public IP
  }

  dynamic "egress" {
    for_each = var.sg_egress_protocol
    content {
      from_port = 0
      to_port   = 65535
      protocol  = egress.value
      self      = true
    }
  }

  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = [data.aws_prefix_list.s3.id]
  }

  # Allow outbound HTTPS traffic to any IP
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # This allows outbound HTTPS to any IP address
  }

  # Optional: Allow outbound HTTP traffic if needed
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule for OpenVPN to Hetzner VPN server
  egress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["116.203.199.21/32"]  # Hetzner VPN server's public IP
  }

  tags = {
    Name = "${var.resource_prefix}-data-plane-sg"
  }
}