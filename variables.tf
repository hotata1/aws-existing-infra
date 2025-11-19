# AWS リージョンの定義
variable "aws_region" {
  description = "AWS リソースをデプロイするリージョン (例: ap-northeast-1)"
  type        = string
  default     = "ap-northeast-1" # 東京リージョン
}

# VPC の CIDR ブロック
variable "vpc_cidr_block" {
  description = "メイン VPC の CIDR ブロック"
  type        = string
  default     = "172.31.0.0/16" # 取得した VPC CIDR に変更
}

# Minecraft サーバーの EC2 インスタンスタイプ
variable "instance_type" {
  description = "Minecraft サーバーとして使用する EC2 インスタンスタイプ"
  type        = string
  default     = "t3.medium" # 取得したインスタンスタイプ
}

# S3 State Bucket の名前
variable "state_bucket_name" {
  description = "Terraform の State ファイルを保存する S3 バケット名"
  type        = string
  default     = "terraform-state-2025-minecraftserver" # 取得した S3 バケット名に設定
}

# EC2 インスタンス ID (自己停止ポリシーに使用)
variable "minecraft_instance_id" {
  description = "自己停止ポリシーで使用する Minecraft サーバーのインスタンスID"
  type        = string
  default     = "i-0888bb6c78420b9c5" # 取得したインスタンス ID を追加
}

# Subnet A, B, C の CIDR ブロックをリストとして定義 (VPCファイル内の順序に合わせて設定)
# (subnet-a, subnet-b, subnet-c の順で設定すると仮定します)
variable "public_subnet_cidrs" {
  description = "各サブネットの CIDR ブロックのリスト (a, b, c)"
  type        = list(string)
  default     = [
    "172.31.0.0/20",  # subnet_a (ap-northeast-1c)
    "172.31.16.0/20", # subnet_b (ap-northeast-1d)
    "172.31.32.0/20"  # subnet_c (ap-northeast-1a)
  ]
}

# 使用するアベイラビリティゾーンのリスト
variable "availability_zones" {
  description = "サブネットを作成するアベイラビリティゾーンのリスト (a, b, c)"
  type        = list(string)
  default     = [
    "ap-northeast-1c", 
    "ap-northeast-1d", 
    "ap-northeast-1a"
  ]
}

# アウトバウンドを許可する CIDR ブロック
variable "egress_cidr_blocks" {
  description = "セキュリティグループのアウトバウンドで許可する CIDR ブロックのリスト"
  type        = list(string)
  default     = ["0.0.0.0/0"] # 現在の設定に合わせてすべて許可をデフォルトに
}

# SSH アクセスを許可する CIDR ブロック
variable "ssh_allow_cidr" {
  description = "SSH (ポート22) アクセスを許可する CIDR ブロックのリスト"
  type        = list(string)
  default     = ["0.0.0.0/0"] 
}

# Minecraft Java Edition 接続を許可する CIDR ブロック
variable "minecraft_java_allow_cidr" {
  description = "Minecraft Java Edition (ポート25565/tcp) アクセスを許可する CIDR ブロックのリスト"
  type        = list(string)
  default     = ["0.0.0.0/0"] 
}

# Minecraft Bedrock Edition 接続を許可する CIDR ブロック
variable "minecraft_bedrock_allow_cidr" {
  description = "Minecraft Bedrock Edition (ポート19132/udp) アクセスを許可する CIDR ブロックのリスト"
  type        = list(string)
  default     = ["0.0.0.0/0"] 
}

# デフォルトルートの宛先 CIDR ブロック
variable "default_route_cidr" {
  description = "インターネットゲートウェイに向けたデフォルトルートの宛先 CIDR ブロック"
  type        = string
  default     = "0.0.0.0/0"
}

variable "aws_account_id" {
  description = "AWSアカウントID (12桁の数値)"
  type        = string
  # 以前確認したアカウントIDをデフォルト値として設定します
  default     = "290321162221"
}