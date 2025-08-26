variable "region" {
  
  type = string
  default = "eu-west-1"
}

variable "account_id" {
  description = "AWS account ID"
  type = string
}

variable "deploy_env"  {
  description = "Environment of the resource deployment"
  type = string
}

variable "api_gateway_name"  {
  description = "Name of the API Gateway"
  type = string
}


variable "httpMethod_post" {
  type = string
  default = "POST"
}

variable "api_stage_name" {
  description = "Name of the API Stage to deploy"
  type = string
}

variable "integration_type" {
  description = "API Gateway Integration Type. e.g. AWS, AWS_PROXY"
  type = string
}

variable "endpoint_type" {
  description = "API Gateway Endpoint Type. e.g. PRIVATE, REGIONAL, EDGE"
  type = list(string)
}



variable "resource-uri-post" {
  description = "ARN of the Resourse to be attached with POST"
  type = string
}

variable "api_status_code" {
  description = "Status code of API Gateway"
  type = string
}

variable "managed_policies" {
  description = "Add the managed policies arn"
  type        = map(string)
}

variable "path_part_nwp_data" {
  type = string
}

variable "path_parts_nwp_data" {
  type = string
}

variable "method_authorization" {
  type = string
}

variable "api_integration_request_template_get" {
  description = "Determine the integration request template"
  type        = map(string)
  default = {}
}

variable "response_parameters" {
  description = "Specify the Response Parameters"
  type        = map(string)
}
/* 
variable "api_http_headers" {
  type        = map(string)
} */

variable "destination_arns" {
  type        = string
  default     = "arn:aws:iam::966858974369:role/api-to-cloudwatch"
  description = "ARN of the log group to send the logs to. Automatically removes trailing :* if present."
}

variable "formats" {
  type        = string
  default     = "..."
  description = "The formatting and values recorded in the logs."
}

variable "method_path" {
  type = string
}

variable "enable_metrics" {
  description = "Whether or not we want to enable metrics"
  type = bool
  default = true
}

variable "throttling_rate_limit" {
  type = number
}

variable "throttling_burst_limit" {
  type = number
}

variable "logging_level" {
  type = string
  default = "INFO"

}

variable "api_passthrough_behavior" {
  type = string
}

variable "cloudwatch_managed_policies" {
  description = "Add the managed policies arn"
  type        = map(string)
}
variable "api_integration_request_template_post" {
  description = "Determine the integration request template"
  type        = map(string)
  default = {}
}

variable "media_type" {
  type = list(string)
}

variable "stage_name" {
  description = "Name of the API Stage to deploy"
  type = string
}


/* variable "vpc_endpoint_ids_list" {
  type        = list
  # default     = [""]
  description = "VPC Endpoint ID"
} */

variable "api_integration_response_template" {
  description = "Determine the integration response template"
  type = map(string)
  #default =  [{}]
}


variable "xray_tracing_enabled" {
  description = "Whether or not we want to enable xray"
  type = bool
  default = true
}

variable "role_name" {
  description = "Spcify the IAM Role Name"
  type = string
}
