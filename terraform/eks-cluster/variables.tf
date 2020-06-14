variable "aws-region" {
  default = "us-west-2"
}

variable "cluster-role-name" {
  default = "insider-cluster-role"
}

variable "cluster-name" {
  default = "insider-cluster-demo"
}

variable "worker-node-name" {
  default = "insider-workernode-role"
}

variable "node_group_name" {
  default = "insider-workernode-group"
}

variable "subnet_id" {
  type    = list(string)
  default = ["subnet-98e123e0", "subnet-a358b4e9"]
}

variable "sg-worker-node" {
  default = "worker_node_sg"
}

variable "vpc-id" {
  default = "vpc-77addc0f"
}


variable "instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "disk_size" {
  default = "30"
}

variable "ec2_ssh_key" {
  default = "insider"
}
variable "ami_type" {
  default = "AL2_x86_64"
}