provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "k8s-keys" {
  key_name   = "k8s-keys"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCyCdFDpfAxU64icfBI2GtSGseGkWwFfKuyoo9mSs4vYgT7O35xzFfuEq7WwaDbrSEUKI57cEHcr2buFRiv0DrrvevJFdPNMW9uqcSyipI6HnxaL+EWYeicZsbxJMbRgqwoe+whewMO4B+apS/ZwUYn1POpT3sDuz9HidyTmP37Q/2U4SlTOwBCi6XsE8mZ7iQ2wYkfTs5yCo516PeoGocEzZ6lPPbUBxDLeIeEWpdSwfKxDKL371OCZkNwIKOANFmGhT1nacM5sgSK92q/MJiQrJmzecl1H/88YIwRHXhKSTwb1igYFZZzcJ+98LHLcyaiQ39WCVD711D2qI0JfHobmDs6OrPSCdCekRD8CxlJmoLZ/UWiCMXcm8ivIgEbJCDahWckDyZydkFHiapSnfthO2czb9tfp0YcyYXf0xUhK1Z3tx9mScmvEJnt+kdDrtDogJ6ILht3bkLnfQhltxA5Nvvaie5zxJIOc1cncXOURu/eJE0EgHNVhpuSRks2Ioc= gustavodefaria@MacBook-Pro-de-Gustavo.local"
}

resource "aws_security_group" "k8s-scg" {

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    cidr_blocks   = ["0.0.0.0/0"]
    from_port     = 0
    to_port       = 0
    protocol      = "-1"
  }
}

resource "aws_instance" "kubernetes-worker" {
  ami           = "ami-0747bdcabd34c712a"
  instance_type = "t3.medium"
  key_name      = "k8s-keys"
  count         = 2
  tags          = {
    name = "k8s"
    type = "worker"
  }
  security_groups = ["${aws_security_group.k8s-scg.name}"]
}

resource "aws_instance" "kubernetes-master" {
  ami           = "ami-0747bdcabd34c712a"
  instance_type = "t3.medium"
  key_name      = "k8s-keys"
  count         = 1
  tags          = {
    name = "k8s"
    type = "master"
  }
  security_groups = ["${aws_security_group.k8s-scg.name}"]
}