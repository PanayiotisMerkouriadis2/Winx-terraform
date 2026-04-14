provider "aws" {
  region = "eu-west-2"
}

resource "aws_elastic_beanstalk_application" "example_app" {
  name        = "winx-task-listing-app"
  description = "Task listing app"
}

resource "aws_elastic_beanstalk_environment" "example_app_environment" {
  name        = "winx-task-listing-app-environment"
  application = aws_elastic_beanstalk_application.example_app.name

  # This page lists the supported platforms
  # we can use for this argument:
  # https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html#platforms-supported.docker
  # Updated version to latest according do the above link. previous = v4.0.1
  solution_stack_name = "64bit Amazon Linux 2023 v4.12.1 running Docker"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.example_app_ec2_instance_profile.name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = "winx-elastic-beanstalk-deployment"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t3.micro"
  }
}

resource "aws_iam_instance_profile" "example_app_ec2_instance_profile" {
  name = "winx-task-listing-app-ec2-instance-profile"
  role = aws_iam_role.example_app_ec2_role.name
}

resource "aws_iam_role" "example_app_ec2_role" {
  name = "winx-task-listing-app-ec2-instance-role"

  // Allows the EC2 instances in our EB environment to assume (take on) this 
  // role.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "EC2_policies" {
  for_each = toset(var.ec2-policy-arns)

  role       = aws_iam_role.example_app_ec2_role.name
  policy_arn = each.value
}



# list all three policy arns seperately, incase above does not work
# resource "aws_iam_role_policy_attachment" "beanstalk_web_tier" {
#   role       = aws_iam_role.example_app_ec2_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
# }

# resource "aws_iam_role_policy_attachment" "beanstalk_web_tier" {
#   role       = aws_iam_role.example_app_ec2_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
# }

# resource "aws_iam_role_policy_attachment" "beanstalk_web_tier" {
#   role       = aws_iam_role.example_app_ec2_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
# }
