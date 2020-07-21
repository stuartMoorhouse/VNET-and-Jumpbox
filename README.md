# VNET-and-jumpbox
The script *vnet-and-jumpbox.sh* provisions these resources on Azure:

* A VNET with two subnets
* A jumpbox (i.e., a bastion host), with a Security Group that limits access to SSH from a named source IP
* A Key Vault store to hold the SSH keys and password for the jumpbox

The SSH key-management part is derived from [Day 68 - Managing Access to Linux VMs using Azure Key Vault - Part 1](https://github.com/starkfell/100DaysOfIaC/blob/master/articles/day.69.manage.access.to.linux.vms.using.key.vault.part.2.md) from [100DaysOfIaC](https://github.com/starkfell/100DaysOfIaC). Please see that series for more information about options for key management in Azure.

If you already have an SSH key that you would like to use for the jumpbox, you can also call the ARM template *vnet-and-jumpbox.json* directly.

## Prerequisites
This script is designed to be run on macOS and has not been tested on any other systems. To run the script successfully you need to have:

* An Azure Subscription

* The Azure CLI on your local machine

## Provisioning the resources

This can be done in two ways:

​	1) Creating the Key Vault store, the VNET and the Jumpbox with the bash script 

​	2) Creating just the VNET and the Jumpbox with the ARM template 

## Set-up
### Sign in to Azure via the CLI
``AZ login``

### Update vnet-and-jumpbox-parameters.json with the appropriate values
At a minimum, you need to update these parameters, or the script won't run:

* subscriptionIDnumber
* localIP

You can find your ``subscriptionIDnumber`` (and any other Azure resource IDs) easily by using the [Resource Explorer](https://github.com/starkfell/100DaysOfIaC) service in Azure.

## Option 1) Creating the Key Vault store, the VNET and the Jumpbox with the bash script
### Run the script
This script creates the SSH key, which is then stored in Key Vault. Then, it deploys the ARM template (*vnet-and-jumpbox.json*). You need to supply the Location you want your VNET, .etc, to be in, and a name for the Resource Group that will contain the new resources.

``bash vnet-and-jumpbox.sh  westus2 newapplication``

### Retrieving the keys from Key Vault
When you want to access your Jumpbox, you can return the private key from Key Vault with 
``az keyvault secret show -vault-name yourVaultName --name yourSecretName``

Then, you can access your jumbbox server, with SSH as normal:
TO DO


## Option 2) Creating the VNET and the Jumpbox with the ARM template
### Assign the value of your SSH public key to a bash environment variable
``SSH_PUBLIC_KEY=$(<location/of/your/public/key)``

### Deploy the ARM template via the Azure CLI
```
az deployment group create \
  --name deployVNETandJumpbox \
  --resource-group vnetandjumpbox \
  --template-file vnet-and-jumpbox.json \
  --parameters vnet-and-jumpbox-parameters.json \
  --parameters sshPublicKey="$SSH_PUBLIC_KEY"
```
Then, you can access your jumbbox server, with SSH as normal:
TO DO

