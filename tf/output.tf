
output "eks-endpoint" {
  value = aws_eks_cluster.org.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.org.certificate_authority[0].data
}

output "registry" {
  value = aws_ecr_repository.org_test.repository_url
}