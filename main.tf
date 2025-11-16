# 使用するプロバイダー（AWS）とバージョンを指定します
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # 現在の安定バージョンに合わせています
    }
  }
}

# AWSプロバイダーを設定します
# regionは、リソースを作成したいAWSのリージョンに置き換えてください
provider "aws" {
  region = "ap-northeast-1" # 例: 東京リージョン
}