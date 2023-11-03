/******************************************************************************

Function:     gluejobs

Type:         Glue

Description:  This Terraform module has code to create Glue jobs 

******************************************************************************/


resource "aws_glue_job" "GlueJob" {
  name = "${var.env}_${var.projectnameold}_${var.name}" # var.name # 
  role_arn = "${var.gluejob_arn}"
  description = var.description
  max_retries = "0"
  max_capacity   = 1
  connections =  var.databaseconnections
  timeout = 2880
  tags    = var.tags
  command {
    script_location = "s3://${var.artifact_bucket}/${var.repo_name}/SourceCode/${var.jobname}"
    name = var.executionenv
    python_version = "3"
  }

  default_arguments = var.job_parameters
  execution_property {
    max_concurrent_runs = 12
  }
  glue_version =var.glueversion
}