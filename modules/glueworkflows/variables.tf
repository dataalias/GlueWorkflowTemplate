variable "prefix" {
  description = "The environment being deployed."
  type        = string
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


variable "projectname" {
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

variable "actions" {
  description = "List of all the actions the workflow will take."  
  type = list(object({
    trigger_type      = string  # enum("ON_DEMAND", "CONDITIONAL", "SCHEDULED")
    schedule          = string  # This is only for Scheduled triggers.
    job_name          = string  # Name of the job to fire if trigger meets state.
    trigger_description = string # Description of the trigger.
    predicate = list(object({
      conditions = list(object({
        predicate_job_name = string # Name of the job to review to determine if next step should run.
        state    = string # enum("STARTING", "RUNNING", "STOPPING", "STOPPED", "SUCCEEDED", "FAILED", "TIMEOUT")
      }))
    }))
  }))
}
/*
# This worked for previous iteration of the module.
variable "actions" {
  description = "List of all the actions the workflow will take."
  type        =  list(object({
      trigger_name      = string  
      trigger_type      = string
      condition_action  = string
      condition_state   = string
      action_name       = string
    }))
}
*/

variable "action1" {
  description = "The name of the first action in the workflow."
  type        = string
  default     = ""
}
/*
#depricated. use actions list.
variable "action2" {
  description = "The name of the second action in the workflow."
  type        = string
  default     = ""
}
variable "action3" {
  description = "The name of the third action in the workflow."
  type        = string
  default     = ""
}

variable "action4" {
  description = "The name of the third action in the workflow."
  type        = string
  default     = ""
}
*/
/*
variable "target_group_addition" {
  description = "Check to add resource"
  type        = string
  default     = ""
}
*/
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

variable "odsmergeanalytics" {
  description = "The name of the Analytics  Merge job ."
  type        = string
  default     = ""
}
