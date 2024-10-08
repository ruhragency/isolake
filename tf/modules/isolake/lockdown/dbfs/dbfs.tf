// Restrictive Bucket Policy
resource "aws_s3_bucket_policy" "databricks_bucket_restrictive_policy" {
  bucket = var.dbfsname
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "Grant Databricks Read Access",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::414351767826:root"
        },
        Action = "s3:*"
        Resource = [
          "arn:aws:s3:::${var.dbfsname}/*",
          "arn:aws:s3:::${var.dbfsname}"
        ]
      },
      {
        Sid    = "Grant Databricks Write Access",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::414351767826:root"
        },
        Action = "s3:*"
        Resource = [
          "arn:aws:s3:::${var.dbfsname}/${var.full_region_name}-prod/0_databricks_dev",
          "arn:aws:s3:::${var.dbfsname}/ephemeral/${var.full_region_name}-prod/${var.workspace_id}/*",
          "arn:aws:s3:::${var.dbfsname}/${var.full_region_name}-prod/${var.workspace_id}.*/*",
          "arn:aws:s3:::${var.dbfsname}/${var.full_region_name}-prod/${var.workspace_id}/databricks/init/*/*.sh",
          "arn:aws:s3:::${var.dbfsname}/${var.full_region_name}-prod/${var.workspace_id}/user/hive/warehouse/*.db/",
          "arn:aws:s3:::${var.dbfsname}/${var.full_region_name}-prod/${var.workspace_id}/user/hive/warehouse/*.db/*-*",
          "arn:aws:s3:::${var.dbfsname}/${var.full_region_name}-prod/${var.workspace_id}/user/hive/warehouse/*__PLACEHOLDER__/",
          "arn:aws:s3:::${var.dbfsname}/${var.full_region_name}-prod/${var.workspace_id}/user/hive/warehouse/*.db/*__PLACEHOLDER__/",
          "arn:aws:s3:::${var.dbfsname}/${var.full_region_name}-prod/${var.workspace_id}/FileStore/*",
          "arn:aws:s3:::${var.dbfsname}/${var.full_region_name}-prod/${var.workspace_id}/databricks/mlflow/*",
          "arn:aws:s3:::${var.dbfsname}/${var.full_region_name}-prod/${var.workspace_id}/databricks/mlflow-*/*",
          "arn:aws:s3:::${var.dbfsname}/${var.full_region_name}-prod/${var.workspace_id}/mlflow-*/*",
          "arn:aws:s3:::${var.dbfsname}/${var.full_region_name}-prod/${var.workspace_id}/pipelines/*",
          "arn:aws:s3:::${var.dbfsname}/${var.full_region_name}-prod/${var.workspace_id}/local_disk0/tmp/*",
          "arn:aws:s3:::${var.dbfsname}/${var.full_region_name}-prod/${var.workspace_id}/tmp/*"
        ]
      },
      {
        Sid       = "AllowSSLRequestsOnly",
        Effect    = "Deny",
        Action    = "s3:*",
        Principal = "*",
        Resource = [
          "arn:aws:s3:::${var.dbfsname}/*",
          "arn:aws:s3:::${var.dbfsname}"
        ],
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}