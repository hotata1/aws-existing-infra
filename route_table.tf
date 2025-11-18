resource "aws_route_table" "main_route_table" {
  # 💡 以前インポートした VPC ID を参照
  vpc_id = aws_vpc.main_vpc.id

  # propagating_vgws, route, tags_all はすべて削除

  tags = {
    # 既存のルートテーブルにタグがあれば追記
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.main_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_igw.id
}

# Subnet A と ルートテーブルの関連付け
resource "aws_route_table_association" "subnet_a_association" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.main_route_table.id
}

# Subnet B と ルートテーブルの関連付け
resource "aws_route_table_association" "subnet_b_association" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.main_route_table.id
}

# Subnet C と ルートテーブルの関連付け
resource "aws_route_table_association" "subnet_c_association" {
  subnet_id      = aws_subnet.subnet_c.id
  route_table_id = aws_route_table.main_route_table.id
}