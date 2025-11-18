# igw.tf

resource "aws_internet_gateway" "main_igw" {
  # 💡 以前インポートした VPC ID を参照します
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    # 既存の IGW にタグがあれば追記。なければ空でOKです。
  }
}