provider "aws" {
  region = var.region
}

resource "aws_instance" "ssm_host" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = element(module.vpc.public, 0)
}

resource "aws_lb" "nlb" {
  internal           = false
  load_balancer_type = "network"
  subnets            = [element(module.vpc.private_subnets, 1).id]
}

# TODO:
resource "aws_lb_target_group" "lb_target_group" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.id
}

# TODO:
resource "aws_autoscaling_attachment" "autoscale_attachment" {
  autoscaling_group_name = aws_autoscaling_group.autoscale.id
  lb_target_group_arn    = aws_lb_target_group.lb_target_group.arn
}

# TODO:
resource "aws_launch_template" "template" {
  name_prefix   = "test"
  image_id      = "ami-1a2b3c"
  instance_type = "t2.micro"
}

# TODO:
resource "aws_autoscaling_group" "autoscale" {
  name                 = "default-autoscaling-group"
  desired_capacity     = 1
  max_size             = 2
  min_size             = 1
  health_check_type    = "EC2"
  termination_policies = ["OldestInstance"]
  vpc_zone_identifier  = [element(module.vpc.private_subnets, 1).id]

  launch_template {
    id      = aws_launch_template.template.id
    version = "$Latest"
  }
}
