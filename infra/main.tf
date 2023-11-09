terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.31.0"
    }
  }

  required_version = "~> 1.4.6"
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment                        = var.env
      Service                            = "Loan Servicing"
      Note                               = "Managed by Terraform"
      "mission:managed-cloud:monitoring" = "infrastructure"
      Department = "Data Engineering"
      DepartmentCode = "DE"
      Repository = var.repository_name
    }
  }
}

terraform {
  backend "s3" {
    region = "us-east-1"
  }
}

resource "aws_iam_role" "glue_role" {
  name = "${var.env}${var.project_name}_GlueRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Allow CodePipeline to assume this role.
      {
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  # Allow the role to access the Cloudwatch.
  inline_policy {
    name = "${var.env}${var.project_name}_CloudWatchPolicy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "cloudwatch:*"
          ]
          Resource = [
            "*"
          ]
          Effect = "Allow"
        }
      ]
    })
  }
}

module "code_pipeline" {
  source = "git@github.com:Ascent-Funding/terraform-codepipeline.git?ref=e38e70f819ce6816eb097d0f358f834103c4f0d3" 

  region                       = var.region
  account_id                   = var.account_id
  artifact_bucket              = var.artifact_bucket
  artifact_prefix              = var.artifact_prefix
  unit_test_buildspec          = var.unit_test_buildspec
  deploy_buildspec             = var.deploy_buildspec
  build_compute_type           = var.build_compute_type
  artifact_encryption_key      = var.artifact_encryption_key
  repo_name                    = var.repo_name
  branch                       = var.branch

  environment_variables = [
    {
      name  = "ENV"
      value = var.env
      type  = "PLAINTEXT"
    }
  ]
}

/*
module "s3crawlers" {
  source = "./modules/s3crawlers"
  for_each    = {
    for i,v in var.s3crawlers:
    i => v
  } 
  name             = each.value.name #"${var.env}${var.projectname}_${each.value.name}"
  path             = each.value.path
  crawlerdatabase  = var.crawlerdatabase
  gluejob_arn      = var.gluejob_arn
  env              = var.env
  source_bucket_name = var.source_bucket_name
  repo_name        = var.repository_name
  projectnameold   = var.project_name


}

module "odscrawlers" {
  source = "./modules/odscrawlers"
  for_each    = {
    for i,v in var.odscrawlers:
    i => v
  } 
  name             = each.value.name # "${var.env}${var.projectname}_${each.value.name}"
  path             = each.value.path
  crawlerdatabase  = var.connection
  gluejob_arn      = var.gluejob_arn
  env              = var.env
  connection       = var.connection
  schema           = var.schema

}
*/

module "gluejobs" {
  source = "./modules/gluejobs"
  for_each    = {
    for i,v in var.gluejobs:
    i => v
  } 
  prefix           = "${var.env}_${var.projectname}"
  name             = each.value.name
  description      = each.value.description
  jobname          = each.value.jobname # Musat tie exactly and the bucket differentiates env .... "${var.projectname}_${each.value.jobname}"
  gluejob_arn      = var.gluejob_arn
  env              = var.env
  source_bucket_name = var.source_bucket_name
  repo_name          = var.repo_name
  artifact_bucket    = var.artifact_bucket
  databaseconnections = var.databaseconnections
  glueversion        = "1.0"
  executionenv      = "pythonshell"
  projectname      = var.projectname
  job_parameters = {
    "--BUCKET_NAME"         = "${var.source_bucket_name}"
    "--DB_SECRET_STR_DH"    = "${var.database_secret_datahub}"
    "--DB_SECRET_STR_ODS"   = "${var.database_secret_ODS}"
    "--enable-spark-ui"     =  true
    "--enable-metrics"      =  true
    "--enable-continuous-cloudwatch-log"      = true
    "--extra-py-files"                        = length(var.extra_py_files) > 0 ? join(",", var.extra_py_files) : null
  }
}

module "sparkjobs" {
  source = "./modules/sparkjobs"
  for_each    = {
    for i,v in var.sparkjobs:
    i => v
  } 
  name             = "${var.env}_${var.projectnameold}_${each.value.name}"
  description      = each.value.description
  jobname          = each.value.jobname
  gluejob_arn      = var.gluejob_arn
  env              = var.env
  source_bucket_name  = var.source_bucket_name
  repo_name           = var.repo_name
  artifact_bucket     = var.artifact_bucket
  databaseconnections = var.databaseconnections
  projectnameold      = var.projectnameold
  glueversion         = "3.0"
  executionenv        = "Spark"
  job_parameters = {
    "--BUCKET_NAME"         = "${var.source_bucket_name}"
    "--DB_SECRET_STR_DH"    = "${var.database_secret_datahub}"
    "--DB_SECRET_STR_ODS"   = "${var.database_secret_ODS}"
    "--enable-spark-ui"     =  true
    "--enable-metrics"      =  true
    "--enable-continuous-cloudwatch-log"      = true
    "--extra-py-files"                        = length(var.extra_py_files) > 0 ? join(",", var.extra_py_files) : null
  } 
}

