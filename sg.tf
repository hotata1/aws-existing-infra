# sg.tf (修正後)

resource "aws_security_group" "minecraft_sg" {
    # 💡 VPC ID を参照に変更
    vpc_id      = aws_vpc.main_vpc.id

    name        = "minecraft-prd-securitygroup"
    # 💡 description をクリーンアップ
    description = "minecraft-prd-securitygroup created 2025-11-03T13:49:25.779Z"

    # 既存のルールをそのまま維持

    # Egress Rules (アウトバウンド)
    egress = [
        {
            cidr_blocks      = var.egress_cidr_blocks # 変数に置き換え
            description      = "All traffic out"
            from_port        = 0
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "-1"
            security_groups  = []
            self             = false
            to_port          = 0
        },
    ]

    # Ingress Rules (インバウンド)
    ingress = [
        {
            cidr_blocks      = var.minecraft_bedrock_allow_cidr # 変数に置き換え
            description      = "Minecraft Bedrock Connection (UDP 19132)"
            from_port        = 19132
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "udp"
            security_groups  = []
            self             = false
            to_port          = 19132
        },
        {
            cidr_blocks      = var.ssh_allow_cidr # 変数に置き換え
            description      = "SSH access (TCP 22)"
            from_port        = 22
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 22
        },
        {
            cidr_blocks      = var.minecraft_java_allow_cidr # 変数に置き換え
            description      = "Minecraft Java Connection (TCP 25565)"
            from_port        = 25565
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 25565
        },
    ]
    
    tags = {}
    # name_prefix, owner_id, tags_all は削除
}