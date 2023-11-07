resource "aws_ecr_repository" "org_test" {
  name                 = "org_test"
  image_tag_mutability = "MUTABLE"

}
