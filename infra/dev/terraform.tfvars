/*
File Name: terraform.tfvars

Purpose: This file contains the variables that are used in the terraform code.

Envrionment: dev
*/

env                     = "dev"

artifact_bucket         = "dev-de-assets"
branch                  = "feat-BankAccountingExtracts"
parameter_store         = "EnvironmentStage"
source_bucket_name      = "dev-datalake"
repository_name         = "dehDataFeeds"
deploy_project_name     = "deLaunchDataFeeds"
unit_test_project_name  = "deLaunchDataFeedsUnitTest"
#projectname             = "DRB"
# We should use these new values. The project isn't about DR Bank. 
# Its about Loan Servicing and sending Bank Feeds (to any bank)
projectname             = "LaunchLoanServicing"
#projectcode             = "LSBE"
datawarehouse           = "devadw"
projectnameold          = "LaunchLoanServicing"
odsmerge                = "ODS_Merge"
datahubupdater_il       = "DataHub_Updater_IL"
datahubupdater_if       = "DataHub_Updater_IF"
datahubupdater_is       = "DataHub_Updater_IS"
database_secret_datahub = "dev/devadw/DataHub/Glue_svc"
database_secret_ODS     = "dev/devadw/ODS/Glue_svc"
crawlerdatabase         = "S3"
connection              = "ODS"
schema                  = "loan"
#glueworkflow_snapshot      = "devadw_LaunchLoanServicing_DailySnapshot_LoadtoODS"
gluejob_arn                 = "arn:aws:iam::MyAccount:role/AWSGlueServiceRoledevAdw"

glueworkflows = [
  {
    name        	 = "CalculatedLoanInterest_Orchestrator"
    description 	 = "Orchestrates the generation of the daily interest calculation and monthly files for DR Bank."
    actions        = [
      # Note the initial action is being setup within the glueworkflow modules.
      
      { 
        #trigger_name = "trig_1"
        trigger_type = "SCHEDULED"
        schedule     = "cron(0 18 * * ? *)"
        job_name  = "run_CalculatedInterest_proc"
        trigger_description = "This is the initial trigger for the CalculatedLoanInterest_Orchestrator workflow. It will run the run_CalculatedInterest_proc job. The trigger is scheduled to run at 18:00 UTC, 11:00 AM PST."
        predicate = []
      },
      { 
        #trigger_name = "trig_2"
        trigger_type = "CONDITIONAL"
        schedule = ""
        predicate = [{
          conditions = [{
            predicate_job_name = "run_CalculatedInterest_proc"
            state = "SUCCEEDED"
          }]
        }]
        job_name       = "CalculatedLoanInterest_DailyInterest_pyextract"
        trigger_description = "This trigger will run the CalculatedLoanInterest_DailyInterest_pyextract job when the run_CalculatedInterest_proc job has succeeded."
      },
      { 
        #trigger_name = "trig_3"
        trigger_type = "CONDITIONAL"
        schedule = ""
        predicate = [{
          conditions = [{
            predicate_job_name = "CalculatedLoanInterest_DailyInterest_pyextract"
            state = "SUCCEEDED"
          }]
        }]
        job_name       = "CalculatedLoanInterest_MonthlyTransactions_pyextract"
        trigger_description = "This trigger will run the CalculatedLoanInterest_MonthlyTransactions_pyextract job when the CalculatedLoanInterest_DailyInterest_pyextract job has succeeded."
      },
      { 
        #trigger_name = "trig_3"
        trigger_type = "CONDITIONAL"
        schedule = ""
        predicate = [{
          conditions = [{
            predicate_job_name = "CalculatedLoanInterest_MonthlyTransactions_pyextract"
            state = "SUCCEEDED"
          }]
        }]
        job_name       = "CalculatedLoanInterest_EndofMonthDailyInterest_pyextract"
        trigger_description = "This dev trigger will run the CalculatedLoanInterest_EndofMonthDailyInterest_pyextract job when the CalculatedLoanInterest_MonthlyTransactions_pyextract job has succeeded."
      }
    ]

    job_parameters_merge = {
    "--PROC_NAME"             = "ods.loan.usp_CalculateDailyLoanInterest"
	  }
	  job_parameters_il    = {
		"--DH:StatusCode"         = "IL"
		"--DH:IssueId"            = "WF:IssueId"
	  }
	  job_parameters_if    = {
		"--DH:StatusCode"         = "IF"
		"--DH:IssueId"            = "WF:IssueId"
	  }
  }
]

