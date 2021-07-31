resource "aws_security_group" "tomcat" {
  name        = "tomcat"
  description = "Allow tomcat inbound traffic"
  vpc_id      = aws_vpc.petclinic.id

  ingress {
    description      = "tomcat from VPC"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    security_groups      = ["${aws_security_group.alb.id}"]

}
  ingress {
    description      = "tomcat from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.bastion.id}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.envname}-tomcat-sg"
  }
}

#user_data

data "template_file" "init" {
  template = "${file("tomcat_install.sh")}"


  }


#ec2
resource "aws_instance" "tomcat" {
  ami           = "{$var.ami}" #"ami-00bf4ae5a7909786c"
  instance_type = "{$var.type}"
  subnet_id = "{$aws_subnet.privatesubnets[0].id}"
  key_name = "{$aws_key_pair.peclininc.id}"
  vpc_security_group_ids =["{$aws_security_group.tomcat.id}"]
  user_data = data.template_file.init.rendered
  tags = {
    Name = "{$var.envname}-tomcat"
  }
}
