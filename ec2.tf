# ec2.tf (修正版 - 既存設定に一致させる)

resource "aws_instance" "minecraft_server" {
  # 破壊的変更を防ぐため、既存の値に合わせる！

  # 1. 💡 既存のAMI IDに修正
  ami           = "ami-0d5f5a4eaac1481cb" 
  
  # 2. 💡 既存のインスタンスタイプに修正
  instance_type = "t3.medium" # 既存はt3.mediumのようです

  # 3. 💡 既存のサブネット (Subnet C) に修正
  subnet_id     = aws_subnet.subnet_c.id   

  # 4. 💡 既存のキーペア名に修正
  key_name = "minecraft-prd-keypair" 

  # 5. 💡 既存のパブリックIP設定に修正 (false)
  associate_public_ip_address = false

  # 6. 💡 既存のIAMプロファイル名に修正 (重要)
  iam_instance_profile = "MinecraftAutoStopRole" 
  
  # 7. 💡 Security Groupを参照
  vpc_security_group_ids = [
    aws_security_group.minecraft_sg.id,
  ]

  # 8. 💡 タグを既存の値に修正
  tags = {
    Name = "minecraft-prd-ec2"
  }
}