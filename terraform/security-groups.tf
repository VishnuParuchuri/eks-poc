# ----------------------------------------
# EKS Cluster Security Group
# ----------------------------------------
resource "aws_security_group" "eks_cluster_sg" {
  name        = "eks-cluster-sg"
  description = "Security group for EKS control plane"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "eks-cluster-sg"
  }
}

# ----------------------------------------
# Worker Node Security Group
# ----------------------------------------
resource "aws_security_group" "eks_node_sg" {
  name        = "eks-node-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "eks-node-sg"
  }
}

# ----------------------------------------
# Allow Worker Nodes to Communicate
# ----------------------------------------
resource "aws_security_group_rule" "node_to_node" {
  description              = "Allow worker nodes to communicate with each other"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_node_sg.id
  source_security_group_id = aws_security_group.eks_node_sg.id
}

# ----------------------------------------
# Allow Cluster Control Plane to Talk to Nodes
# ----------------------------------------
resource "aws_security_group_rule" "cluster_to_node" {
  description              = "Allow EKS control plane to communicate with worker nodes"
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_node_sg.id
  source_security_group_id = aws_security_group.eks_cluster_sg.id
}

# ----------------------------------------
# Node Outbound Internet Access (Required for Image Pulls)
# ----------------------------------------
# tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "node_egress" {
  description       = "Allow outbound internet access for nodes"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.eks_node_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}
