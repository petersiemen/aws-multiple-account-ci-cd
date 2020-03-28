# aws-multiple-account-ci-cd

##### Ready to used template of a production grade multi account structure for AWS

* Central configuration of users and access permissions in a dedicated **identity account**
* Clear separation of production and development by using 2 independent accounts
* Effective use of a ci/cd pipeline in a shared services account for automatic git push based deployments into development and production
* Automatic feature branch deployments into development    


## AWS multiple account structure

### master account
AWS Organization owner for **consolidated billing** and for **service control policies** to 
configure availability for every account in the organzation.  

### identity account
The identity account is the access point for developers and admins into the AWS console.
From the identity account they switch to the other AWS accounts (shared services, development, production, logging)
into the appropriate IAM roles.
##### used services 
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