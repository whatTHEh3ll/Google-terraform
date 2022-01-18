#!/bin/bash

terraform apply -auto-approve \
&& sleep 120; ansible-playbook provision.yml --vault-password-file=/home/coney/ansible-PASSWORDS/MASTER.txt -i hosts.ini -u root -vv
