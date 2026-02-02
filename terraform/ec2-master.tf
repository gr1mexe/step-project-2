resource "aws_instance" "jenkins_master" {
  ami           = var.ami_id
  instance_type = var.instance_type

 key_name = aws_key_pair.jenkins.key_name

  vpc_security_group_ids = [aws_security_group.jenkins.id]

  user_data = file("${path.module}/user-data/jenkins-master.sh")

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "jenkins-master"
  }
}
