resource "aws_key_pair" "jenkins" {
  key_name   = "jenkins-key"
  public_key = file("/Users/artem.manko/.ssh/id_ed25519.pub")
}