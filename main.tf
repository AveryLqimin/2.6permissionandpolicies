
resource "aws_instance" "ec2" {
  ami           = "ami-00ca32bbc84273381"  
  instance_type = "t2.micro"
  key_name      = "avery-dynamodb-ec2.pem"      

  subnet_id               = "subnet-079c82f8b0060e6b7"
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

#from here

resource "aws_dynamodb_table" "bookinventory" {
  name         = "avery01-bookinventory"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "ISBN"
  range_key = "Genre"

  attribute {
    name = "ISBN"
    type = "S"
  }

  attribute {
    name = "Genre"
    type = "S"
  }
}

# Optional: populate with dummy data using aws_dynamodb_table_item
resource "aws_dynamodb_table_item" "dummy1" {
  table_name = aws_dynamodb_table.bookinventory.name
  hash_key   = "ISBN"
  range_key  = "Genre"
  item       = <<ITEM
{
  "ISBN": {"S": "978-1234567890"},
  "Genre": {"S": "Fiction"},
  "Title": {"S": "Terraform Adventures"},
  "Author": {"S": "Avery"}
}
ITEM
}

resource "aws_dynamodb_table_item" "dummy2" {
  table_name = aws_dynamodb_table.bookinventory.name
  hash_key   = "ISBN"
  range_key  = "Genre"
  item       = <<ITEM
{
  "ISBN": {"S": "978-0987654321"},
  "Genre": {"S": "Non-Fiction"},
  "Title": {"S": "Cloud Engineering 101"},
  "Author": {"S": "Avery"}
}
ITEM
}