# ------------------------------------------------
# 1. DynamoDB テーブルの定義
# ------------------------------------------------
resource "aws_dynamodb_table" "minecraft_line_users" {
  name             = "minecraft-line-users"
  
  # パーティションキーの定義
  hash_key         = "UserId"
  
  # キャパシティーモードをオンデマンド (既存設定) に設定
  billing_mode     = "PAY_PER_REQUEST"

  # キー属性の定義
  attribute {
    name = "UserId"
    type = "S" # String型
  }
  
  # 既存のテーブルにタグが設定されている場合は、ここで記述します
  tags = {
    Name = "minecraft-line-users"
  }
}