gluejobs = [
  {
    name        = "run_CalculatedInterest_proc"
    description = "This job runs the Daily Calculated interest for DR Bank"
    jobname     = "DRB_run_CalculatedInterest_proc.py"
  },
  {
    name        = "CalculatedLoanInterest_DailyInterest_pyextract"
    description = "Extracts the DR Bank daily interest feed / extract"
    jobname     = "DRB_CalculatedLoanInterest_DailyInterest_pyextract.py"
  },
  {
    name        = "CalculatedLoanInterest_MonthlyTransactions_pyextract"
    description = "Extracts the DR Bank daily interest feed"
    jobname     = "DRB_CalculatedLoanInterest_PeriodTransactions_pyextract.py"
  },
  {
    name        = "CalculatedLoanInterest_EndofMonthDailyInterest_pyextract"
    description = "Extracts the DR Bank Monthly Interest Date Extract"
    jobname     = "DRB_CalculatedLoanInterest_EndOfMonthDailyInterest_pyextract.py"
  }
]

sparkjobs = [
  {
    name        = "DailySnapshot_pySparkLoadtoODSStage"
    description = "Snapshot Preprocessor "
    jobname     = "LaunchLoanServicing_DailySnapshot_Preprocessor.py"
  },
  {
    name        = "DailyTransactions_pySparkLoadtoODSStage"
    description = "Load transaction data to Stage"
    jobname     = "LaunchLoanServicing_DailyTransactions_pySparkLoadtoODSStage.py"
  },
  {
    name        = "LaunchLoanBatchDaily_pySparkLoadtoODSStage"
    description = "Load daily batch data to Stage "
    jobname     = "LaunchLoanServicing_LaunchLoanBatchDaily_pySparkLoadtoODSStage.py"
  }
]

gluejobsold = [
  {
    
    name        = "DailySnapshot_Preprocessor"
    description = "Snapshot Preprocessor "
    jobname     = "LaunchLoanServicing_DailySnapshot_Preprocessor.py"
  },
  {
    # 1 is me testing the transaction preprocesor
    name        = "DailyTransactions_Preprocessor"
    description = "Transaction Preprocessor "
    jobname     = "LaunchLoanServicing_DailyTransactions_Preprocessor.py"
  },
  {
    name        = "LaunchLoanBatchDaily_Preprocessor"
    description = "Preprocess Launch Feeds "
    jobname     = "LaunchLoanServicing_LaunchLoanBatchDaily_Preprocessor.py"
  }
]

gluejobsgeneral = [
  {
    name        = "ODS_Merge"
    description = "Merge Stage to ODS "
    jobname     = "ODS_Merge.py"
  },
  {
    name        = "DataHub_Updater_IL"
    description = "Datahub Helper function "
    jobname     = "DataHub_Updater.py"
  },
  {
    name        = "DataHub_Updater_IF"
    description = "Datahub Helper function "
    jobname     = "DataHub_Updater.py"
  },
  {
    name        = "DataHub_Updater_IS"
    description = "Datahub Helper function "
    jobname     = "DataHub_Updater.py"
  }
]

s3crawlers = [
  {
    name      = "DailySnapshot"
    path      = "s3://dev--datalake/Conformed/Launch Loan Servicing/ Daily Snapshot"
  },
  {
    name      = "DailyTransactions"
    path      = "s3://dev--datalake/Conformed/Launch Loan Servicing/ Daily Transactions"
  },
  {
    name      = "LaunchLoanBatchDaily"
    path      = "s3://dev--datalake/Conformed/Launch Loan Servicing/Launch Loan Batch Daily"
  }
]

