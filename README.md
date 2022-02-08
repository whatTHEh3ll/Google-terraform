# Google Cloud Virtual Machines with terraform

##### Create an Ed25519 Elliptic Curve ssh key (for Google)
```
ssh-keygen -t ed25519 -f Google

```

#### connect to remote vm with custom key, with Google being custom key with user root
```
ssh root@<public_ip> -i Google  
```

##### get a list of google vms
```
gcloud compute images list

```

#### Get GCP service account for terrafrom
###### reference link
[https://gmusumeci.medium.com/how-to-create-a-service-account-for-terraform-in-gcp-google-cloud-platform-f75a0cf918d1](https://gmusumeci.medium.com/how-to-create-a-service-account-for-terraform-in-gcp-google-cloud-platform-f75a0cf918d1)

#### configure remote backend for google

###### reference link
[https://medium.com/swlh/terraform-securing-your-state-file-f6c4e13f02a9](https://medium.com/swlh/terraform-securing-your-state-file-f6c4e13f02a9)
##### steps below for remote state with versioning

```
# create gcp bucket
$ gsutil mb -p project_name gs://bucket_name

# list buckets
$ gsutil ls

# get versioning for bucket
$ gsutil versioning get gs://bucket_name
gs://bucket_name: Suspended

# enable versioning
$ gsutil versioning set on gs://my_bucket
Enabling versioning for gs://my_bucket/...

# test versioning exists
$ gsutil versioning get gs://my_bucket
gs://my_bucket: Enabled

# encrypting state with python
$ python3 -c 'import os;import base64;print(base64.b64encode(os.urandom(32)).decode("utf-8"))'
# output 123456789123456789123456789

```
##### create backend.tf
```
terraform {
  backend "gcs" {
    bucket  = "my_bucket"
    prefix  = "my_project/state"
    # output of python encryption below example
    encryption_key = "123456789123456789123456789"
  }
}
```
##### regular terrform commands
```
terraform console
terraform fmt
terraform init
terraform init -reconfigure
terraform plan 

# formats plan to no color removes funny characters
terraform plan -no-color > tfplan.txt

terraform validate
terraform apply -auto-approve
terraform destroy -auto-approve

# output to formated json (jq needs to be installed) run after apply
terraform show -json | jq . > state.json

# target a specific terraform resource
terraform plan -target resource.name 
terraform apply -auto-approve

```

##### example terraform.tfvars place in folder with main.tf
```
# Variables that are dependendent on the user are declared here

credentials_file = "../../google-credentials/path/to/credentials.json"

project_name = "project-id-12345"

username = "root"

region_name = "us-central1"

zone_name = "us-central1-a"

public_key_path = "../../path/to/publickey.pub"

private_key_path = "../../path/to/privatekey"

image_name = "ubuntu-os-cloud/ubuntu-1804-bionic-v20210315a"

machine_size = "f1-micro"

disk_size_gb = "30"

```


##### verify pre emptive instance with gcloud cli

```
gcloud config set project [PROJECT-ID]
```

```
gcloud compute instances describe
```

##### output should be..

```
scheduling:
  automaticRestart: false
  onHostMaintenance: TERMINATE
  preemptible: true
...

### enable oslogin on running instance
```
gcloud compute instances add-metadata [INSTANCE_NAME] --metadata enable-oslogin=TRUE
```