provider "aws" {
  region = var.aws-region
}


#IAM Role for EKS Cluster

resource "aws_iam_role" "eks_cluster" {
  name = var.cluster-role-name

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",  
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {  
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


#IAM Policy for EKS Cluster

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}
resource "aws_iam_role_policy_attachment" "AutoScaling" {
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster.name
}


#Cluster creation

resource "aws_eks_cluster" "aws_eks" {
  name     = var.cluster-name
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = var.subnet_id
  }

  tags = {
    Owner       = "surendar"
    Description = "insider"
  }
}
