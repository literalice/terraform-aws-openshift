data "aws_elb" "master" {
  name  = "${var.master_lb_name}"
}
