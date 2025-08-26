# Specify the HTTP method for API Gateway
# httpMethod_get = "GET"
httpMethod_post = "POST"

#ID of the account where API will be deployed
account_id = "999287694967"

#Environment where the API will be deployed
deploy_env = "dev"

# Specify the integration type: AWS_PROXY, AWS, MOCK, HTTP
integration_type = "AWS"

# Specify the endpoint_type: PRIVATE or REGIONAL
endpoint_type = ["REGIONAL"]
#vpc_endpoint_ids_list = ["vpce-0802b17de3eaf87d2"]

# Specify the API Gateway name
api_gateway_name = "kwp-data-serving-api"

# Specify the API resource
# path_part = "GET"
path_part_nwp_data = "v1"

path_parts_nwp_data = "dev"

method_authorization = "NONE"

# Specify the ARN of service when integration_type = AWS
# resource-uri-get = "arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:999287694967:function:dev-pswdata/invocations"
resource-uri-post = "arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:999287694967:function:dev-pswdata-serving-lambda/invocations"

api_status_code = "200"

# Name of IAM role to be attached with API Gateway

# Specify the stages you want in API Gateway
api_stage_name = "dev"
stage_name = "dev"
xray_tracing_enabled = true
# ARNs of AWS managed policies to be attached with IAM Role
managed_policies = {1 = "arn:aws:iam::aws:policy/AdministratorAccess", 2 = "arn:aws:iam::aws:policy/AmazonAPIGatewayInvokeFullAccess", 3 = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs", 4 = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"}

# Map of the integration's request templates.



# Additional header for API Gateway integration
#api_http_headers = {"integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"}

#Specify the Response Parameters
response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
}

#Method path defined as {resource_path}/{http_method} for an individual method override, or */* for overriding all methods in the stage.
method_path = "*/*"

#Whether Amazon CloudWatch metrics are enabled for this method
enable_metrics = true

#Logging level for this method, which effects the log entries pushed to Amazon CloudWatch Logs. The available levels are OFF, ERROR, and INFO.
logging_level = "INFO"

# Throttling rate limit. Default: -1 (throttling disabled).
throttling_rate_limit = 10000

#Throttling burst limit. Default: -1 (throttling disabled).
throttling_burst_limit = 5000

# Integration passthrough behavior (WHEN_NO_MATCH, WHEN_NO_TEMPLATES, NEVER). Required if request_templates is used.
api_passthrough_behavior = "WHEN_NO_MATCH"


cloudwatch_managed_policies = {1 = "arn:aws:iam::aws:policy/AmazonSQSFullAccess",2 = "arn:aws:iam::aws:policy/AmazonAPIGatewayInvokeFullAccess",3 = "arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator"}

# List of binary media types supported by the REST API. By default, the REST API supports only UTF-8-encoded text payloads.
media_type = ["UTF-8-encoded"]


api_integration_response_template = {
    "application/json" = <<EOF
        #set($inputRoot = $input.path('$'))
        $input.json("$")
        #if($inputRoot.toString().contains("error"))
        #set($context.responseOverride.status = 400)
        #elseif($inputRoot.toString().contains("Error"))
        #set($context.responseOverride.status = 400)
        #end
      EOF
}

role_name = "nwp-data-api-role"
