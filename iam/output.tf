output "secret_key" {
  value = "${aws_iam_access_key.new_user.secret}"
}


output "access_key" {
  value = "${aws_iam_access_key.new_user.id}"
}