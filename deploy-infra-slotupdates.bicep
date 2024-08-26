@description('Paramters of App name')
param appName string

@description('Paramters of appServicePlan name')
param appServicePlanName string

@description('Paramters of appServicePlanResourceGroup name')
param appServicePlanResourceGroupName string

@description('Parameters for Deployment Slots')
param deploySlots array = []

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. The site config object.')
param siteConfig object = {}

resource existingApp 'Microsoft.Web/sites@2023-12-01' existing = {
  name: appName
}

resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' existing = {
  name: appServicePlanName
  scope: resourceGroup(appServicePlanResourceGroupName)
}

resource appSlots 'Microsoft.Web/sites/slots@2023-12-01' = [for (deployslot, index) in deploySlots: {
  name: '${deployslot}-${index}'
  parent: existingApp
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: siteConfig
  }
}]
