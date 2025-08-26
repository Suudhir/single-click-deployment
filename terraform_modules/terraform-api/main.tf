# Description : Api Gateway resource on AWS for creating api.
resource "aws_api_gateway_rest_api" "rest_api" {
  name = join("", ["${var.deploy_env}", "-", "${var.api_gateway_name}"])
  binary_media_types = var.media_type
  endpoint_configuration {
    types = var.endpoint_type
    /* vpc_endpoint_ids = var.vpc_endpoint_ids_list     */
  }
}

#IAM Policy For Api Gateway
resource "aws_api_gateway_rest_api_policy" "api_policy" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "execute-api:Invoke",
      "Resource": "${aws_api_gateway_rest_api.rest_api.execution_arn}/*"
    }
  ]
}
EOF
}

# IAM role to be attached with API Gateway
resource "aws_iam_role" "api_gateway_nwp_role" {
  name               = var.role_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


# IAM Policy to be attached with IAM Role
resource "aws_iam_role_policy_attachment" "tc-role-policy-attach" {
  for_each = var.managed_policies
  policy_arn = each.value
  role       = "${aws_iam_role.api_gateway_nwp_role.name}"
}

###################==POST==############################

resource "aws_api_gateway_resource" "api_resource_nwp_data" {
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
  parent_id = "${aws_api_gateway_rest_api.rest_api.root_resource_id}"
  path_part = "${var.path_part_nwp_data}"
}

resource "aws_api_gateway_resource" "api_resources_nwp_data" {
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
  parent_id = "${aws_api_gateway_resource.api_resource_nwp_data.id}"
  path_part = "${var.path_parts_nwp_data}"
}

# Description : Terraform resource to create Api Gateway Method resource on AWS.
resource "aws_api_gateway_method" "api_method_nwp_data" {
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
  resource_id = "${aws_api_gateway_resource.api_resources_nwp_data.id}"
  http_method = var.httpMethod_post
  authorization = var.method_authorization
}

# Description : Terraform resource to create Api Gateway Integration resource on AWS.
resource "aws_api_gateway_integration" "api_integration_nwp_data" {
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
  resource_id = "${aws_api_gateway_resource.api_resources_nwp_data.id}"
  http_method = "${aws_api_gateway_method.api_method_nwp_data.http_method}"
  integration_http_method = var.httpMethod_post
  passthrough_behavior = var.api_passthrough_behavior
  uri         = var.resource-uri-post
  credentials = "${aws_iam_role.api_gateway_nwp_role.arn}"
  type        = var.integration_type
  #request_templates = var.api_integration_request_template_post
  #request_parameters = var.api_http_headers

}

# Description : Terraform resource to create Api Gateway Method Response resource on AWS.
resource "aws_api_gateway_method_response" "api_response_nwp_data" {
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
  resource_id = "${aws_api_gateway_resource.api_resources_nwp_data.id}"
  http_method = "${aws_api_gateway_method.api_method_nwp_data.http_method}"
  status_code = var.api_status_code
  response_models = { "application/json" = "Empty" }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = true
    "method.response.header.Access-Control-Allow-Headers"     = true
    "method.response.header.Access-Control-Allow-Methods"     = true
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

# Description : Terraform resource to create Api Gateway Integration Response resource on AWS for creating api.
resource "aws_api_gateway_integration_response" "Api_Integration_Response_nwp_data" {
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
  resource_id = "${aws_api_gateway_resource.api_resources_nwp_data.id}"
  http_method = "${aws_api_gateway_method.api_method_nwp_data.http_method}"
  status_code = "${aws_api_gateway_method_response.api_response_nwp_data.status_code}"
  response_templates = var.api_integration_response_template
  
  response_parameters = var.response_parameters

  depends_on = [
    aws_api_gateway_method_response.api_response_nwp_data,
    aws_api_gateway_integration.api_integration_nwp_data
  ]
}

# Description : Terraform resource to create Api Gateway Deployment resource on AWS.
resource "aws_api_gateway_deployment" "api_deployment_nwp_data" {
  depends_on = [
    aws_api_gateway_method.api_method_nwp_data, aws_api_gateway_integration.api_integration_nwp_data
  ]
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api_stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment_nwp_data.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = "${var.stage_name}"
  xray_tracing_enabled = var.xray_tracing_enabled

}

resource "aws_api_gateway_method_settings" "method_nwp_data" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = aws_api_gateway_stage.api_stage.stage_name
  method_path = "${var.method_path}"

  settings {
    metrics_enabled = var.enable_metrics
    logging_level   = var.logging_level
    throttling_rate_limit  = var.throttling_rate_limit
    throttling_burst_limit = var.throttling_burst_limit
  }
}
