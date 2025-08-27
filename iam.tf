# IAM Role for EC2
resource "aws_iam_role" "ec2_role" {
  name = "ec2_dynamodb_role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# IAM Policy to allow DynamoDB access
resource "aws_iam_policy" "dynamodb_policy" {
  name        = "EC2DynamoDBPolicy"
  description = "Allow EC2 to access DynamoDB"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:ListTables",
        "dynamodb:DescribeTable",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem",
        "dynamodb:Scan",
        "dynamodb:Query"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}

# Instance Profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_dynamodb_profile"
  role = aws_iam_role.ec2_role.name
}