odscrawlers = [
  {
    name      = "LoanDailySnapshot"
    path      = "loandailysnapshot"
  },
  {
    name      = "LoanDailyTransactions"
    path      = "loandailytransactions"
  }
]

glueworkflowsold = [
   {
	   env = "dev"
	   name        		 = "DailySnapshot_LoadtoODS"
	   description 		 = "This workflow is used to load the Launch data data to ODS"
	   action1				 = "LaunchLoanServicing_DailySnapshot_Preprocessor"
	   crawlername 		 = "DailySnapshot"
	   action2				 = "LaunchLoanServicing_DailyTransactions_pySparkLoadtoODSStage"
	   job_parameters_merge = {
		"--PROC_NAME"             = "ods.stagells.usp_LoadDailySnapshot"

	  }
	  job_parameters_is    = {
		"--DH:StatusCode"         = "IS"
		"--DH:IssueId"            = "WF:IssueId"
		"--DH:IssueName"          = "WF:IssueName"
		"--DH:DataLakePath"       = "WF:DataLakePath"

	  }
	  job_parameters_il    = {
		"--DH:StatusCode"         = "IL"
		"--DH:IssueId"            = "WF:IssueId"

	  }
	  job_parameters_if    = {
		"--DH:StatusCode"         = "IF"
		"--DH:IssueId"            = "WF:IssueId"

	  }
  
   }/*
   ,{# This is the glue workflow to load the goal delivered laucnhc servicing data <depricating for now>
    env = "dev"
	   name        			 = "LaunchLoanBatchDaily_LoadtoODS"
	   description 			 = "This workflow is used to load the Launch data data to ODS"
	   action1				 = "LaunchLoanBatchDaily_Preprocessor"
	   crawlername 			 = "LaunchLoanBatchDaily"
	   action2				 = "LaunchLoanBatchDaily_pySparkLoadtoODSStage"
	   job_parameters_merge = {
		"--PROC_NAME"             = "ods.stagells.usp_LoadLaunchLoanBatchDaily"

	  }
	  job_parameters_is    = {
		"--DH:StatusCode"         = "IS"
		"--DH:IssueId"            =  "WF:IssueId"
		"--DH:IssueName"          = "WF:IssueName"
		"--DH:DataLakePath"       = "WF:DataLakePath"

	  }
	  job_parameters_il    = {
		"--DH:StatusCode"         = "IL"
		"--DH:IssueId"            =  "WF:IssueId"

	  }
	  job_parameters_if    = {
		"--DH:StatusCode"         = "IF"
		"--DH:IssueId"            =  "WF:IssueId"
	  }
   }*/
  ]   

  glueworkflowsold2 = [
   
   {
	   #Launch Transaction Data to ODS.
     env = "dev"
	   name        			 = "DailyTransactions_LoadtoODS"
	   description 			 = "This workflow is used to load the Launch data data to ODS"
	   action1				   = "LaunchLoanServicing_DailyTransactions_Preprocessor"
	   crawlername 			 = "DailyTransactions"
	   action2				   = "LaunchLoanServicing_DailyTransactions_pySparkLoadtoODSStage"
	  
	  job_parameters_il    = {
		"--DH:StatusCode"         = "IL"
		"--DH:IssueId"            =  "WF:IssueId"

	  }
	  job_parameters_if    = {
		"--DH:StatusCode"         = "IF"
		"--DH:IssueId"            =  "WF:IssueId"

	  }
	
   }
  ]   

/******************************************************************************

    Change Log

Date      Name          Description
********  ************* *******************************************************

20230801  ffortunato    Initial Version
20230807  ffortunato    fix-InterestCalculation
20230822  ffortunato    enh-EoM Daily Interest Data
******************************************************************************/
