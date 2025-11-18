# subnets.tf (最終修正版)

# Subnet A
resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.main_vpc.id # 💡 参照に変更
  cidr_block              = "172.31.0.0/20"
  availability_zone_id    = "apne1-az1" 
  map_public_ip_on_launch = true 
  
  # その他の不要な属性はすべて削除
  assign_ipv6_address_on_creation = false
  enable_dns64 = false
  enable_resource_name_dns_a_record_on_launch = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  tags = {}
  # tags_all は不要
}

# Subnet B
resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "172.31.16.0/20"
  availability_zone_id    = "apne1-az2"
  map_public_ip_on_launch = true
  
  assign_ipv6_address_on_creation = false
  enable_dns64 = false
  enable_resource_name_dns_a_record_on_launch = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  tags = {}
}

# Subnet C
resource "aws_subnet" "subnet_c" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "172.31.32.0/20"
  availability_zone_id    = "apne1-az4"
  map_public_ip_on_launch = true
  
  assign_ipv6_address_on_creation = false
  enable_dns64 = false
  enable_resource_name_dns_a_record_on_launch = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  tags = {}
}