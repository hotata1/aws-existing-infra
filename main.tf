# 使用するプロバイダー（AWS）とバージョンを指定します
terraform {
  # ----------------------------------------
  # ★ リモートS3バックエンドの設定 ★
  # ----------------------------------------
  backend "s3" {
    # 状態ファイルが保存されるS3バケット名
    bucket         = "terraform-state-2025-minecraftserver" 
    
    # 状態ファイルがバケット内に保存されるキー（パス）
    key            = "aws-existing-infra/terraform.tfstate" 
    
    # 使用するAWSリージョン
    region         = "ap-northeast-1" 
    
    # オプション: 状態ファイルの転送を暗号化
    encrypt        = true 
  }
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # 現在の安定バージョンに合わせています
    }
  }
}

# AWSプロバイダーを設定します
provider "aws" {
  region = var.aws_region
}
