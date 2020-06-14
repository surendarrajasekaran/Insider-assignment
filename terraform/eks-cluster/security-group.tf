resource "aws_security_group" "sg_worker_node" {
  name        = var.sg-worker-node
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc-id

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #it should not be open to internet. it should be specific range.description
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-insider-worker-node"
  }
}