module "glueworkflows" {
  source = "./modules/glueworkflows"
  for_each    = {
    for i,v in var.glueworkflows:
    i => v
  } 
  prefix           = "${var.env}_${var.projectname}"
  name             = each.value.name
  description      = each.value.description
  actions          = each.value.actions #list of objects
  job_parameters_merge = each.value.job_parameters_merge
  job_parameters_il    = each.value.job_parameters_il
  job_parameters_if    = each.value.job_parameters_if
  datawarehouse        = var.datawarehouse
  projectname          = var.projectname
  source_bucket_name   = var.source_bucket_name
  repo_name            = var.repo_name
}

module "gluejobsold" {
  source = "./modules/gluejobsold"
  for_each    = {
    for i,v in var.gluejobsold:
    i => v
  } 
  name             =  "${each.value.name}"
  description      =  each.value.description
  jobname          =  each.value.jobname
  gluejob_arn      = var.gluejob_arn
  env              = var.env
  source_bucket_name = var.source_bucket_name
  repo_name          = var.repo_name
  artifact_bucket    = var.artifact_bucket
  databaseconnections = var.databaseconnections
  glueversion        = "1.0"
  executionenv      = "pythonshell"
  projectnameold      = var.projectnameold
  job_parameters = {
    "--BUCKET_NAME"         = "${var.source_bucket_name}"
    "--DB_SECRET_STR_DH"    = "${var.database_secret_datahub}"
    "--DB_SECRET_STR_ODS"   = "${var.database_secret_ODS}"
    "--enable-spark-ui"     =  true
    "--enable-metrics"      =  true
    "--enable-continuous-cloudwatch-log"      = true
    "--extra-py-files"                        = length(var.extra_py_filesold) > 0 ? join(",", var.extra_py_filesold) : null
  }
}

module "gluejobsgeneral" {
  source = "./modules/gluejobsgeneral"
  for_each    = {
    for i,v in var.gluejobsgeneral:
    i => v
  } 
  name             =  each.value.name # "${var.env}${var.projectname}_${each.value.name}"
  description      =  each.value.description
  jobname          =  each.value.jobname
  gluejob_arn      = var.gluejob_arn
  env              = var.env
  source_bucket_name = var.source_bucket_name
  repo_name          = var.repo_name
  artifact_bucket    = var.artifact_bucket
  databaseconnections = var.databaseconnections
  glueversion        = "1.0"
  executionenv      = "pythonshell"
  job_parameters = {
    "--BUCKET_NAME"         = "${var.source_bucket_name}"
    "--DB_SECRET_STR_DH"    = "${var.database_secret_datahub}"
    "--DB_SECRET_STR_ODS"   = "${var.database_secret_ODS}"
    "--enable-spark-ui"     =  true
    "--enable-metrics"      =  true
    "--enable-continuous-cloudwatch-log"      = true
    "--extra-py-files"                        = length(var.extra_py_filesold) > 0 ? join(",", var.extra_py_filesold) : null
  }
}

module "glueworkflowsold" {
  source = "./modules/glueworkflowold"
  for_each    = {
    for i,v in var.glueworkflowsold:
    i => v
  } 
  env               = var.env
  name              = each.value.name
  description       = each.value.description
  action1           = "${var.env}_${each.value.action1}"
  action2           = "${var.env}_${each.value.action2}"
  job_parameters_merge = each.value.job_parameters_merge
  job_parameters_is = each.value.job_parameters_is
  job_parameters_il = each.value.job_parameters_il
  job_parameters_if = each.value.job_parameters_if
  datawarehouse     = var.datawarehouse
  projectnameold    = var.projectnameold
  odsmerge          = var.odsmerge
  crawlername       = var.crawlername
  #odsmergeanalytics  = var.odsmergeanalytics
  datahubupdater_is     = var.datahubupdater_is
  datahubupdater_il     = var.datahubupdater_il
  datahubupdater_if     = var.datahubupdater_if
  source_bucket_name = var.source_bucket_name
  repo_name          = var.repo_name

}

module "glueworkflowsold2" {
  source = "./modules/glueworkflowold2"
  for_each    = {
    for i,v in var.glueworkflowsold2:
    i => v
  } 
  env              = var.env
  name             = each.value.name
  description      = each.value.description
  action1           = "${var.env}_${each.value.action1}"
  action2           = "${var.env}_${each.value.action2}"
  job_parameters_il = each.value.job_parameters_il
  job_parameters_if = each.value.job_parameters_if
  datawarehouse    = var.datawarehouse
  projectnameold      = var.projectnameold
  #odsmerge           = var.odsmerge
  #odsmergeanalytics  = var.odsmergeanalytics
  datahubupdater_il     = var.datahubupdater_il
  datahubupdater_is     = var.datahubupdater_is
  datahubupdater_if     = var.datahubupdater_if
  source_bucket_name = var.source_bucket_name
  repo_name          = var.repo_name
}
