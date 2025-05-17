resource "aws_api_gateway_rest_api" "notification_api" {
  name        = var.api_name
  description = "API to test a notifications endpoint"
}

# Create v1 resource
resource "aws_api_gateway_resource" "v1_resource" {
  rest_api_id = aws_api_gateway_rest_api.notification_api.id
  parent_id   = aws_api_gateway_rest_api.notification_api.root_resource_id
  path_part   = "v1"
}

# Create notifications resource under v1
resource "aws_api_gateway_resource" "notifications_resource" {
  rest_api_id = aws_api_gateway_rest_api.notification_api.id
  parent_id   = aws_api_gateway_resource.v1_resource.id
  path_part   = "notifications"
}

# Set up POST method
resource "aws_api_gateway_method" "notifications_post" {
  rest_api_id   = aws_api_gateway_rest_api.notification_api.id
  resource_id   = aws_api_gateway_resource.notifications_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

# Set up a mock integration that always returns 200
resource "aws_api_gateway_integration" "notifications_integration" {
  rest_api_id = aws_api_gateway_rest_api.notification_api.id
  resource_id = aws_api_gateway_resource.notifications_resource.id
  http_method = aws_api_gateway_method.notifications_post.http_method

  type = "MOCK"
  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}

# Set up integration response
resource "aws_api_gateway_integration_response" "notifications_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.notification_api.id
  resource_id = aws_api_gateway_resource.notifications_resource.id
  http_method = aws_api_gateway_method.notifications_post.http_method
  status_code = "200"

  response_templates = {
    "application/json" = jsonencode({
      message = "Notification received successfully"
    })
  }

  depends_on = [
    aws_api_gateway_method_response.notifications_200,
    aws_api_gateway_integration.notifications_integration
  ]
}

# Define method response
resource "aws_api_gateway_method_response" "notifications_200" {
  rest_api_id = aws_api_gateway_rest_api.notification_api.id
  resource_id = aws_api_gateway_resource.notifications_resource.id
  http_method = aws_api_gateway_method.notifications_post.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

# Create deployment
resource "aws_api_gateway_deployment" "notification_deployment" {
  rest_api_id = aws_api_gateway_rest_api.notification_api.id
  stage_name  = var.stage_name

  depends_on = [
    aws_api_gateway_integration.notifications_integration,
    aws_api_gateway_integration_response.notifications_integration_response,
    aws_api_gateway_method_response.notifications_200
  ]

  # Force new deployment when API changes
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.notifications_resource.id,
      aws_api_gateway_method.notifications_post.id,
      aws_api_gateway_integration.notifications_integration.id
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}
