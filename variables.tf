
variable "credentials_file" {
  type = string
  description = "google service account key in json"
}

variable "project_name" {
  type        =  string
  description = "The name of the project to instanciate the instance at."
}

variable "region_name" {
  type        =  string
  description = "The region that this terraform configuration will instanciate at."
}

variable "zone_name" {
  type        =  string
  description = "The zone that this terraform configuration will instanciate at."
}

variable "machine_name" { 
  type = string
  description = "name of vm without random jibberish"
  default = "lockdown"
}

variable "machine_size" {
  type        =  string
  description = "The size that this instance will be."
}

variable "disk_size_gb" {
  description = "Boot disk size in GB"
}

variable "image_name" {
  type        =  string
  description = "The kind of VM this instance will become"
}

variable "username" {
  type        = string
  description = "The name of the user that will be used to remote exec the script"
}

variable "private_key_path" {
  type        =  string
  description = "The path to the private key used to connect to the instance"
}

variable "public_key_path" {
  type        =  string
  description = "The path to the public key used to connect to the instance"
}





