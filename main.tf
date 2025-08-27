
resource "aws_instance" "ec2" {
  ami           = "ami-00ca32bbc84273381"  
  instance_type = "t2.micro"
  key_name      = "avery-dynamodb.pem"      

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
}


resource "aws_security_group" "ec2_sg" {
  name        = "avery_ec2_sg"
  description = "Allow SSH from home"
  vpc_id      = "vpc-0b82246c89936c3f2"

  ingress {
    description = "SSH from home"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
  }

 egress {
   from_port        = 0
   to_port          = 0
   protocol         = "-1"
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_dynamodb_table" "demo_table" {
  name         = "demo-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}