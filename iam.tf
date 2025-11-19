# ------------------------------------------------
# 1. IAM ロール (インラインポリシーを含まない定義)
# ------------------------------------------------
resource "aws_iam_role" "minecraft_auto_stop_role" {
  name = "MinecraftAutoStopRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  # ★ 警告解消のため、inline_policy ブロックを削除しました ★
  
  # AWS側の description を削除するために null を明記
  description = null 
}

# ------------------------------------------------
# 1-2. IAM ロールポリシー (インラインポリシーを分離)
# ------------------------------------------------
# 警告解消のための新しいリソース
resource "aws_iam_role_policy" "minecraft_auto_stop_policy" {
  # 以前 inline_policy で指定していた名前を設定します
  name = "SelfStopPolicy" 
  
  # どのロールに適用するかを指定します
  role = aws_iam_role.minecraft_auto_stop_role.id 

  # 以前 inline_policy で定義していたポリシーの中身を設定します
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowSelfStopAndDescribe"
        Effect = "Allow"
        Action = [
          "ec2:StopInstances",
          "ec2:DescribeInstances",
        ]
        # Resource はそのままコピーします
        Resource = [
          "arn:aws:ec2:${var.aws_region}:290321162221:instance/${var.minecraft_instance_id}",
        ]
      },
    ]
  })
}

# ------------------------------------------------
# 2. IAM インスタンスプロファイル (変更なし)
# ------------------------------------------------
resource "aws_iam_instance_profile" "minecraft_auto_stop_profile" {
  name = aws_iam_role.minecraft_auto_stop_role.name
  role = aws_iam_role.minecraft_auto_stop_role.name 
  path = "/"
}