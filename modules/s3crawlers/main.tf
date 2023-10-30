/******************************************************************************

Function:     s3crawlers

Type:         Glue

Description:  This Terraform module has code to create Crawler for Glue jobs 
******************************************************************************/



resource "aws_glue_crawler" "glue_crawler" {
 
  database_name = var.crawlerdatabase
  name          = "${var.source_bucket_name}.${var.projectnameold}.${var.name}"
  role          = var.gluejob_arn
  tags          = var.tags

  s3_target {
    path = var.path
  }
}
