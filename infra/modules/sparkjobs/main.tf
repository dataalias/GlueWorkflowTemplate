/******************************************************************************

Function:     gluejobs

Type:         Glue

Description:  This Terraform module has code to create Glue jobs 
******************************************************************************/


resource "aws_glue_job" "GlueJob" {
  name =  "${var.name}"
  role_arn = "${var.gluejob_arn}"
  description = var.description
  max_retries = "0"
  connections =  var.databaseconnections
  timeout = 2880
  tags    = var.tags

  command {
    script_location = "s3://${var.artifact_bucket}/${var.repo_name}/SourceCode/${var.jobname}"
    name = "glueetl"
    python_version = "3"
  }

  default_arguments = var.job_parameters
  execution_property {
    max_concurrent_runs = 12
  }
  glue_version ="3.0"
  worker_type       = "G.1X"
  number_of_workers = 10
}