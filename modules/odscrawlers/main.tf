/******************************************************************************

Function:     s3crawlers

Type:         Glue

Description:  This Terraform module has code to create Crawler for Glue jobs 
******************************************************************************/



resource "aws_glue_crawler" "glue_crawler" {
 
  database_name = var.crawlerdatabase
  name          = "${lower(var.connection)}.${lower(var.schema)}.${var.path}"
  role          = var.gluejob_arn
  tags          = var.tags

  jdbc_target {
    connection_name = var.connection
    path = "${var.connection}/${var.schema}/${var.name}"
  }
}
