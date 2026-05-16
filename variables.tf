variable "instance_type" {
  description = "Tamanho da instância EC2"
  type        = string
  default     = "t2.micro" # Elegível para o nível gratuito da AWS
}

variable "ami_id" {
  description = "ID da AMI (Sistema Operacional). Este ID é do Ubuntu 22.04 LTS em us-east-1"
  type        = string
  default     = "ami-0c7217cdde317cfec" 
}