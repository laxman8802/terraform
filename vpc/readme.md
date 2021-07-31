Inastll the terraform and setup the path 
Install the aws cli and configure the keys
profile for the aws cli :  your user home directory .aws
config/credentials

arguments(input)/ attributes (output)

terraform.exe plan --var-file dev.tfvars
what is tfstates ?
all ready created resources

create the scenario to force replacement 

we are going to craet the vpc using terraform
provider: aws
region: 
resources: vpc
cidr:10.1.0.0/16
enable dns= true

subnets
pubsubnets = ["10.1.0.0/24","10.1.1.0/24","10.1.2.0/24"]
enable piblic ip
private subnets = ["10.1.3.0/24","10.1.4.0/24","10.1.5.0/24"]
data subnets = ["10.1.6.0/24","10.1.7.0/24","10.1.8.0/24"]

igw
attach = 

EIP
nat = pubsubnet[0]

route tables
pubroute
privateroute

associate the pubsubnets with the igw in pubroute
associate the privatesubnets with nat-gw in privateroute





terraform init 
terraform plan
terraform apply
