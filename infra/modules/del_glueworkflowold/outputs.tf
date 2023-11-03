output "Glue_Workflows" {
  value       = aws_glue_workflow.glue_workflow
  description = "The name of the Glue workflow"
}

output "Action_02" {
  value       = var.action2
  description = "02 Action of workflow."
}
