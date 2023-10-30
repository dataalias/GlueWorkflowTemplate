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
  description = "The name of the Gluejob."
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

variable "executionenv" {
  description = "The name of the tags."
  type        = string
  default     = ""
}

variable "glueversion" {
  description = "The name of the tags."
  type        = string
  default     = ""
}

variable "jobname" {
  description = "The name of the Glue Python file."
  type        = string
  default     = ""
}

variable "projectnameold" {
  description = "The name of the database project file."
  type        = string
  default     = ""
}


variable "description" {
  description = "The description of the Glue jobs."
  type        = string
  default     = ""
}

variable "job_parameters" {
  description = "The description of the Glue jobs."
  type        = map(string)
  default     = {}
}

variable "databaseconnections" {
  type        = list(string)
  default     = []
  description = "(Optional) The list of connections used for this job."
}

variable "artifact_bucket" {
  description = "The S3 bucket name where build artifacts are stored."
  type        = string
}