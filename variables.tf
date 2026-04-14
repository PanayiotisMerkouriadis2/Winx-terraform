variable "ec2-policy-arns" {
  description = "list of IAM policy arns to attach to winx-task-listing-app-ec2-instance-role"
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier",
  ]

}
