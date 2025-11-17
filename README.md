# AWS Existing Infrastructure (IaC)

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE) 
## 📜 概要

このプロジェクトは、既存の **AWS** リソースを **Terraform** を使用して IaC (Infrastructure as Code) として管理するために作成されました。

### 目的

* 既存リソースの構成変更をコードで追跡する。
* インフラの構成をドキュメント化し、バージョン管理する。
* 手動での変更を防ぎ、環境の再現性を高める。

## ⚙️ セットアップと前提条件

このプロジェクトを実行するには、以下のツールが必要です。

1.  **Terraform** (v1.12以上)
2.  **AWS CLI** (認証情報の設定済み)
3.  **Git**
4.  **Visual Studio Code** (VS Code)

### 認証設定

Terraformは、AWS CLIによって設定された認証情報（`~/.aws/credentials`）を使用します。

以下のコマンドで認証情報を設定してください。

```bash
aws configure
# AWS Access Key ID, AWS Secret Access Key, Default region name を入力