resource "aws_iam_role" "github_actions_role" {
  name = "GithubActionsRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::${var.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"
      }
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          "token.actions.githubusercontent.com:sub" = "repo:${var.github_repository}:ref:refs/heads/main"
        }
      }
    }]
  })

  tags = {
    terraform = ""
    deploy    = ""
  }
}

resource "aws_iam_role_policy_attachment" "policy_attachments" {
  count      = length(var.git_actions_policies)
  role       = aws_iam_role.github_actions_role.name
  policy_arn = var.git_actions_policies[count.index]
}
