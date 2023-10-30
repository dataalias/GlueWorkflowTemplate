variable "env" {
  description = "The environment being deployed."
  type        = string
  validation {
    condition     = var.env == "dev" || var.env == "stg" || var.env == "prod"
    error_message = "The env value must be dev or prod."
  }
}


variable "crawlerdatabase" {
  description = "The name of the Database."
  type        = string
  default     = ""
}

variable "name" {
  description = "The name of the Database."
  type        = string
  default     = ""
}

variable "projectnameold" {
  description = "The name of the database project."
  type        = string
  default     = ""
}

variable "path" {
  description = "The name of the Database."
  type        = string
  default     = ""
}

variable "gluejob_arn" {
  description = "The name of the Database."
  type        = string
  default     = ""
}


variable "source_bucket_name" {
  description = "The name of the Database."
  type        = string
  default     = ""
}


variable "repo_name" {
  description = "The name of the Database."
  type        = string
  default     = ""
}

variable "tags" {
  description = "The name of the tags."
  type        = map(string)
  default     = {}
}

