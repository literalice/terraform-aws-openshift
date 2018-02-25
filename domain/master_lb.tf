data "aws_elb" "master" {
  name  = "${var.master_private_lb_name}"
}
