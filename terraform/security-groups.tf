
resource "aws_security_group" "protein-bitirme-projesi-sg" {
  name_prefix = "protein-bitirme-projesi-sg"
  vpc_id      = module.vpc.vpc_id

    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/16","0.0.0.0/0",
    ]
  }
}

