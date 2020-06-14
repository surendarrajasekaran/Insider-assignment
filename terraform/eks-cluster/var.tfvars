encrypt        = true
bucket         = "tfremote-state-bucket"
key            = "eks-cluster/terraform.tfstate"
region         = "us-west-2"
dynamodb_table = "terraform_locks"
