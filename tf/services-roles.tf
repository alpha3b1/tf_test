
# ----------------------
# ECS Cluster
# ----------------------
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.app}-${var.env}"
}

# --------------
# ECS Execution role
# -------------
data "aws_iam_policy_document" "ecs_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_exec_role" {
  name               = "ecs-task-exec-role-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
}

resource "aws_iam_policy" "task_exec_policy" {
  name        = "ECSRegistryAuth"
  description = "Permissions required by ${var.app} to get ECR image"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt",
        "ssm:GetParameters",
        "secretsmanager:GetSecretValue",
        "logs:CreateLogGroup"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

data "aws_iam_policy" "task_exec_policy" {
  name = "AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.ecs_task_exec_role.name
  policy_arn = data.aws_iam_policy.task_exec_policy.arn
}

resource "aws_iam_role_policy_attachment" "secrets_access" {
  role       = aws_iam_role.ecs_task_exec_role.name
  policy_arn = aws_iam_policy.task_exec_policy.arn
}


# -----------------------
# Task role
# -----------------------

resource "aws_iam_policy" "task_role_policy" {
  name        = "ecs-task-exec-${var.app}-${var.env}"
  description = "Permissions required by ${var.app} ecs task exec"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "TaskRolePerms",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue",
                "secretsmanager:ListSecrets"
            ],
            "Resource": "*"
        },
        {
          "Effect": "Allow",
          "Action": [
            "ssmmessages:CreateControlChannel",
            "ssmmessages:CreateDataChannel",
            "ssmmessages:OpenControlChannel",
            "ssmmessages:OpenDataChannel"
          ],
          "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": "${aws_s3_bucket.this.arn}"
        }
    ]
}
EOF
}


resource "aws_iam_role" "ecs_task_role" {
  name               = "ecs-task-role-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
}


resource "aws_iam_role_policy_attachment" "ecs_policy_attach" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.task_role_policy.arn
}


