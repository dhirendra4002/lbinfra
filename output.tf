output "inst" {
  value = aws_instance.inst.*.id
}

output "sub" {
  value = aws_subnet.sub.*.id
}

output "vpc1" {
  value = aws_vpc.vpc1.id
}