# ------------------------------------------------
# 1. REST API 本体の定義 (aws_api_gateway_rest_api)
# ------------------------------------------------
resource "aws_api_gateway_rest_api" "line_webhook_api" {
  name        = "MinecraftLineWebhook"
  description = "" # 既存の情報にはDescriptionがないため空
  
  # API ID (xnh5bc7uoe) と一致させる
  # 注: API IDはTerraformリソースのidと自動的に一致するため、ここでは名前と説明のみを定義
}

# ------------------------------------------------
# 2. リソースの定義 (aws_api_gateway_resource)
# ------------------------------------------------
# パス: /webhook
resource "aws_api_gateway_resource" "webhook_resource" {
  rest_api_id = aws_api_gateway_rest_api.line_webhook_api.id
  parent_id   = aws_api_gateway_rest_api.line_webhook_api.root_resource_id # ルート '/' の ID
  path_part   = "webhook"
}

# ------------------------------------------------
# 3. メソッドの定義 (aws_api_gateway_method)
# ------------------------------------------------
# メソッド: POST /webhook
resource "aws_api_gateway_method" "webhook_post_method" {
  rest_api_id   = aws_api_gateway_rest_api.line_webhook_api.id
  resource_id   = aws_api_gateway_resource.webhook_resource.id
  http_method   = "POST"
  authorization = "NONE" # 認証なし (LINE Webhookの標準的な設定)
}

# ------------------------------------------------
# 4. Lambda統合の定義 (aws_api_gateway_integration)
# ------------------------------------------------
resource "aws_api_gateway_integration" "webhook_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.line_webhook_api.id
  resource_id             = aws_api_gateway_resource.webhook_resource.id
  http_method             = aws_api_gateway_method.webhook_post_method.http_method
  
  # Lambda 関数との統合
  type                    = "AWS_PROXY" # Lambdaプロキシ統合
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.minecraft_auto_start_lambda.arn}/invocations"
}

# ------------------------------------------------
# 5. Lambda実行許可の追加 (aws_lambda_permission)
# ------------------------------------------------
# API GatewayからLambdaを呼び出すための権限
resource "aws_lambda_permission" "apigw_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.minecraft_auto_start_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  
  # ステージ名 (prod) をSourceARNに明示的に含めます
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_api_gateway_rest_api.line_webhook_api.id}/${aws_api_gateway_stage.prod_stage.stage_name}/*"
}

# ------------------------------------------------
# 6. API のデプロイ (aws_api_gateway_deployment)
# ------------------------------------------------
resource "aws_api_gateway_deployment" "webhook_deployment" {
  rest_api_id = aws_api_gateway_rest_api.line_webhook_api.id
  
  # API Gatewayのデプロイは、ステージ設定がなければ効果がありません。
}

# ------------------------------------------------
# 7. ステージの定義 (aws_api_gateway_stage)
# ------------------------------------------------
# 通常、SAMテンプレートでは'Prod'などのステージ名が使われますが、不明なため一般的な'prod'を仮定します。
resource "aws_api_gateway_stage" "prod_stage" {
  deployment_id = aws_api_gateway_deployment.webhook_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.line_webhook_api.id
  stage_name    = "prod" 
}