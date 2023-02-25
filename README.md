# Homelab for testing out various Kubernetes deployments

This repository provides a Terraform script to create 3 Libvirt virtual machines using the dmacvicar/libvirt provider. The script will also install CentOS 8 Stream on each VM. Additionally, there is a cluster.yml file that can be used to create an RKE cluster with these three VMs.

Prerequisites
Before running the script and cluster.yml file, you'll need to:

1. Have Terraform installed on your machine
2. Have the dmacvicar/libvirt provider installed on your machine
3. Have Libvirt installed on your server/laptop
4. Populate the cloud-init config with a password to set up the VMs
5. Have RKE installed on your machine

Usage
Creating the Libvirt VMs
To create the Libvirt VMs:

1. Clone this repository to your local machine
2. Navigate to the cloned directory
3. Modify the variables.tf file with your desired configuration options (such as the number of VMs, the VM names, etc.)
4. Populate the cloud-init config with a password
5. Run terraform init to initialize the provider
6. Run terraform plan to preview the changes that Terraform will make
7 Run terraform apply to apply the changes and create the VMs
8. After running the script, you should see the new VMs in your Libvirt manager.

Creating the RKE Cluster
To create the RKE cluster with the three VMs:

1. Navigate to the cloned directory containing the cluster.yml file
2. Modify the nodes section of the cluster.yml file with the IP addresses of the three Libvirt VMs
3. Run rke up cluster.yml to create the RKE cluster
4. After running the rke up command, you should have a new RKE cluster with the three Libvirt VMs as nodes.

Caveats:

1. There is no CNI specified in the RKE cluster.yml file, I did this on purpose. If you need a fun CNI to install checkout Kube-Router https://github.com/cloudnativelabs/kube-router

2. I ran into a few issues with the libvirt provider, here are the links to those issues (If you run into any).

https://github.com/simon3z/virt-deploy/issues/8#issuecomment-73111541
https://github.com/dmacvicar/terraform-provider-libvirt/issues/446
https://ostechnix.com/solved-cannot-access-storage-file-permission-denied-error-in-kvm-libvirt/
https://github.com/dmacvicar/terraform-provider-libvirt/issues/546#issuecomment-612983090



License
This code is licensed under the MIT License. Feel free to use, modify, and distribute it as you see fit. If you find any issues, please feel free to submit an issue or pull request.

Acknowledgments
Thanks to dmacvicar for providing the libvirt Terraform provider, and to Rancher for providing RKE.
