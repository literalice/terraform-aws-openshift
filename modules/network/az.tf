data "aws_availability_zones" "available" {
  state = "available"
}

locals  {
  availability_zones = ["${split(",", length(var.availability_zones) > 0 ? join(",", var.availability_zones) : join(",", data.aws_availability_zones.available.names))}"]
}
