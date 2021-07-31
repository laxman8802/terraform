
resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.petclinic.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
 
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.envname}-bastion-sg"
  }
  
}



#key
resource "aws_key_pair" "peclininc" {
  key_name   = "petclinic-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCbQzh2LojQWGl3hA0YkKs5n3xB+UnNSZP0bR1xj/yX1tjWgT2tNe17riVc+BiVJ8FKPU0x5JEN1WISVDkRGSyZuuOUxUwrtqqozsPGVEMG8iyqCp4NoCwuXu4+hox4ijIXQtJHKDCytVvYQGkX/GLNhkEm6SiKkTQlB/XgaO7ur/RMEy+SvJhDBdPzFUlZ+oEi1KAwHMCF5aPbkWmp4wV2zT5wvCqntI5RXMoIjsd4uiD9jZD2qlON85zhQdE3pLqDgdn6p+Gw4ydhKE8Cat0tCmoh0lpuu5n1v449cTIs2kqVAh4CZVdUFABmFvGIRJJHymqx78quiHgtpCVhG8IpxobDr7uS7WtobODXGcsim6wTfpLUogseQOPQqH+VZFKfrfgnKGr9Ppzea4U5Yu4NZ5VlvG7hH5GzcJWe0WNAeO6YCQUX/42qKRl8nNLy72bz1uOCU6CDSyAzgC+k+Gu2ANsQw1FfCX5ThCmUaAZUA3opf2znqosH+SWVUBg6Pk= Dharma@Dharma"

}
#ec2
resource "aws_instance" "bastion" {
  ami           = "{$var.ami}" #"ami-00bf4ae5a7909786c"
  instance_type = "{$var.type}"
  subnet_id = "{$aws_subnet.pubsubnet[0].id}"
  key_name = "{$aws_key_pair.peclininc.id}"
  vpc_security_group_ids =["{$aws_security_group.bastion.id}"]
  tags = {
    Name = "{$var.envname}-bastion"
  }
}


