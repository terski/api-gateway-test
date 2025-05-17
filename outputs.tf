output "notification_endpoint" {
  value       = "${aws_api_gateway_deployment.notification_deployment.invoke_url}/v1/notifications"
  description = "URL for the provider to POST notifications to"
}

output "api_id" {
  value       = aws_api_gateway_rest_api.notification_api.id
  description = "API Gateway ID"
}
