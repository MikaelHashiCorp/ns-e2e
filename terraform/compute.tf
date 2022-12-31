resource "aws_instance" "server" {
  ami                    = "ami-065df81c5fb4b315b"
  instance_type          = var.instance_type
  key_name               = module.keys.key_name
  vpc_security_group_ids = [aws_security_group.primary.id]
  count                  = var.server_count
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  availability_zone      = var.availability_zone

  user_data = file("${path.root}/userdata/ubuntu-bionic.sh")

  # Instance tags
  tags = {
    Name           = "${local.random_name}-server-${count.index}"
    ConsulAutoJoin = "auto-join"
    SHA            = var.nomad_sha
    User           = data.aws_caller_identity.current.arn
  }
}

resource "aws_instance" "client_ubuntu_bionic_amd64" {
  #ami                    = data.aws_ami.ubuntu_bionic_amd64.image_id
  ami                    = "ami-065df81c5fb4b315b"  # 2022/12/29
  instance_type          = var.instance_type
  key_name               = module.keys.key_name
  vpc_security_group_ids = [aws_security_group.primary.id]
  count                  = var.client_count_ubuntu_bionic_amd64
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  availability_zone      = var.availability_zone

  user_data = file("${path.root}/userdata/ubuntu-bionic.sh")

  # Instance tags
  tags = {
    Name           = "${local.random_name}-client-ubuntu-bionic-amd64-${count.index}"
    ConsulAutoJoin = "auto-join"
    SHA            = var.nomad_sha
    User           = data.aws_caller_identity.current.arn
  }
}

resource "aws_instance" "client_windows_2016_amd64" {
  # ami                    = data.aws_ami.windows_2016_amd64.image_id
  ami                    = "ami-0df4c3f341684f1c8"	
  instance_type          = var.instance_type
  key_name               = module.keys.key_name
  vpc_security_group_ids = [aws_security_group.primary.id]
  count                  = var.client_count_windows_2016_amd64
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  availability_zone      = var.availability_zone

  user_data = file("${path.root}/userdata/windows-2016.ps1")

  # Instance tags
  tags = {
    Name           = "${local.random_name}-client-windows-2016-${count.index}"
    ConsulAutoJoin = "auto-join"
    SHA            = var.nomad_sha
    User           = data.aws_caller_identity.current.arn
  }
}

# resource "aws_instance" "client_windows_2019_amd64" {
#   ami                    = "ami-045ebefa6f43595ab"  # 2022/09/07
#   # ami                    = "ami-02259e3619ab4b8ce"  # 2022/05/09
#   instance_type          = var.instance_type
#   key_name               = module.keys.key_name
#   vpc_security_group_ids = [aws_security_group.primary.id]
#   count                  = var.client_count_windows_2019_amd64
#   iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
#   availability_zone      = var.availability_zone

#   user_data = file("${path.root}/userdata/windows-2019.ps1")

#   # Instance tags
#   tags = {
#     Name           = "${local.random_name}-client-windows-2019-${count.index}"
#     ConsulAutoJoin = "auto-join"
#     SHA            = var.nomad_sha
#     User           = data.aws_caller_identity.current.arn
#   }
# }

data "aws_ami" "ubuntu_bionic_amd64" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["nomad-e2e-*"]
  }
}

data "aws_ami" "windows_2016_amd64" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["nomad-e2e-windows-2016-amd64-*"]
  }
}

# data "aws_ami" "windows_2019_amd64" {
#   most_recent = true
#   owners      = ["self"]

#   filter {
#     name   = "name"
#     values = ["nomad-e2e-windows-2019-amd64-*"]
#   }
# }
