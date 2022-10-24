variable "region" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "instance_type" {
  description = "Type of Cnosdb EC2 instance to provision"
  default     = "t3.medium"
}

variable "storage_size" {
  description = "cnosdb storage size"
  default     = 1024
}

variable "amis" {
  description = "ami for all instances"
  default     = "ami-0c11c4153b9234ac2"
}

variable "usedby_tags" {
  description = "ami for all instances"
  default     = "cnsodb trial"
}
