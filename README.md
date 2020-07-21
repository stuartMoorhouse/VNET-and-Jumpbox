# VNET-and-jumpbox
The script *vnet-and-jumpbox.sh* provisions these resources on Azure:

* A VNET with two subnets
* A jumpbox (i.e., a bastion host), with a Security Group that limits access to SSH from a named source IP
* A Key Vault store to hold the SSH key for the jumpbox

The SSH key-management part is derived from Day 68 - Managing Access to Linux VMs using Azure Key Vault - Part 1 from 100DaysOfIaC. Please see that series for information about secure key management.

If you already have an SSH key that you would like to use for the jumpbox, you can also call the ARM template *vnet-and-jumpbox.json" directly.

## Prerequisites
This script is designed to be run on MacOSX and has not been tested on any other systems. To run the script successfully you need to have:

* An Azure Subscription
* The Azure CLI on your local machine
* The command line utitily sshpass (if you are intending on using Key Vault)

## Provisioning the reources
This can be done in two ways:

* Creating the Key Vault store, the VNET and the Jumpbox via the bash script
* Creating the VNET and the Jumpbox with the ARM template directly

## Creating the Key Vault store, the VNET and the Jumpbox with the bash script
### Sign in to Azure via the CLI

### Update vnet-and-jumpbox-parameters.json with the appropriate values

### Run the script
This script creates the SSH key, which is then stored in Key Vault. Then, it deploys the ARM template (vnet-and-jumpbox.json).

### Retrieving the keys from Key Vault
When you want to access your Jumpbox, you can return the private key from Key Vault with 
``az keyvault secret show``

## Creating the VNET and the Jumpbox with the ARM template
### Sign in to Azure via the CLI

### Assign the value of your SSH public key to a bash environment variable

### Update vnet-and-jumpbox-parameters.json with the appropriate values

### Deploy the ARM template via the Azure CLI

