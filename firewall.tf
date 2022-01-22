resource "google_compute_firewall" "firewall" {
    name = "allow-ssh"
    network = "default"

    allow {
        protocol = "tcp"
        ports = ["22", "2277"]
    }
    source_ranges = ["0.0.0.0/0"] 
    target_tags = ["allow-ssh"]

}

resource "google_compute_firewall"  "allow_http" {
    name = "allow-http"
    network = "default"

    allow {
        protocol = "tcp"
        ports = ["80"]
    }
    source_ranges = ["0.0.0.0/0"] 
    target_tags = ["allow-http"]

}

resource "google_compute_firewall" "allow_https" {
    name = "allow-https"
    network = "default"

    allow {
        protocol = "tcp"
        ports = ["443"]
    }
    source_ranges = ["0.0.0.0/0"] 
    target_tags = ["allow-https"]

}

resource "google_compute_firewall" "allow_dns" {
    name = "allow-dns"
    network = "default"

    allow {
        protocol = "tcp"
        ports = ["53"]
    }
    source_ranges = ["0.0.0.0/0"] 
    target_tags = ["allow-dns"]

}

resource "google_compute_firewall" "allow_whois" {
    name = "allow-whois"
    network = "default"

    allow {
        protocol = "tcp"
        ports = ["43"]
    }
    source_ranges = ["0.0.0.0/0"] 
    target_tags = ["allow-whois"]

}

resource "google_compute_firewall" "allow_tor" {
    name = "allow-tor"
    network = "default"

    allow {
        protocol = "tcp"
        ports = ["9050-9051"]
    }
    source_ranges = ["0.0.0.0/0"] 
    target_tags = ["allow-tor"]

}

resource "google_compute_firewall"  "allow_mosh" {
    name = "allow-mosh"
    network = "default"

    allow {
        protocol = "udp"
        ports = ["60015"]
    }
    source_ranges = ["0.0.0.0/0"] 
    target_tags = ["allow-mosh"]

}

resource "google_compute_firewall"  "allow_openvpn" {
    name = "allow-openvpn"
    network = "default"

    allow {
        protocol = "udp"
        ports = ["1194"]
    }
    source_ranges = ["0.0.0.0/0"] 
    target_tags = ["allow-openvpn"]

}

resource "google_compute_firewall"  "allow_wireguard" {
    name = "allow-wireguard"
    network = "default"

    allow {
        protocol = "udp"
        ports = ["61951"]
    }
    
    source_ranges = ["0.0.0.0/0"]
    target_tags = ["allow-wireguard"]

}


resource "google_compute_firewall"  "allow_speedtest" {
    name = "allow-speedtest8080"
    network = "default"

    allow {
        protocol = "tcp"
        ports = ["8080", "5060"]
    }
    
    source_ranges = ["0.0.0.0/0"]
    target_tags = ["allow-speedtest"]

}

