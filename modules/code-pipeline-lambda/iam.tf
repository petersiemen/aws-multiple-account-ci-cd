resource "aws_iam_role" "codepipeline-role" {
  name = "${local.code_pipeline_name}-service-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "codepipeline-policy" {
  name = "${local.code_pipeline_name}-policy"
  role = aws_iam_role.codepipeline-role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": ["kms:*"],
      "Resource": "*"
    },
    {
      "Action": [
        "iam:PassRole"
      ],
      "Resource": "*",
      "Effect": "Allow",
      "Condition": {
        "StringEqualsIfExists": {
          "iam:PassedToService": [
            "cloudformation.amazonaws.com"
          ]
        }
      }
    },
    {
      "Effect":"Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${var.code_build_artifacts_arn}",
        "${var.code_build_artifacts_arn}/*"
      ]
    },
    {
      "Action": [
        "codecommit:CancelUploadArchive",
        "codecommit:GetBranch",
        "codecommit:GetCommit",
        "codecommit:GetUploadArchiveStatus",
        "codecommit:UploadArchive",
        "codecommit:GitPull"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Effect": "Allow",
      "Resource": [
          "*"
      ],
      "Action": [
          "codecommit:GitPull"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudformation:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "sts:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

//
//resource "aws_iam_role" "codepipeline-deploy-role" {
//  name = "${local.code_pipeline_name}-deploy-role"
//
//  assume_role_policy = <<EOF
//{
//  "Version": "2012-10-17",
//  "Statement": [
//    {
//      "Action": "sts:AssumeRole",
//      "Principal": {
//        "Service": "cloudformation.amazonaws.com"
//      },
//      "Effect": "Allow"
//    }
//  ]
//}
//EOF
//}
//
//
//resource "aws_iam_role_policy" "deploy-policy" {
//  name = "${local.code_pipeline_name}-deploy-policy"
//  role = aws_iam_role.codepipeline-deploy-role.id
//
//  policy = <<-EOF
//{
//  "Version": "2012-10-17",
//  "Statement": [
//    {
//          "Effect": "Allow",
//          "Action": [
//              "logs:*"
//          ],
//          "Resource": "arn:aws:logs:*:*:*"
//      },
//      {
//          "Effect": "Allow",
//          "Action": [
//              "s3:GetObject",
//              "s3:PutObject"
//          ],
//          "Resource": "arn:aws:s3:::*"
//      },
//      {
//          "Action": [
//              "apigateway:*",
//              "codedeploy:*",
//              "lambda:*",
//              "cloudformation:CreateChangeSet",
//              "iam:GetRole",
//              "iam:CreateRole",
//              "iam:DeleteRole",
//              "iam:PutRolePolicy",
//              "iam:AttachRolePolicy",
//              "iam:DeleteRolePolicy",
//              "iam:DetachRolePolicy",
//              "iam:PassRole",
//              "s3:GetObject",
//              "s3:GetObjectVersion",
//              "s3:GetBucketVersioning"
//          ],
//          "Resource": "*",
//          "Effect": "Allow"
//      }
//  ]
//}
//EOF
//}
//
//resource "null_resource" "foo" {
//  triggers {
//    interpreter = var.local_exec_interpreter
//  }
//  provisioner {
//    when = destroy
//
//    interpreter = self.triggers.interpreter
//    ...
//  }
//}