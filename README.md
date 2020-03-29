# aws-multiple-account-ci-cd

##### Ready to used template of a production grade multi account structure for AWS

* Central configuration of users and access permissions in a dedicated **identity account**
* Clear separation of production and development by using 2 independent accounts
* Effective use of a ci/cd pipeline in a shared services account for automatic git push based deployments into development and production
* Automatic feature branch deployments into development    


## AWS multiple account structure

### master account
AWS Organization owner for **consolidated billing** and for **service control policies** to 
configure the available AWS services for every account in the organization.

We use the master account as well as the central account to configure IAM users.
From the master account IAM users can switch to the other AWS accounts (shared services, development, production)
into the appropriate IAM roles. 
> In order to achieve an even higher level of security one can *eject* the IAM users into yet 
> another AWS account. We keep the configuration of IAM users in the master account for simplicity for now. 
##### used services
* Organizations
* IAM

### shared services account 
##### used services 
* IAM
* CodeCommit 
* CodeBuild
* CodePipeline 
* S3 artifact store for CodeBuild and CodePipeline 

### development account
##### used services 
* S3 bucket for static website hosting
* API Gateway 
* Lambda
* SES
* SNS
* DynamoDB

### production account
##### used services 
* S3 bucket for static website hosting
* API Gateway 
* Lambda
* SES
* SNS
* DynamoDB