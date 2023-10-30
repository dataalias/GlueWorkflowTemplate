variable "env" {
  description = "The environment being deployed."
  type        = string
  validation {
    condition     = var.env == "dev" || var.env == "stg" || var.env == "prod"
    error_message = "The env value must be dev or prod."
  }
}

variable "crawlername" {
  description = "The name of the carwler."
  type        = string
  default     = ""
}

variable "name" {
  description = "The name of the Gluejob."
  type        = string
  default     = ""
}

variable "source_bucket_name" {
  description = "The name of the Database."
  type        = string
  default     = ""
}


variable "repo_name" {
  description = "The name of the repository."
  type        = string
  default     = ""
}


variable "projectnameold" {
  description = "The name of the database project."
  type        = string
  default     = ""
}

variable "datawarehouse" {
  description = "The name of the database environment."
  type        = string
  default     = ""
}

variable "tags" {
  description = "The name of the tags."
  type        = map(string)
  default     = {}
}


variable "action1" {
  description = "The name of the first action in the workflow."
  type        = string
  default     = ""
}

variable "action2" {
  description = "The name of the second action in the workflow."
  type        = string
  default     = ""
}

variable "target_group_addition" {
  description = "Check to add resource"
  type        = string
  default     = ""
}

variable "description" {
  description = "The description of the Glue jobs."
  type        = string
  default     = ""
}

variable "job_parameters_il" {
  description = "Parameters for Datahub Updater."
  type        = map(string)
  default     = {}
}


variable "job_parameters_if" {
  description = "Parameters for Datahub Updater."
  type        = map(string)
  default     = {}
}

variable "job_parameters_is" {
  description = "Parameters for Datahub Updater."
  type        = map(string)
  default     = {}
}

variable "job_parameters_merge" {
  description = "Parameters for Datahub Updater."
  type        = map(string)
  default     = {}
}

variable "job_parameters_analyticsupdate" {
  description = "Parameters for Datahub Updater."
  type        = map(string)
  default     = {}
}

variable "odsmerge" {
  description = "The name of the ODS Merge Job."
  type        = string
  default     = ""
}

variable "datahubupdater_il" {
  description = "The name of the datahub updater."
  type        = string
  default     = ""
}

variable "datahubupdater_if" {
  description = "The name of the datahub updater."
  type        = string
  default     = ""
}

variable "datahubupdater_is" {
  description = "The name of the datahub updater."
  type        = string
  default     = ""
}

variable "odsmergeanalytics" {
  description = "The name of the Analytics  Merge job ."
  type        = string
  default     = ""
}