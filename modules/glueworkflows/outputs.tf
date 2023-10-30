output "Glue_Workflows" {
  value       = aws_glue_workflow.glue_workflow
  description = "The name of the Glue workflow"
}

output "all_triggers" {
  value = [ for trigger in aws_glue_trigger.glue_trigger : trigger.name ]
}

output "Prefix" {
  value       = var.prefix
  description = "The prefix for each name"
}
