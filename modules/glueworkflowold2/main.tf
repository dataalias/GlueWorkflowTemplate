/******************************************************************************

Function:     glueworkflows

Type:         Glue

Description:  This Terraform module has code to create Glue WorkFlow
Daily Launch Transaction.
******************************************************************************/

resource "aws_glue_workflow" "glue_workflow" {
  name = "${var.env}_${var.projectnameold}_${var.name}"
  description = var.description
  tags        = var.tags
}

resource "aws_glue_trigger" "glue_trigger_1" {
  name     = "${aws_glue_workflow.glue_workflow.name}_OnDemand"
  type     = "ON_DEMAND"
  workflow_name = aws_glue_workflow.glue_workflow.name

  actions {
    job_name = var.action1
  }
}/*
# Being a bad monkey taking out the IS till i can look at it more ...
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
}*/

# Status successful set to IS run crawler prod-ascent-datalake.LaunchLoanServicing.AscentDailyTransactions
resource "aws_glue_trigger" "glue_trigger_3" {
  name     = "${aws_glue_workflow.glue_workflow.name}_3"
  type     = "CONDITIONAL"
  workflow_name = aws_glue_workflow.glue_workflow.name
 
  predicate {
    conditions {
      job_name = var.action1 #var.datahubupdater_is
      state    = "SUCCEEDED"
    }
  }
  actions {
    #AscentDailyTransactions
    crawler_name  = "${var.source_bucket_name}.${var.projectnameold}.AscentDailyTransactions" #${var.crawlername}"

  }
}

resource "aws_glue_trigger" "glue_trigger_4" {
  name     = "${aws_glue_workflow.glue_workflow.name}_4"
  type     = "CONDITIONAL"
  workflow_name = aws_glue_workflow.glue_workflow.name
 
  predicate {
    conditions {
      #AscentDailyTransactions
      crawler_name  = "${var.source_bucket_name}.${var.projectnameold}.AscentDailyTransactions" #${var.crawlername}"
      crawl_state   = "SUCCEEDED"
    }
  }
  actions {
    job_name  = var.action2

  }
}


resource "aws_glue_trigger" "glue_trigger_5" {
  name     = "${aws_glue_workflow.glue_workflow.name}_5"
  type     = "CONDITIONAL"
  workflow_name = aws_glue_workflow.glue_workflow.name
 
  predicate {
    conditions {
      job_name      = var.action2
      state         = "SUCCEEDED"
    }
  }
  actions {
    job_name  = var.datahubupdater_il
    arguments = var.job_parameters_il
  }
}

resource "aws_glue_trigger" "glue_trigger_6" {
  name     = "${aws_glue_workflow.glue_workflow.name}_6"
  type     = "CONDITIONAL"
  workflow_name = aws_glue_workflow.glue_workflow.name
 
  predicate {
    
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

