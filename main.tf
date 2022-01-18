#https://www.middlewareinventory.com/blog/create-linux-vm-in-gcp-with-terraform-remote-exec/

# This is the provider used to spin up the gcloud instance
provider "google" {
  project = var.project_name
  region  = var.region_name
  zone    = var.zone_name
  credentials = file(var.credentials_file)
}

# Locks the version of Terraform for this particular use case
terraform {
  required_version = ">= 1.1.3"
}

# Generate a random vm name
resource "random_string" "vm-name" {
  length  = 12
  upper   = false
  number  = false
  lower   = true
  special = false
}

# Machine Name
locals {
  vm-name = "${random_string.vm-name.result}-vm"
}

# We create a public IP address for our google compute instance to utilize
resource "google_compute_address" "static" {
  name = "vm-public-address"
  project = var.project_name
  region = var.region_name
  depends_on = [ google_compute_firewall.firewall ]
}

resource "google_compute_instance" "vm_instance" {
  name         = local.vm-name
  machine_type =  var.machine_size
  zone         =  var.zone_name
  tags         = ["allow-ssh" ]  # FIREWALL
  boot_disk {
    initialize_params {
      image = var.image_name
      size  = var.disk_size_gb
    }
  }
  
  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static.address
    }
  }
  
  provisioner "remote-exec" {
    connection {
      host        = google_compute_address.static.address
      type        = "ssh"
      user        = var.username
      timeout     = "500s"
      private_key = file(var.private_key_path)
    }
    inline = [
      "sudo apt-get update -y", 
      "sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' upgrade"
    ]
  }
  # Ensure firewall rule is provisioned before server, so that SSH doesn't fail.
  depends_on = [ google_compute_firewall.firewall, google_compute_firewall.allow_http, google_compute_firewall.allow_https, google_compute_firewall.allow_dns ]
  service_account {
    scopes = ["compute-ro"]
  }
  metadata = {
    ssh-keys = "${var.username}:${file(var.public_key_path)}"
  }
}