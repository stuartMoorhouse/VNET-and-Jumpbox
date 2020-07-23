# Bash script to create an SSH key and save it to Azure Key Vault, prior to running an ARM template to create a VNET and Jumpbox.
# SSH and Key Vault code from https://github.com/starkfell/100DaysOfIaC/blob/master/articles/day.68.manage.access.to.linux.vms.using.key.vault.part.1.md

# check that arguments for Location and Resource Group have been supplied
if (( "$#" != 2 )) 
then
    echo "Please supply the Location you wish the resources to be created in and the name of the Resource Group"
    echo "For example:"
    echo "bash vnet-and-jumpbox.sh  westus2 newapplication"
exit 1
fi

# set the location for the Resource Group and its name
location=$1
resourceGroup=$2

# create a new Azure Resource Group for the VNET, Jumpbox, etc
printf "\n>> Creating a new Resource Group, \"${resourceGroup}\" in \"${location}\"...\n"
az group create --location $location  --name $resourceGroup --output table

# create an SSH key-pair and store it in an Azure Key Vault
# generate the key, then store it as a variable before deleting it
printf "\n>> Generating a random password for the SSH key...\n"
SSH_KEY_PASSWORD=$(openssl rand -base64 20)

printf "\n>> Creating an SSH key-pair with that password...\n"
ssh-keygen  -t rsa  -b 4096  -f ~/.ssh/create-peered-app -N $SSH_KEY_PASSWORD

printf "\n>> Copying the keys into Bash environment variables and then deleting them from ~/.ssh/ \n"
SSH_PUBLIC_KEY=$(cat ~/.ssh/create-peered-app.pub) && \
SSH_PRIVATE_KEY=$(cat ~/.ssh/create-peered-app) && \
rm -rf ~/.ssh/create-peered-app*

# create the Azure Key Vault
keyVaultName="${resourceGroup}keyvault27779"
printf "\n>>  Creating a new Azure Key Vault called $keyVaultName...\n"
az keyvault create  --name $keyVaultName   --resource-group $resourceGroup  --output table

# Add the public key, private, password to the Key Vault as secrets
az keyvault secret set \
    --name create-peered-app-pub \
    --vault-name "$keyVaultName" \
    --value "$SSH_PUBLIC_KEY" \
    --output none

 az keyvault secret set \
    --name create-peered-app \
    --vault-name  "$keyVaultName" \
    --value "$SSH_PRIVATE_KEY" \
    --output none 

 az keyvault secret set \
    --name create-peered-app-password \
    --vault-name "$keyVaultName" \
    --value "$SSH_KEY_PASSWORD" \
    --output none 

# Create the VNET, Jumpbox, and related resources, by invoking the ARM template
printf "\n>>  Creating a new Azure deployment called 'deployVNETandJumpbox in $location...\n"
az deployment group create \
  --name  deployVNETandJumpbox \
  --resource-group $resourceGroup \
  --template-file vnet-and-jumpbox.json \
  --parameters vnet-and-jumpbox-parameters.json \
  --parameters sshPublicKey="$SSH_PUBLIC_KEY"








