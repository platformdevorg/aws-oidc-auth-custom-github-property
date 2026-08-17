
data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${var.account_id}:oidc-provider/token.actions.githubusercontent.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # Scoped to any repo in the org with the custom property team_id assigned to the repo. Any branch, any environment.
    # Allows multiple repos to share the same OIDC role as long as they are owned by a specific team.

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_org}@${var.github_org_id}/*:repo_property_team_id:${var.github_team_id}"]
    }
  }
}


resource "aws_iam_role" "github_actions_deploy" {
  name               = "${var.project_name}-github-oidc-role"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json
}


data "aws_iam_policy_document" "s3_readonly" {
  statement {
    sid    = "S3BucketReadOnly"
    effect = "Allow"

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketVersions",
    ]

    resources = ["arn:aws:s3:::my-sample-bucket"]
  }

  statement {
    sid    = "S3ObjectReadOnly"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectAttributes",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionAttributes",
    ]

    resources = ["arn:aws:s3:::my-sample-bucket/*"]
  }
}


resource "aws_iam_role_policy" "github_actions_deploy_s3_readonly" {
  name   = "${var.project_name}-s3-readonly"
  role   = aws_iam_role.github_actions_deploy.id
  policy = data.aws_iam_policy_document.s3_readonly.json
}
