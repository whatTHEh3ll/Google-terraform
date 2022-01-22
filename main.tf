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


# We create a public IP address for our google compute instance to utilize
resource "google_compute_address" "static" {
  name = "vm-public-address"
  project = var.project_name
  region = var.region_name
  depends_on = [ google_compute_firewall.firewall ]
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 4
}

# This creates the google instance
resource "google_compute_instance" "vm_instance" {
  name         = "preemptible-${random_id.instance_id.hex}"
  machine_type = var.machine_size
  tags = ["allow-http", "allow-https", "allow-dns", "allow-tor", "allow-ssh", "allow-2277", "allow-mosh", "allow-whois", "allow-openvpn", "allow-wireguard", "allow-speedtest"]  # FIREWALL
  boot_disk {
    initialize_params {
      image = var.image_name
      size  = var.disk_size_gb
    }
  }
# premptive instance
  scheduling {
    preemptible       = true
    automatic_restart = false
  }

  network_interface {
    network       = "default"
    # Associated our public IP address to this instance
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



