output "instance_ids" {
  value = [for instance in aws_instance.test_instance : instance.id]
}