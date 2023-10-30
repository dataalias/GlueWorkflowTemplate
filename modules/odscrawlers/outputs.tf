output "crawler_arns" {
  value       = aws_glue_crawler.glue_crawler
  description = "The narn of the created crawlers"
}