output "instance_name" {
  value = google_compute_instance.vm_instance.name
}

output "ip" {
value = google_compute_address.static.address
}

resource "local_file" "inventory" {
  filename = "hosts.ini"
    content     = <<-EOF
    [Google]
    ${google_compute_address.static.address}

    [all:vars]
    ansible_python_interpreter=/usr/bin/python3
    EOF
}


