/******************************************************************************

Function:     CalculatedLoanInterest_Orchestrator

Type:         Glue
SubType:      Workflow  

Description:  This Terraform module has code to create Glue WorkFlow that 
              orchestrates the run of the daiuly interest and the DR Bank 
              Extracts.

Todo:         Add the ability to add scheduled tasks via actions.
******************************************************************************/

resource "aws_glue_workflow" "glue_workflow" {
  name = "${var.prefix}_${var.name}"
  description = var.description
  tags        = var.tags
}
resource "aws_glue_trigger" "glue_trigger" {
  for_each    = {
    for i,v in var.actions:
    i => v
  } 
  name = "trig_${var.prefix}_${each.value.job_name}_${each.key}" #"${each.value.trigger_name}"
  description = each.value.trigger_description
  type = each.value.trigger_type
  # Only adds the schedule if we provide one ...
  schedule = each.value.schedule
  workflow_name = aws_glue_workflow.glue_workflow.name
  dynamic "predicate" {
    for_each = each.value.predicate
    content {
      dynamic "conditions" {
        for_each = predicate.value.conditions
        content {
          job_name = "${var.prefix}_${conditions.value.predicate_job_name}"
          state    = "${conditions.value.state}"
        }
      }
    }
  }
  actions {
    job_name = "${var.prefix}_${each.value.job_name}"
  }
}

/******************************************************************************

Change History:

Name        Date        Description     
********    ********    *******************************************************
santhoshi   20230701    Initial code review and check-in. 
ffortunato  20230820    Looped through actions (all except first.)
ffortunato  20230831    Lopping through everything.
******************************************************************************/