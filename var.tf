variable "subnet_cidr" {
  description = "creating 2 subnets"
  type        = list(string)
  default = [
    "10.0.4.0/24",
    "10.0.5.0/24",
  ]
}