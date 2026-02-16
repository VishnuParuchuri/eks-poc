# ----------------------------------------
# KMS Key for EKS Secret Encryption
# ----------------------------------------
resource "aws_kms_key" "eks" {
  description             = "KMS key for EKS secret encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

# ----------------------------------------
# EKS Cluster
# ----------------------------------------
resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = "arn:aws:iam::361509912577:role/eks-cluster-role-pvn"

  # Enable control plane logging
  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  # Enable secret encryption
  encryption_config {
    provider {
      key_arn = aws_kms_key.eks.arn
    }

    resources = ["secrets"]
  }

  vpc_config {
    subnet_ids = [
      aws_subnet.private_1.id,
      aws_subnet.private_2.id
    ]

    security_group_ids = [
      aws_security_group.eks_cluster_sg.id
    ]

    # 🔐 Balanced Secure Configuration
    endpoint_public_access  = true
    endpoint_private_access = true

    # 👇 REPLACE WITH YOUR ACTUAL PUBLIC IP
    public_access_cidrs = ["136.226.253.75/32"]
  }

  depends_on = [
    aws_kms_key.eks
  ]
}
