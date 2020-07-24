# VNET-and-jumpbox
The script *vnet-and-jumpbox.sh* provisions these resources on Azure:

* A VNET with two subnets
* A jumpbox (i.e., a bastion host), with a Security Group that limits access to SSH from a named source IP

## Prerequisites
This script is designed to be run on macOS and has not been tested on any other systems. To run the script successfully you need to have:

* An Azure Subscription

* The Azure CLI on your local machine

## Set-up
### Sign in to Azure via the CLI
``AZ login``

### Create an SSH key-pair if you don't have one already
```
ssh-keygen \
    -m PEM \
    -t rsa \
    -b 4096 \
    -C "azureuser@jumpbox" \
    -f ~/.ssh/jumpbox 
```

### Update vnet-and-jumpbox-parameters.json with the appropriate values
At a minimum, you need to update these parameters, or the script won't run:

* subscriptionIDnumber
* localIP
* publicKey (for example, the public key you created above at ~/.ssh/jumpbox.pub)

You can find your ``subscriptionIDnumber`` (and any other Azure resource IDs) easily by using the [Resource Explorer](https://github.com/starkfell/100DaysOfIaC) service in Azure.


### Run the script
``bash vnet-and-jumpbox.sh  westus2 newapplication``

Then, you can access your jumbbox server, with SSH as normal.

``ssh azureuser@{public IP of your VM} -i ~/.ssh/jumpbox``
