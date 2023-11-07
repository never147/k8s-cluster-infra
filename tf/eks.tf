resource "aws_eks_cluster" "org" {
  name     = "org"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    //endpoint_private_access = false
    //endpoint_public_access = true
    //public_access_cidrs = 0.0.0.0/0
    //    security_group_ids = [aws_security_group.eks_cluster.id]
    subnet_ids = aws_subnet.eks_cluster[*].id
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.org-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.org-AmazonEKSVPCResourceController,
  ]
}

resource "aws_eks_node_group" "org" {
  cluster_name    = aws_eks_cluster.org.name
  node_group_name = "eks_node_group"
  node_role_arn   = aws_iam_role.eks_node_group.arn
  subnet_ids      = aws_subnet.eks_node_group[*].id

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  remote_access {
    ec2_ssh_key               = aws_key_pair.admin.key_name
    source_security_group_ids = [aws_security_group.allow_ssh.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.org-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.org-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.org-AmazonEC2ContainerRegistryReadOnly,
  ]
}
