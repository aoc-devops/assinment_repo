variable "key" {
  type = string
  default = "public-all1.pem"
}

variable "sg" {
    type = list(string)
    default = ["sg-09c70134f8a8888e5"]
}
variable "subnet" {
    type = string
    default = "subnet-0f47dbd08c7897442"
  
}

variable "ami-id" {
  type = string
  default = "ami-09b9e25b6db1d130c"
}

variable "instance" {
  type = string
  default = "t2.micro"
}