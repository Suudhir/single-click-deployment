variable "region" {
  default     = "eu-west-1"
  description = "This is the AWS region where resources will be provisioned."
}

variable "allocated_storage" {
  type        = number
  description = "The amount of storage to allocate for the DB instance (in GB)."
}

variable "db_name" {
  type        = string
  description = "The name of the database to create on the DB instance."
}

variable "engine" {
  type        = string
  description = "The name of the database engine to use for the DB instance."
}

variable "engine_version" {
  type        = string
  description = "The version of the database engine to use for the DB instance."
}

variable "instance_class" {
  type        = string
  description = "The instance type for the DB instance."
}

variable "username" {
  type        = string
  description = "The username for the master user of the DB instance."
}

variable "password" {
  type        = string
  description = "The password for the master user of the DB instance."
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Specifies whether a final DB snapshot is created before the DB instance is deleted."
}
