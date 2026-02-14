resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = "arn:aws:iam::361509912577:role/eks-cluster-role-pvn"

  vpc_config {
    subnet_ids = [
      aws_subnet.private_1.id,
      aws_subnet.private_2.id
    ]

    security_group_ids = [
      aws_security_group.eks_cluster_sg.id
    ]
  }
} 