# Bash script to create an SSH key and save it to Azure Key Vault, prior to running an ARM template to create a VNET and Jumpbox.
# SSH and Key Vault code from https://github.com/starkfell/100DaysOfIaC/blob/master/articles/day.68.manage.access.to.linux.vms.using.key.vault.part.1.md

# check that arguments for Location and Resource Group have been supplied
if (( "$#" != 2)) 
then
    echo "Please supply the Location you wish the resources to be created in, the name of the Resource Group, and your private SSH key"
    echo "For example:"
    echo "bash vnet-and-jumpbox.sh  westus2"
exit 1
fi

# set the location for the Resource Group and its name
location=$1
resourceGroup=$2

# create a new Azure Resource Group for the VNET, Jumpbox, etc
printf "\n>> Creating a new Resource Group, \"${resourceGroup}\" in \"${location}\"...\n"
az group create --location $location  --name $resourceGroup --output table


# Create the VNET, Jumpbox, and related resources, by invoking the ARM template
printf "\n>>  Creating a new Azure deployment called 'deployVNETandJumpbox in $location...\n"
az deployment group create \
  --name  deployVNETandJumpbox \
  --resource-group $resourceGroup \
  --template-file vnet-and-jumpbox.json \
  --parameters vnet-and-jumpbox-parameters.json 






