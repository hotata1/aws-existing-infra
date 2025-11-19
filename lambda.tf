# ------------------------------------------------
# 1. Lambda 実行ロールの定義
# ------------------------------------------------
resource "aws_iam_role" "lambda_exec_role" {
  name               = "minecraft-start-server-line-role" 
  
  # 破壊的変更を防ぐため、既存のパスを明示的に指定
  path               = "/service-role/" # 👈 この行を追加/修正
  
  # 必須引数: 信頼ポリシー (Lambda serviceがこのロールを引き受けることを許可)
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

# ------------------------------------------------
# 1-1. インラインポリシーの定義 (EC2 Start/Describe/Tag)
# ------------------------------------------------
resource "aws_iam_role_policy" "ec2_minecraft_access" {
  name   = "EC2StartAccessForMinecraft"
  role   = aws_iam_role.lambda_exec_role.name
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowInstanceStart"
        Effect = "Allow"
        Action = "ec2:StartInstances"
        # 既存の値: arn:aws:ec2:ap-northeast-1:290321162221:instance/i-0888bb6c78420b9c5 を変数に置き換え
        Resource = "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:instance/${var.minecraft_instance_id}"
      },
      {
        Sid    = "AllowInstanceDescribe"
        Effect = "Allow"
        Action = "ec2:DescribeInstances"
        Resource = "*"
      },
      {
        Sid    = "AllowTagOperationsOnMinecraftInstance"
        Effect = "Allow"
        Action = [
          "ec2:CreateTags",
          "ec2:DeleteTags",
        ]
        # 既存の値: arn:aws:ec2:ap-northeast-1:290321162221:instance/i-0888bb6c78420b9c5 を変数に置き換え
        Resource = "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:instance/${var.minecraft_instance_id}"
      },
    ]
  })
}

# ------------------------------------------------
# 1-2. マネージドポリシーのアタッチ
# ------------------------------------------------
# AWSLambdaBasicExecutionRole のアタッチ
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole" 
}

# AmazonDynamoDBFullAccess のアタッチ
resource "aws_iam_role_policy_attachment" "dynamodb_full_access" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

# ------------------------------------------------
# 2. Lambda 関数本体の定義
# ------------------------------------------------
resource "aws_lambda_function" "minecraft_auto_start_lambda" {
  function_name = "minecraft-start-server-line" 
  
  # 実行ロールの ARN を参照
  role = aws_iam_role.lambda_exec_role.arn
  
  # SAM テンプレートより: ランタイム、ハンドラ、コード情報
  handler = "lambda_function.lambda_handler"
  runtime = "python3.13" # 既存のランタイムに合わせて変更してください
  
  # コードの格納場所（既存のリソースをTerraformで管理するために必要）
  filename = "lambda_deployment_package.zip" 
  source_code_hash = filebase64sha256("lambda_deployment_package.zip") 
  
  # その他の設定 (SAM テンプレートより)
  description    = ""
  memory_size    = 128
  timeout        = 300
  architectures  = ["x86_64"]

  ephemeral_storage {
    size = 512
  }
  
  # 環境変数は既存のものを再現
  environment {
    variables = {
      DYNAMODB_TABLE_NAME     = "minecraft-line-users"
      EC2_INSTANCE_ID         = var.minecraft_instance_id
      LINE_CHANNEL_ACCESS_TOKEN = "UpKUJS4hR1Tm4zoq1EY5qD+yCg6eRExh9A82snZv8sEJt/q3sNpt3icSvKHNs/33ta1+DC4Sv5lAFd97d708WJWWdXJNTKuCvhqvAh4w5OiL8Yt1bmw7WL85CnxMJMAjwlweuq4w79cQW/gmPyMXCAdB04t89/1O/w1cDnyilFU=" # ⚠️ 機密情報のため、後で Secret Manager を使用することを推奨します
    }
  }
}