variable "env" {
  description = "The environment being deployed."
  type        = string
  validation {
    condition     = var.env == "dev" || var.env == "stg" || var.env == "prod"
    error_message = "The env value must be dev or prod."
  }
}

variable "region" {
  description = "."
  type        = string
  default     = ""
}

variable "project_name" {
  description = "."
  type        = string
  default     = ""
}

variable "repository_name" {
  description = "."
  type        = string
  default     = ""
}

variable "source_bucket_name" {
  description = "."
  type        = string
  default     = ""
}