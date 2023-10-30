output "crawler_arns" {
  value       = aws_glue_crawler.glue_crawler
  description = "The narn of the created crawlers"
}



output "crawler_bucket" {
  value       = var.source_bucket_name
  description = "The narn of the created crawlers"
}
output "crawler_project" {
  value       = var.projectnameold
  description = "The narn of the created crawlers"
}

output "crawler_name" {
  value       = var.name
  description = "The narn of the created crawlers"
}

output "crawler_full_name" {
  value       = "${var.source_bucket_name}.${var.projectnameold}.${var.name}"
  description = "The narn of the created crawlers"
}
