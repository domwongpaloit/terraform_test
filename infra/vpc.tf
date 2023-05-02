module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-lambda-vpc-${var.stage}"
  cidr = "10.0.0.0/25"

  azs             = ["us-east-1a"]
  private_subnets = ["10.0.0.32/28"]
  public_subnets  = ["10.0.0.0/28"]

  enable_nat_gateway = true
  create_igw         = true

  tags = {
    Terraform = "true"
    stage     = "${var.stage}"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls-${var.stage}"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [module.vpc.vpc_cidr_block]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
