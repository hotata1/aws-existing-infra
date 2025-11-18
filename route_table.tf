resource "aws_route_table" "main_route_table" {
  # 💡 以前インポートした VPC ID を参照
  vpc_id = aws_vpc.main_vpc.id

  # propagating_vgws, route, tags_all はすべて削除

  tags = {
    # 既存のルートテーブルにタグがあれば追記
  }
}