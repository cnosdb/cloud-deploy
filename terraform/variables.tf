variable "region" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "instance_type" {
  description = "Type of Cnosdb EC2 instance to provision"
  default     = "t3.medium"
}

variable "key_pub" {
  default = "id_rsa.pub"
}

variable "key_private" {
  default = "id_rsa"
}

variable "key_path" {
  default = "~/.ssh"
}

variable "storage_size" {
  description = "cnosdb storage size"
  default     = 1024
}

variable "amis" {
  description = "ami for cnosdb"
  default     = "ami-0c12a1ae1e12cf7ad"
}

variable "usedby_tags" {
  description = "ami for all instances"
  default     = "cnsodb trial"
}
