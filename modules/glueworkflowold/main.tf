/******************************************************************************

Function:     glueworkflows

Type:         Glue

Description:  This Terraform module has code to create Glue WorkFlow
        This loads the Snapshot laucnh data each day.
******************************************************************************/

resource "aws_glue_workflow" "glue_workflow" {
  name = "${var.env}_${var.projectnameold}_${var.name}"
  description = var.description
  tags        = var.tags
}
# Initiates the workflow run if the trigger is ready to be activated.
resource "aws_glue_trigger" "glue_trigger_1" {
  name     = "${aws_glue_workflow.glue_workflow.name}_OnDemand"
  type     = "ON_DEMAND"
  workflow_name = aws_glue_workflow.glue_workflow.name

  actions {
    job_name = var.action1
  }
}
# If conditions is met then the workflow will run the next job
resource "aws_glue_trigger" "glue_trigger_2" {
  name     = "${aws_glue_workflow.glue_workflow.name}_2"
  type     = "CONDITIONAL"
  workflow_name = aws_glue_workflow.glue_workflow.name

  predicate {
    conditions {
      job_name = var.action1
      state    = "SUCCEEDED"
    }
  }

  actions {
    job_name  = var.datahubupdater_is
    arguments = var.job_parameters_is
  }
}

# s3 Crawlers will run.
resource "aws_glue_trigger" "glue_trigger_3" {
  name     = "${aws_glue_workflow.glue_workflow.name}_3"
  type     = "CONDITIONAL"
  workflow_name = aws_glue_workflow.glue_workflow.name
 
  predicate {
    conditions {
      job_name = var.datahubupdater_is
      state    = "SUCCEEDED"
    }
  }
  actions {
    #crawler_name  = "${var.source_bucket_name}.${var.projectnameold}.${var.crawlername}"
    crawler_name  = "${var.source_bucket_name}.${var.projectnameold}.LaunchLoanBatchDaily"

  }
}

resource "aws_glue_trigger" "glue_trigger_4" {
  name     = "${aws_glue_workflow.glue_workflow.name}_4"
  type     = "CONDITIONAL"
  workflow_name = aws_glue_workflow.glue_workflow.name
 
  predicate {
    conditions {
      #crawler_name  = "${var.source_bucket_name}.${var.projectnameold}.${var.crawlername}"
      crawler_name  = "${var.source_bucket_name}.${var.projectnameold}.LaunchLoanBatchDaily"
      crawl_state   = "SUCCEEDED"
    }
  }
  actions {
    #This should be the pySparkLoad.
    #action2				   = "LaunchLoanServicing_AscentDailySnapshot_pySparkLoadtoODSStage"
    job_name  = var.action2

  }
}

resource "aws_glue_trigger" "glue_trigger_5" {
  name     = "${aws_glue_workflow.glue_workflow.name}_5"
  type     = "CONDITIONAL"
  workflow_name = aws_glue_workflow.glue_workflow.name
 
  predicate {
    conditions {
      job_name       = var.action2
      state          = "SUCCEEDED"
    }
  }
  actions {
    job_name  = var.odsmerge
    arguments = var.job_parameters_merge
  }
}

resource "aws_glue_trigger" "glue_trigger_6" {
  name     = "${aws_glue_workflow.glue_workflow.name}_6"
  type     = "CONDITIONAL"
  workflow_name = aws_glue_workflow.glue_workflow.name
 
  predicate {
    conditions {
      job_name      = var.odsmerge
      state         = "SUCCEEDED"
    }
  }
  actions {
    job_name  = var.datahubupdater_il
    arguments = var.job_parameters_il
  }
}

resource "aws_glue_trigger" "glue_trigger_7" {
  name     = "${aws_glue_workflow.glue_workflow.name}_7"
  type     = "CONDITIONAL"
  workflow_name = aws_glue_workflow.glue_workflow.name
 
  predicate {
    conditions {
      job_name      = var.odsmerge
      state         = "FAILED"
    }
    conditions {
      job_name      = var.action2
      state         = "FAILED"
    }
  }
  actions {
    job_name  = var.datahubupdater_if
    arguments = var.job_parameters_if
  }
}

