// common
targetScope = 'resourceGroup'

// parameters
////////////////////////////////////////////////////////////////////////////////

// common
@minLength(3)
@maxLength(6)
@description('A unique environment suffix (max 6 characters, alphanumeric only).')
param suffix string

@secure()
@description('A password which will be set on all SQL Azure DBs.')
param sqlPassword string // @TODO: Obviously, we need to fix this!

param resourceLocation string = resourceGroup().location

// tenant
param tenantId string = subscription().tenantId

// aks
param aksLinuxAdminUsername string // value supplied via parameters file

param prefix string = 'contosotraders'

param prefixHyphenated string = 'contoso-traders'

// sql
param sqlServerHostName string = deploySqlOnIaas ? '.${resourceLocation}.cloudapp.azure.com' : environment().suffixes.sqlServerHostname
param trustServerCertificate bool = deploySqlOnIaas ? true : false

// use param to conditionally deploy private endpoint resources
param deployPrivateEndpoints bool = false

// use param to conditionally deploy private endpoint resources
param deployVmBasedApis bool = false

// use param to conditionally deploy SQL on IAAS
param deploySqlOnIaas bool = false


// variables
////////////////////////////////////////////////////////////////////////////////

// key vault
var kvName = '${prefix}kv${suffix}'
var kvSecretNameProductsApiEndpoint = 'productsApiEndpoint'
var kvSecretNameProductsDbConnStr = 'productsDbConnectionString'
var kvSecretNameProfilesDbConnStr = 'profilesDbConnectionString'
var kvSecretNameStocksDbConnStr = 'stocksDbConnectionString'
var kvSecretNameCartsApiEndpoint = 'cartsApiEndpoint'
var kvSecretNameCartsInternalApiEndpoint = 'cartsInternalApiEndpoint'
var kvSecretNameCartsDbConnStr = 'cartsDbConnectionString'
var kvSecretNameImagesEndpoint = 'imagesEndpoint'
var kvSecretNameAppInsightsConnStr = 'appInsightsConnectionString'
var kvSecretNameUiCdnEndpoint = 'uiCdnEndpoint'
var kvSecretNameVnetAcaSubnetId = 'vnetAcaSubnetId'

// user-assigned managed identity (for key vault access)
var userAssignedMIForKVAccessName = '${prefixHyphenated}-mi-kv-access${suffix}'

// cosmos db (stocks db)
var stocksDbAcctName = '${prefixHyphenated}-stocks${suffix}'
var stocksDbName = 'stocksdb'
var stocksDbStocksContainerName = 'stocks'

// cosmos db (carts db)
var cartsDbAcctName = '${prefixHyphenated}-carts${suffix}'
var cartsDbName = 'cartsdb'
var cartsDbStocksContainerName = 'carts'

// app service plan (products api)
var productsApiAppSvcPlanName = '${prefixHyphenated}-products${suffix}'
var productsApiAppSvcName = '${prefixHyphenated}-products${suffix}'
var productsApiSettingNameKeyVaultEndpoint = 'KeyVaultEndpoint'
var productsApiSettingNameManagedIdentityClientId = 'ManagedIdentityClientId'

// sql azure (products db)
var productsDbServerName = '${prefix}-products${suffix}'
var productsDbName = 'productsdb'
var productsDbServerAdminLogin = 'localadmin'
var productsDbServerAdminPassword = sqlPassword

// sql azure (profiles db)
var profilesDbServerName = '${prefix}-profiles${suffix}'
var profilesDbName = 'profilesdb'
var profilesDbServerAdminLogin = 'localadmin'
var profilesDbServerAdminPassword = sqlPassword



// azure container app (carts api)
var cartsApiAcaName = '${prefixHyphenated}-carts${suffix}'
var cartsApiAcaEnvName = '${prefix}acaenv${suffix}'
var cartsApiAcaSecretAcrPassword = 'acr-password'
var cartsApiAcaContainerDetailsName = '${prefixHyphenated}-carts${suffix}'
var cartsApiSettingNameKeyVaultEndpoint = 'KeyVaultEndpoint'
var cartsApiSettingNameManagedIdentityClientId = 'ManagedIdentityClientId'

// azure container app (carts api - internal only)
var cartsInternalApiAcaName = '${prefixHyphenated}-intcarts${suffix}'
var cartsInternalApiAcaEnvName = '${prefix}intacaenv${suffix}'
var cartsInternalApiAcaSecretAcrPassword = 'acr-password'
var cartsInternalApiAcaContainerDetailsName = '${prefixHyphenated}-intcarts${suffix}'
var cartsInternalApiSettingNameKeyVaultEndpoint = 'KeyVaultEndpoint'
var cartsInternalApiSettingNameManagedIdentityClientId = 'ManagedIdentityClientId'

// storage account (product images)
var productImagesStgAccName = '${prefix}img${suffix}'
//JM- because of moving to $web
//var productImagesProductDetailsContainerName = 'product-details'
//var productImagesProductListContainerName = 'product-list'

// storage account (old website)
var uiStgAccName = '${prefix}ui${suffix}'

// storage account (new website)
var ui2StgAccName = '${prefix}ui2${suffix}'

// storage account (image classifier)
var imageClassifierStgAccName = '${prefix}ic${suffix}'
var imageClassifierWebsiteUploadsContainerName = 'website-uploads'

// cdn
var cdnProfileName = '${prefixHyphenated}-cdn${suffix}'
var cdnImagesEndpointName = '${prefixHyphenated}-images${suffix}'
var cdnUiEndpointName = '${prefixHyphenated}-ui${suffix}'
var cdnUi2EndpointName = '${prefixHyphenated}-ui2${suffix}'

// azure container registry
var acrName = '${prefix}acr${suffix}'

// load testing service
var loadTestSvcName = '${prefixHyphenated}-loadtest${suffix}'

// application insights
var logAnalyticsWorkspaceName = '${prefixHyphenated}-loganalytics${suffix}'
var appInsightsName = '${prefixHyphenated}-ai${suffix}'

// portal dashboard
var portalDashboardName = '${prefixHyphenated}-dashboard${suffix}'

// aks cluster
var aksClusterName = '${prefixHyphenated}-aks${suffix}'
var aksClusterDnsPrefix = '${prefixHyphenated}-aks${suffix}'
var aksClusterNodeResourceGroup = '${prefixHyphenated}-aks-nodes-rg${suffix}'

// virtual network
var vnetName = '${prefixHyphenated}-vnet${suffix}'
var vnetAddressSpace = '10.0.0.0/16'
var vnetAcaSubnetName = 'subnet-aca'
var vnetAcaSubnetAddressPrefix = '10.0.0.0/23'
var vnetVmSubnetName = 'subnet-vm'
var vnetVmSubnetAddressPrefix = '10.0.2.0/23'
var vnetLoadTestSubnetName = 'subnet-loadtest'
var vnetLoadTestSubnetAddressPrefix = '10.0.4.0/23'
var vnetWebSubnetName = 'subnet-web'
var vnetWebSubnetAddressPrefix = '10.0.6.0/23'
var vnetDBSubnetName = 'subnet-db'
var vnetDBSubnetAddressPrefix = '10.0.8.0/23'
var vnetBastionSubnetName = 'AzureBastionSubnet'
var vnetBastionSubnetAddressPrefix = '10.0.10.0/23'

// VM-based docker APIs (JM+)
var productApiCname = '${prefixHyphenated}-prodapi${suffix}.${resourceLocation}.cloudapp.azure.com'
var cartApiCname = '${prefixHyphenated}-cartapi${suffix}.${resourceLocation}.cloudapp.azure.com'

// front door standard (JM+) images now web exposed
//var imagesCname = '${productImagesStgAccName}.z6.web.core.windows.net'
//var webStoreCname = '${prefixHyphenated}${suffix}.z6.web.core.windows.net'

// bastion
var bastionHostName = '${prefixHyphenated}-bastion${suffix}'

// jumpbox vm
var jumpboxNicName = '${prefixHyphenated}-jumpbox${suffix}'
var jumpboxVmName = 'jumpboxvm'
var jumpboxVmAdminLogin = 'localadmin'
var jumpboxVmAdminPassword = sqlPassword
var jumpboxVmShutdownScheduleName = 'shutdown-computevm-jumpboxvm'
var jumpboxVmShutdownScheduleTimezoneId = 'UTC'

// sql vm
var sqlVmPrefix = 'sqlvm' // this is different to the DbServerName variables as it needs to be shorter than 15 characters
var sqlVmAdminLogin = 'localadmin'
var sqlVmAdminPassword = sqlPassword
var sqlVmShutdownScheduleName = 'shutdown-computevm-sqlvm'
var sqlVmShutdownScheduleTimezoneId = 'UTC'

// private dns zone
var privateDnsZoneVnetLinkName = '${prefixHyphenated}-privatednszone-vnet-link${suffix}'

// chaos studio
var chaosKvExperimentName = '${prefixHyphenated}-chaos-kv-experiment${suffix}'
var chaosKvSelectorId = guid('${prefixHyphenated}-chaos-kv-selector-id${suffix}')
var chaosAksExperimentName = '${prefixHyphenated}-chaos-aks-experiment${suffix}'
var chaosAksSelectorId = guid('${prefixHyphenated}-chaos-aks-selector-id${suffix}')

// tags
var resourceTags = {
  Product: prefixHyphenated
  Environment: suffix
}

// resources
////////////////////////////////////////////////////////////////////////////////

//
// key vault
//

resource kv 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: kvName
  location: resourceLocation
  tags: resourceTags
  properties: {
    // @TODO: Hack to enable temporary access to devs during local development/debugging.
    accessPolicies: [
      {
        objectId: '31de563b-fc1a-43a2-9031-c47630038328'
        tenantId: tenantId
        permissions: {
          secrets: [
            'get'
            'list'
            'delete'
            'set'
            'recover'
            'backup'
            'restore'
          ]
        }
      }
    ]
    sku: {
      family: 'A'
      name: 'standard'
    }
    softDeleteRetentionInDays: 7
    tenantId: tenantId
  }

  // secret
  resource kv_secretProductsApiEndpoint 'secrets' = {
    name: kvSecretNameProductsApiEndpoint
    tags: resourceTags
    properties: {
      contentType: 'endpoint url (fqdn) of the products api'
      value: deployVmBasedApis ? newFrontDoor.outputs.VmProdApiEndpoint : ''
    }
  }

  // secret 
  resource kv_secretProductsDbConnStr 'secrets' = {
    name: kvSecretNameProductsDbConnStr
    tags: resourceTags
    properties: {
      contentType: 'connection string to the products db'
      value: 'Server=tcp:${productsDbServerName}${sqlServerHostName},1433;Initial Catalog=${productsDbName};Persist Security Info=False;User ID=${productsDbServerAdminLogin};Password=${productsDbServerAdminPassword};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=${trustServerCertificate};Connection Timeout=30;'
    }
  }

  // secret 
  resource kv_secretProfilesDbConnStr 'secrets' = {
    name: kvSecretNameProfilesDbConnStr
    tags: resourceTags
    properties: {
      contentType: 'connection string to the profiles db'
      value: 'Server=tcp:${profilesDbServerName}${sqlServerHostName},1433;Initial Catalog=${profilesDbName};Persist Security Info=False;User ID=${profilesDbServerAdminLogin};Password=${profilesDbServerAdminPassword};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=${trustServerCertificate};Connection Timeout=30;'
    }
  }

  // secret 
  resource kv_secretStocksDbConnStr 'secrets' = {
    name: kvSecretNameStocksDbConnStr
    tags: resourceTags
    properties: {
      contentType: 'connection string to the stocks db'
      value: stocksdba.listConnectionStrings().connectionStrings[0].connectionString
    }
  }

  // secret 
  resource kv_secretCartsApiEndpoint 'secrets' = if (!deployVmBasedApis) {
    name: kvSecretNameCartsApiEndpoint
    tags: resourceTags
    properties: {
      contentType: 'endpoint url (fqdn) of the carts api'
      value: !deployVmBasedApis ? cartsapiaca.properties.configuration.ingress.fqdn : ''
    }
  }

  // secret - different for VM based APIs
  resource kv_secretCartsApiEndpointvm 'secrets' = if (deployVmBasedApis) {
    name: kvSecretNameCartsApiEndpoint
    tags: resourceTags
    properties: {
      contentType: 'endpoint url (fqdn) of the carts api'
      value: newFrontDoor.outputs.VmCartApiEndpoint
    }
  }

  // secret
  resource kv_secretCartsInternalApiEndpoint 'secrets' = if (deployPrivateEndpoints && !deployVmBasedApis) {
    name: kvSecretNameCartsInternalApiEndpoint
    tags: resourceTags
    properties: {
      contentType: 'endpoint url (fqdn) of the (internal) carts api'
      value: (deployPrivateEndpoints && !deployVmBasedApis) ? cartsinternalapiaca.properties.configuration.ingress.fqdn : ''
    }
  }

  // secret
  resource kv_secretCartsDbConnStr 'secrets' = {
    name: kvSecretNameCartsDbConnStr
    tags: resourceTags
    properties: {
      contentType: 'connection string to the carts db'
      value: cartsdba.listConnectionStrings().connectionStrings[0].connectionString
    }
  }

  // secret JM amended
  resource kv_secretImagesEndpoint 'secrets' = {
    name: kvSecretNameImagesEndpoint
    tags: resourceTags
    properties: {
      contentType: 'endpoint url of the images cdn'
      value: 'https://${newFrontDoor.outputs.imagesEndpoint}'
    }
  }

  // secret
  resource kv_secretAppInsightsConnStr 'secrets' = {
    name: kvSecretNameAppInsightsConnStr
    tags: resourceTags
    properties: {
      contentType: 'connection string to the app insights instance'
      value: appinsights.properties.ConnectionString
    }
  }

  // secret
  resource kv_secretUiCdnEndpoint 'secrets' = {
    name: kvSecretNameUiCdnEndpoint
    tags: resourceTags
    properties: {
      contentType: 'endpoint url (cdn endpoint) of the ui'
      value: cdnprofile_ui2endpoint.properties.hostName
    }
  }

  // secret
  resource kv_secretVnetAcaSubnetId 'secrets' = if (deployPrivateEndpoints) {
    name: kvSecretNameVnetAcaSubnetId
    tags: resourceTags
    properties: {
      contentType: 'subnet id of the aca subnet'
      value: deployPrivateEndpoints ? vnet.properties.subnets[0].id : ''
    }
  }

  // access policies
  resource kv_accesspolicies 'accessPolicies' = {
    name: 'replace'
    properties: {
      // @TODO: I was unable to figure out how to assign an access policy to the AKS cluster's agent pool's managed identity.
      // Hence, that specific access policy will be assigned from a github workflow (using AZ CLI).
      accessPolicies: [
        {
          tenantId: tenantId
          objectId: userassignedmiforkvaccess.properties.principalId
          permissions: {
            secrets: [ 'get', 'list' ]
          }
        }
        // { JM- removed as not needed
        //   tenantId: tenantId
        //   objectId: aks.properties.identityProfile.kubeletidentity.objectId
        //   permissions: {
        //     secrets: [ 'get', 'list' ]
        //   }
        // }
      ]
    }
  }
}

resource kv_roledefinitionforchaosexp 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: kv
  // This is the Key Vault Contributor role
  // See https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#key-vault-contributor
  name: 'f25e0fa2-a7c8-4377-a976-54943a77a395'
}

resource kv_roleassignmentforchaosexp 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: kv
  name: guid(kv.id, chaoskvexperiment.id, kv_roledefinitionforchaosexp.id)
  properties: {
    roleDefinitionId: kv_roledefinitionforchaosexp.id
    principalId: chaoskvexperiment.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

resource userassignedmiforkvaccess 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' = {
  name: userAssignedMIForKVAccessName
  location: resourceLocation
  tags: resourceTags
}

//
// stocks db
//

// cosmos db account
resource stocksdba 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' = {
  name: stocksDbAcctName
  location: resourceLocation
  tags: resourceTags
  properties: {
    databaseAccountOfferType: 'Standard'
    enableFreeTier: false
    capabilities: [
      {
        name: 'EnableServerless'
      }
    ]
    locations: [
      {
        locationName: resourceLocation
      }
    ]
  }

  // cosmos db database
  resource stocksdba_db 'sqlDatabases' = {
    name: stocksDbName
    location: resourceLocation
    tags: resourceTags
    properties: {
      resource: {
        id: stocksDbName
      }
    }

    // cosmos db collection
    resource stocksdba_db_c1 'containers' = {
      name: stocksDbStocksContainerName
      location: resourceLocation
      tags: resourceTags
      properties: {
        resource: {
          id: stocksDbStocksContainerName
          partitionKey: {
            paths: [
              '/id'
            ]
          }
        }
      }
    }
  }
}

//
// carts db
//

// cosmos db account
resource cartsdba 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' = {
  name: cartsDbAcctName
  location: resourceLocation
  tags: resourceTags
  properties: {
    databaseAccountOfferType: 'Standard'
    enableFreeTier: false
    capabilities: [
      {
        name: 'EnableServerless'
      }
    ]
    locations: [
      {
        locationName: resourceLocation
      }
    ]
  }

  // cosmos db database
  resource cartsdba_db 'sqlDatabases' = {
    name: cartsDbName
    location: resourceLocation
    tags: resourceTags
    properties: {
      resource: {
        id: cartsDbName
      }
    }

    // cosmos db collection
    resource cartsdba_db_c1 'containers' = {
      name: cartsDbStocksContainerName
      location: resourceLocation
      tags: resourceTags
      properties: {
        resource: {
          id: cartsDbStocksContainerName
          partitionKey: {
            paths: [
              '/Email'
            ]
          }
        }
      }
    }
  }
}

//
// products api
//

// app service plan (linux)
resource productsapiappsvcplan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: productsApiAppSvcPlanName
  location: resourceLocation
  tags: resourceTags
  sku: {
    name: 'B1'
  }
  properties: {
    reserved: true
  }
  kind: 'linux'
}

// app service
resource productsapiappsvc 'Microsoft.Web/sites@2022-03-01' = {
  name: productsApiAppSvcName
  location: resourceLocation
  tags: resourceTags
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userassignedmiforkvaccess.id}': {}
    }
  }
  properties: {
    clientAffinityEnabled: false
    httpsOnly: true
    serverFarmId: productsapiappsvcplan.id
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|7.0'
      alwaysOn: true
      appSettings: [
        {
          name: productsApiSettingNameKeyVaultEndpoint
          value: kv.properties.vaultUri
        }
        {
          name: productsApiSettingNameManagedIdentityClientId
          value: userassignedmiforkvaccess.properties.clientId
        }
      ]
    }
  }
}

//
// products db
//

// sql azure server
resource productsdbsrv 'Microsoft.Sql/servers@2022-05-01-preview' = if (!deploySqlOnIaas) {
  name: productsDbServerName
  location: resourceLocation
  tags: resourceTags
  properties: {
    administratorLogin: productsDbServerAdminLogin
    administratorLoginPassword: productsDbServerAdminPassword
    publicNetworkAccess: 'Enabled'
  }

  // sql azure database
  resource productsdbsrv_db 'databases' =  {
    name: productsDbName
    location: resourceLocation
    tags: resourceTags
    sku: {
      capacity: 5
      tier: 'Basic'
      name: 'Basic'
    }
  }

  // sql azure firewall rule (allow access from all azure resources/services)
  resource productsdbsrv_db_fwlallowazureresources 'firewallRules' = {
    name: 'AllowAllWindowsAzureIps'
    properties: {
      endIpAddress: '0.0.0.0'
      startIpAddress: '0.0.0.0'
    }
  }

  // @TODO: Hack to enable temporary access to devs during local development/debugging.
  resource productsdbsrv_db_fwllocaldev 'firewallRules' = {
    name: 'AllowLocalDevelopment'
    properties: {
      endIpAddress: '255.255.255.255'
      startIpAddress: '0.0.0.0'
    }
  }
}

//
// profiles db
//

// sql azure server
resource profilesdbsrv 'Microsoft.Sql/servers@2022-05-01-preview' = if (!deploySqlOnIaas) {
  name: profilesDbServerName
  location: resourceLocation
  tags: resourceTags
  properties: {
    administratorLogin: profilesDbServerAdminLogin
    administratorLoginPassword: profilesDbServerAdminPassword
    publicNetworkAccess: 'Enabled'
  }

  // sql azure database
  resource profilesdbsrv_db 'databases' = {
    name: profilesDbName
    location: resourceLocation
    tags: resourceTags
    sku: {
      capacity: 5
      tier: 'Basic'
      name: 'Basic'
    }
  }

  // sql azure firewall rule (allow access from all azure resources/services)
  resource profilesdbsrv_db_fwl 'firewallRules' = {
    name: 'AllowAllWindowsAzureIps'
    properties: {
      endIpAddress: '0.0.0.0'
      startIpAddress: '0.0.0.0'
    }
  }
}

//
// carts api
//

// aca environment
resource cartsapiacaenv 'Microsoft.App/managedEnvironments@2022-06-01-preview' = if (!deployVmBasedApis) {
  name: cartsApiAcaEnvName
  location: resourceLocation
  tags: resourceTags
  sku: {
    name: 'Consumption'
  }
  properties: {
    zoneRedundant: false
  }
}

// aca
resource cartsapiaca 'Microsoft.App/containerApps@2022-06-01-preview' = if (!deployVmBasedApis) {
  name: cartsApiAcaName
  location: resourceLocation
  tags: resourceTags
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userassignedmiforkvaccess.id}': {}
    }
  }
  properties: {
    configuration: {
      activeRevisionsMode: 'Single'
      ingress: {
        external: true
        allowInsecure: false
        targetPort: 80
        traffic: [
          {
            latestRevision: true
            weight: 100
          }
        ]
      }
      registries: [
        {
          passwordSecretRef: cartsApiAcaSecretAcrPassword
          server: acr.properties.loginServer
          username: acr.name
        }
      ]
      secrets: [
        {
          name: cartsApiAcaSecretAcrPassword
          value: acr.listCredentials().passwords[0].value
        }
      ]
    }
    environmentId: cartsapiacaenv.id
    template: {
      scale: {
        minReplicas: 1
        maxReplicas: 10
        rules: [
          {
            name: 'http-scaling-rule'
            http: {
              metadata: {
                concurrentRequests: '3'
              }
            }
          }
        ]
      }
      containers: [
        {
          env: [
            {
              name: cartsApiSettingNameKeyVaultEndpoint
              value: kv.properties.vaultUri
            }
            {
              name: cartsApiSettingNameManagedIdentityClientId
              value: userassignedmiforkvaccess.properties.clientId
            }
          ]
          // using a public image initially because no images have been pushed to our private ACR yet
          // at this point. At a later point, our github workflow will update the ACA app to use the 
          // images from our private ACR.
          image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
          name: cartsApiAcaContainerDetailsName
          resources: {
            cpu: json('0.5')
            memory: '1.0Gi'
          }
        }
      ]
    }
  }
}

//
// product images
//
// JM removed containers as I hope will go in $web
//
// storage account (product images) - JM web exposed
resource productimagesstgacc 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: productImagesStgAccName
  location: resourceLocation
  tags: resourceTags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: false
  }

  // blob service
  resource productimagesstgacc_blobsvc 'blobServices' = {
    name: 'default'
  }
}

//
// main website / ui
// new website / ui
//

// storage account (main website)
resource uistgacc 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: uiStgAccName
  location: resourceLocation
  tags: resourceTags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: false
  }

  // blob service
  resource uistgacc_blobsvc 'blobServices' = {
    name: 'default'
  }
}

resource uistgacc_mi 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' = {
  name: 'DeploymentScript'
  location: resourceLocation
  tags: resourceTags
}

resource uistgacc_roledefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: subscription()
  // This is the Storage Account Contributor role, which is the minimum role permission we can give. 
  // See https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#:~:text=17d1049b-9a84-46fb-8f53-869881c3d3ab
  name: '17d1049b-9a84-46fb-8f53-869881c3d3ab'
}

// This requires the service principal to be in 'owner' role or a custom role with 'Microsoft.Authorization/roleAssignments/write' permissions.
// Details: https://learn.microsoft.com/en-us/answers/questions/287573/authorization-failed-when-when-writing-a-roleassig.html
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: uistgacc
  name: guid(resourceGroup().id, uistgacc_mi.id, uistgacc_roledefinition.id)
  properties: {
    roleDefinitionId: uistgacc_roledefinition.id
    principalId: uistgacc_mi.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'DeploymentScript'
  location: resourceLocation
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${uistgacc_mi.id}': {}
    }
  }
  dependsOn: [
    // we need to ensure we wait for the role assignment to be deployed before trying to access the storage account
    roleAssignment
  ]
  properties: {
    azPowerShellVersion: '3.0'
    scriptContent: loadTextContent('./scripts/enable-static-website.ps1')
    retentionInterval: 'PT4H'
    environmentVariables: [
      {
        name: 'ResourceGroupName'
        value: resourceGroup().name
      }
      {
        name: 'StorageAccountName'
        value: uistgacc.name
      }
    ]
  }
}

// storage account (new website)
resource ui2stgacc 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: ui2StgAccName
  location: resourceLocation
  tags: resourceTags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: false
  }

  // blob service
  resource ui2stgacc_blobsvc 'blobServices' = {
    name: 'default'
  }
}

resource ui2stgacc_mi 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' = {
  name: 'DeploymentScript2'
  location: resourceLocation
  tags: resourceTags
}

resource ui2stgacc_roledefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: subscription()
  // This is the Storage Account Contributor role, which is the minimum role permission we can give. 
  // See https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#:~:text=17d1049b-9a84-46fb-8f53-869881c3d3ab
  name: '17d1049b-9a84-46fb-8f53-869881c3d3ab'
}

// This requires the service principal to be in 'owner' role or a custom role with 'Microsoft.Authorization/roleAssignments/write' permissions.
// Details: https://learn.microsoft.com/en-us/answers/questions/287573/authorization-failed-when-when-writing-a-roleassig.html
resource roleAssignment2 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: ui2stgacc
  name: guid(resourceGroup().id, ui2stgacc_mi.id, ui2stgacc_roledefinition.id)
  properties: {
    roleDefinitionId: ui2stgacc_roledefinition.id
    principalId: ui2stgacc_mi.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource deploymentScript2 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'DeploymentScript2'
  location: resourceLocation
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${ui2stgacc_mi.id}': {}
    }
  }
  dependsOn: [
    // we need to ensure we wait for the role assignment to be deployed before trying to access the storage account
    roleAssignment
  ]
  properties: {
    azPowerShellVersion: '3.0'
    scriptContent: loadTextContent('./scripts/enable-static-website.ps1')
    retentionInterval: 'PT4H'
    environmentVariables: [
      {
        name: 'ResourceGroupName'
        value: resourceGroup().name
      }
      {
        name: 'StorageAccountName'
        value: ui2stgacc.name
      }
    ]
  }
}

// web enable images storage account to bypass shared blob issues JM+
resource productimagesstgacc_mi 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' = {
  name: 'DeploymentScript3'
  location: resourceLocation
  tags: resourceTags
}

resource productimagesstgacc_roledefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: subscription()
  // This is the Storage Account Contributor role, which is the minimum role permission we can give. 
  // See https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#:~:text=17d1049b-9a84-46fb-8f53-869881c3d3ab
  name: '17d1049b-9a84-46fb-8f53-869881c3d3ab'
}

// This requires the service principal to be in 'owner' role or a custom role with 'Microsoft.Authorization/roleAssignments/write' permissions.
// Details: https://learn.microsoft.com/en-us/answers/questions/287573/authorization-failed-when-when-writing-a-roleassig.html
resource roleAssignment3 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: productimagesstgacc
  name: guid(resourceGroup().id, productimagesstgacc_mi.id, productimagesstgacc_roledefinition.id)
  properties: {
    roleDefinitionId: productimagesstgacc_roledefinition.id
    principalId: productimagesstgacc_mi.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource deploymentScript3 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'DeploymentScript3'
  location: resourceLocation
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${productimagesstgacc_mi.id}': {}
    }
  }
  dependsOn: [
    // we need to ensure we wait for the role assignment to be deployed before trying to access the storage account
    roleAssignment
  ]
  properties: {
    azPowerShellVersion: '3.0'
    scriptContent: loadTextContent('./scripts/enable-static-website.ps1')
    retentionInterval: 'PT4H'
    environmentVariables: [
      {
        name: 'ResourceGroupName'
        value: resourceGroup().name
      }
      {
        name: 'StorageAccountName'
        value: productimagesstgacc.name
      }
    ]
  }
}

//
// image classifier
//

// storage account (main website)
resource imageclassifierstgacc 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: imageClassifierStgAccName
  location: resourceLocation
  tags: resourceTags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: false
  }

  // blob service
  resource imageclassifierstgacc_blobsvc 'blobServices' = {
    name: 'default'

    // container
    resource uistgacc_blobsvc_websiteuploadscontainer 'containers' = {
      name: imageClassifierWebsiteUploadsContainerName
      properties: {
        publicAccess: 'None'
      }
    }
  }
}

//
// cdn
//

resource cdnprofile 'Microsoft.Cdn/profiles@2022-11-01-preview' = {
  name: cdnProfileName
  location: 'global'
  tags: resourceTags
  sku: {
    name: 'Standard_Microsoft'
  }
}

// endpoint (product images)
resource cdnprofile_imagesendpoint 'Microsoft.Cdn/profiles/endpoints@2022-11-01-preview' = {
  name: cdnImagesEndpointName
  location: 'global'
  tags: resourceTags
  parent: cdnprofile
  properties: {
    isCompressionEnabled: true
    contentTypesToCompress: [
      'image/svg+xml'
    ]
    deliveryPolicy: {
      rules: [
        {
          name: 'Global'
          order: 0
          actions: [
            {
              name: 'CacheExpiration'
              parameters: {
                typeName: 'DeliveryRuleCacheExpirationActionParameters'
                cacheBehavior: 'SetIfMissing'
                cacheType: 'All'
                cacheDuration: '10:00:00'
              }
            }
          ]
        }
      ]
    }
    originHostHeader: replace(replace(productimagesstgacc.properties.primaryEndpoints.blob, 'https://', ''), '/', '')
    origins: [
      {
        name: replace(replace(replace(productimagesstgacc.properties.primaryEndpoints.blob, 'https://', ''), '/', ''), '.', '-')
        properties: {
          hostName: replace(replace(productimagesstgacc.properties.primaryEndpoints.blob, 'https://', ''), '/', '')
          originHostHeader: replace(replace(productimagesstgacc.properties.primaryEndpoints.blob, 'https://', ''), '/', '')
        }
      }
    ]
  }
}

// endpoint (ui / old website)
resource cdnprofile_uiendpoint 'Microsoft.Cdn/profiles/endpoints@2022-11-01-preview' = {
  name: cdnUiEndpointName
  location: 'global'
  tags: resourceTags
  parent: cdnprofile
  properties: {
    isCompressionEnabled: true
    contentTypesToCompress: [
      'application/eot'
      'application/font'
      'application/font-sfnt'
      'application/javascript'
      'application/json'
      'application/opentype'
      'application/otf'
      'application/pkcs7-mime'
      'application/truetype'
      'application/ttf'
      'application/vnd.ms-fontobject'
      'application/xhtml+xml'
      'application/xml'
      'application/xml+rss'
      'application/x-font-opentype'
      'application/x-font-truetype'
      'application/x-font-ttf'
      'application/x-httpd-cgi'
      'application/x-javascript'
      'application/x-mpegurl'
      'application/x-opentype'
      'application/x-otf'
      'application/x-perl'
      'application/x-ttf'
      'font/eot'
      'font/ttf'
      'font/otf'
      'font/opentype'
      'image/svg+xml'
      'text/css'
      'text/csv'
      'text/html'
      'text/javascript'
      'text/js'
      'text/plain'
      'text/richtext'
      'text/tab-separated-values'
      'text/xml'
      'text/x-script'
      'text/x-component'
      'text/x-java-source'
    ]
    deliveryPolicy: {
      rules: [
        {
          name: 'Global'
          order: 0
          actions: [
            {
              name: 'CacheExpiration'
              parameters: {
                typeName: 'DeliveryRuleCacheExpirationActionParameters'
                cacheBehavior: 'SetIfMissing'
                cacheType: 'All'
                cacheDuration: '10:00:00'
              }
            }
          ]
        }
      ]
    }
    originHostHeader: replace(replace(uistgacc.properties.primaryEndpoints.web, 'https://', ''), '/', '')
    origins: [
      {
        name: replace(replace(replace(uistgacc.properties.primaryEndpoints.web, 'https://', ''), '/', ''), '.', '-')
        properties: {
          hostName: replace(replace(uistgacc.properties.primaryEndpoints.web, 'https://', ''), '/', '')
          originHostHeader: replace(replace(uistgacc.properties.primaryEndpoints.web, 'https://', ''), '/', '')
        }
      }
    ]
  }
}

// endpoint (ui / new website)
resource cdnprofile_ui2endpoint 'Microsoft.Cdn/profiles/endpoints@2022-11-01-preview' = {
  name: cdnUi2EndpointName
  location: 'global'
  tags: resourceTags
  parent: cdnprofile
  properties: {
    isCompressionEnabled: true
    contentTypesToCompress: [
      'application/eot'
      'application/font'
      'application/font-sfnt'
      'application/javascript'
      'application/json'
      'application/opentype'
      'application/otf'
      'application/pkcs7-mime'
      'application/truetype'
      'application/ttf'
      'application/vnd.ms-fontobject'
      'application/xhtml+xml'
      'application/xml'
      'application/xml+rss'
      'application/x-font-opentype'
      'application/x-font-truetype'
      'application/x-font-ttf'
      'application/x-httpd-cgi'
      'application/x-javascript'
      'application/x-mpegurl'
      'application/x-opentype'
      'application/x-otf'
      'application/x-perl'
      'application/x-ttf'
      'font/eot'
      'font/ttf'
      'font/otf'
      'font/opentype'
      'image/svg+xml'
      'text/css'
      'text/csv'
      'text/html'
      'text/javascript'
      'text/js'
      'text/plain'
      'text/richtext'
      'text/tab-separated-values'
      'text/xml'
      'text/x-script'
      'text/x-component'
      'text/x-java-source'
    ]
    deliveryPolicy: {
      rules: [
        {
          name: 'Global'
          order: 0
          actions: [
            {
              name: 'CacheExpiration'
              parameters: {
                typeName: 'DeliveryRuleCacheExpirationActionParameters'
                cacheBehavior: 'SetIfMissing'
                cacheType: 'All'
                cacheDuration: '02:00:00'
              }
            }
          ]
        }
        {
          name: 'EnforceHttps'
          order: 1
          conditions: [
            {
              name: 'RequestScheme'
              parameters: {
                typeName: 'DeliveryRuleRequestSchemeConditionParameters'
                matchValues: [
                  'HTTP'
                ]
                operator: 'Equal'
                negateCondition: false
                transforms: []
              }
            }
          ]
          actions: [
            {
              name: 'UrlRedirect'
              parameters: {
                typeName: 'DeliveryRuleUrlRedirectActionParameters'
                redirectType: 'Found'
                destinationProtocol: 'Https'
              }
            }
          ]
        }
      ]
    }
    originHostHeader: replace(replace(ui2stgacc.properties.primaryEndpoints.web, 'https://', ''), '/', '')
    origins: [
      {
        name: replace(replace(replace(ui2stgacc.properties.primaryEndpoints.web, 'https://', ''), '/', ''), '.', '-')
        properties: {
          hostName: replace(replace(ui2stgacc.properties.primaryEndpoints.web, 'https://', ''), '/', '')
          originHostHeader: replace(replace(ui2stgacc.properties.primaryEndpoints.web, 'https://', ''), '/', '')
        }
      }
    ]
  }
}

//
// container registry
//

resource acr 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' = {
  name: acrName
  location: resourceLocation
  tags: resourceTags
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
    publicNetworkAccess: 'Enabled'
  }
}

//
// load testing service
//

resource loadtestsvc 'Microsoft.LoadTestService/loadTests@2022-12-01' = {
  name: loadTestSvcName
  location: resourceLocation
  tags: resourceTags
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userassignedmiforkvaccess.id}': {}
    }
  }
}

//
// application insights
//

// log analytics workspace
resource loganalyticsworkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsWorkspaceName
  location: resourceLocation
  tags: resourceTags
  properties: {
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    sku: {
      name: 'PerGB2018' // pay-as-you-go
    }
  }
}

// app insights instance
resource appinsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: resourceLocation
  tags: resourceTags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: loganalyticsworkspace.id
  }
}

//
// portal dashboard
//

resource dashboard 'Microsoft.Portal/dashboards@2020-09-01-preview' = {
  name: portalDashboardName
  location: resourceLocation
  tags: resourceTags
  properties: {
    lenses: [
      {
        order: 0
        parts: [
          {
            position: {
              x: 0
              y: 0
              rowSpan: 4
              colSpan: 2
            }
          }
        ]
      }
    ]
  }
}

//
// aks cluster
//

resource aks 'Microsoft.ContainerService/managedClusters@2022-10-02-preview' = if (!deployVmBasedApis) {
  name: aksClusterName
  location: resourceLocation
  tags: resourceTags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: aksClusterDnsPrefix
    nodeResourceGroup: aksClusterNodeResourceGroup
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: 0 // Specifying 0 will apply the default disk size for that agentVMSize.
        count: 1
        vmSize: 'standard_b2s'
        osType: 'Linux'
        mode: 'System'
      }
    ]
    linuxProfile: {
      adminUsername: aksLinuxAdminUsername
      ssh: {
        publicKeys: [
          {
            keyData: loadTextContent('rsa.pub') // @TODO: temporary hack, until we autogen the keys
          }
        ]
      }
    }
  }
}


resource aks_roledefinitionforchaosexp 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing =  {
  scope: aks
  // This is the Azure Kubernetes Service Cluster Admin Role
  // See https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#azure-kubernetes-service-cluster-admin-role
  name: '0ab0b1a8-8aac-4efd-b8c2-3ee1fb270be8'
}

resource aks_roleassignmentforchaosexp 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!deployVmBasedApis) {
  scope: aks
  name: ((!deployVmBasedApis) ? guid(aks.id, chaosaksexperiment.id, aks_roledefinitionforchaosexp.id) : 'noname')
  properties: {
    roleDefinitionId: aks_roledefinitionforchaosexp.id
    principalId: ((!deployVmBasedApis) ? chaosaksexperiment.identity.principalId : '1234' )
    principalType: 'ServicePrincipal'
  }
}

//
// virtual network
//

resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' = if (deployPrivateEndpoints) {
  name: vnetName
  location: resourceLocation
  tags: resourceTags
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressSpace
      ]
    }
    subnets: [
      {
        name: vnetAcaSubnetName
        properties: {
          addressPrefix: vnetAcaSubnetAddressPrefix
        }
      }
      {
        name: vnetVmSubnetName
        properties: {
          addressPrefix: vnetVmSubnetAddressPrefix
        }
      }
      {
        name: vnetLoadTestSubnetName
        properties: {
          addressPrefix: vnetLoadTestSubnetAddressPrefix
        }
      }
      {
        name: vnetDBSubnetName
        properties: {
          addressPrefix: vnetDBSubnetAddressPrefix
        }
      }
      {
        name: vnetWebSubnetName
        properties: {
          addressPrefix: vnetWebSubnetAddressPrefix
        }
      }
      {
        name: vnetBastionSubnetName
        properties: {
          addressPrefix: vnetBastionSubnetAddressPrefix
        }
      }
    ]
  }
}

// Subnet NSGs
// use the module ./modules/createNsg.bicep to create a NSG for each subnet in the vnet

module vnetAcaSubnetNsg './modules/createNsg.bicep' = if (deployPrivateEndpoints) {
  name: 'createAcaSubnetNsg'
    params: {
      location: resourceLocation
      nsgName: '${vnetAcaSubnetName}-nsg-${resourceLocation}'
      nsgRules: []
      resourceTags: resourceTags
    }
}

// allow ports 80 and 22 for the VMs JM+
module vnetVmSubnetNsg './modules/createNsg.bicep' = if (deployPrivateEndpoints) {
  name: 'createVmSubnetNsg'
    params: {
      location: resourceLocation
      nsgName: '${vnetVmSubnetName}-nsg-${resourceLocation}'
      nsgRules: [
        {
           name: 'HTTPInbound'
           protocol: 'TCP'
           sourcePortRange: '*'
           destinationPortRange: '80'
           destinationPortRanges: []
           sourceAddressPrefix: '*'
           destinationAddressPrefix: '*'
           access: 'Allow'
           priority: 100
           direction: 'Inbound'
        }
        {
           name: 'SSHInbound'
           protocol: 'TCP'
           sourcePortRange: '*'
           destinationPortRange: '22'
           destinationPortRanges: []
           sourceAddressPrefix: '*'
           destinationAddressPrefix: '*'
           access: 'Allow'
           priority: 110
           direction: 'Inbound'
        }
      ]
      resourceTags: resourceTags
    }
}

module vnetLoadTestSubnetNsg './modules/createNsg.bicep' = if (deployPrivateEndpoints) {
  name: 'createLoadTestSubnetNsg'
    params: {
      location: resourceLocation
      nsgName: '${vnetLoadTestSubnetName}-nsg-${resourceLocation}'
      nsgRules: []
      resourceTags: resourceTags
    }
}

module vnetDBSubnetNsg './modules/createNsg.bicep' = if (deployPrivateEndpoints) {
  name: 'createDBSubnetNsg'
    params: {
      location: resourceLocation
      nsgName: '${vnetDBSubnetName}-nsg-${resourceLocation}'
      nsgRules: [
        {
          name: 'AllowSQLServerInbound'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '1433'
          sourceAddressPrefix: 'AzureCloud'
          destinationAddressPrefix: 'virtualNetwork'
          access: 'Allow'
          priority: '100'
          direction: 'Inbound'
        }
      ]
      resourceTags: resourceTags
    }
}

module vnetWebSubnetNsg './modules/createNsg.bicep' = if (deployPrivateEndpoints) {
  name: 'createWebSubnetNsg'
    params: {
      location: resourceLocation
      nsgName: '${vnetWebSubnetName}-nsg-${resourceLocation}'
      nsgRules: []
      resourceTags: resourceTags
    }
}

// attach NSGs to subnets
module attachNsgAca './modules/updateSubnet.bicep' = if (deployPrivateEndpoints) {
  name: 'update-vnet-subnet-${vnetName}-${vnetAcaSubnetName}'
  params: {
    vnetName: vnetName
    subnetName: vnetAcaSubnetName
    // Update the nsg
    properties: union(vnet.properties.subnets[0].properties, {
      networkSecurityGroup: {
        id: vnetAcaSubnetNsg.outputs.id
      }
    })
  }
  
}

module attachNsgVM './modules/updateSubnet.bicep' = if (deployPrivateEndpoints) {
  name: 'update-vnet-subnet-${vnetName}-${vnetVmSubnetName}'
  params: {
    vnetName: vnetName
    subnetName: vnetVmSubnetName
    // Update the nsg
    properties: union(vnet.properties.subnets[1].properties, {
      networkSecurityGroup: {
        id: vnetVmSubnetNsg.outputs.id
      }
    })
  }
  dependsOn: [attachNsgAca]
}

module attachNsgLoadTest './modules/updateSubnet.bicep' = if (deployPrivateEndpoints) {
  name: 'update-vnet-subnet-${vnetName}-${vnetLoadTestSubnetName}'
  params: {
    vnetName: vnetName
    subnetName: vnetLoadTestSubnetName
    // Update the nsg
    properties: union(vnet.properties.subnets[2].properties, {
      networkSecurityGroup: {
        id: vnetLoadTestSubnetNsg.outputs.id
      }
    })
  }
  dependsOn: [attachNsgVM]
}

module attachNsgDB './modules/updateSubnet.bicep' = if (deployPrivateEndpoints) {
  name: 'update-vnet-subnet-${vnetName}-${vnetDBSubnetName}'
  params: {
    vnetName: vnetName
    subnetName: vnetDBSubnetName
    // Update the nsg
    properties: union(vnet.properties.subnets[3].properties, {
      networkSecurityGroup: {
        id: vnetDBSubnetNsg.outputs.id
      }
    })
  }
  dependsOn: [attachNsgLoadTest]
}

module attachNsgWeb './modules/updateSubnet.bicep' = if (deployPrivateEndpoints) {
  name: 'update-vnet-subnet-${vnetName}-${vnetWebSubnetName}'
  params: {
    vnetName: vnetName
    subnetName: vnetWebSubnetName
    // Update the nsg
    properties: union(vnet.properties.subnets[4].properties, {
      networkSecurityGroup: {
        id: vnetWebSubnetNsg.outputs.id
      }
    })
  }
  dependsOn: [attachNsgDB]
}


// Create Bastion
module bastionHost './modules/createBastion.bicep' = if (deployPrivateEndpoints) {
  name: 'createBastion'
  params: {
    bastionHostName: bastionHostName
    location: resourceLocation
    resourceTags: resourceTags
    subnetId: vnet.properties.subnets[5].id
  }
}


//
// jumpbox vm
// 

// network interface controller
resource jumpboxnic 'Microsoft.Network/networkInterfaces@2022-07-01' = if (deployPrivateEndpoints) {
  name: jumpboxNicName
  location: resourceLocation
  tags: resourceTags
  properties: {
    ipConfigurations: [
      {
        name: 'nic-ip-config'
        properties: {
          primary: true
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: deployPrivateEndpoints ? vnet.properties.subnets[1].id : ''
          }
        }
      }
    ]
    nicType: 'Standard'
  }
}

// virtual machine
resource jumpboxvm 'Microsoft.Compute/virtualMachines@2022-08-01' = if (deployPrivateEndpoints) {
  name: jumpboxVmName
  location: resourceLocation
  tags: resourceTags
  properties: {
    hardwareProfile: {
      vmSize: 'standard_b2s'
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
      imageReference: {
        offer: 'WindowsServer'
        publisher: 'MicrosoftWindowsServer'
        sku: '2019-datacenter-gensecond'
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: deployPrivateEndpoints ? jumpboxnic.id : ''
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
    osProfile: {
      adminPassword: jumpboxVmAdminPassword
      #disable-next-line adminusername-should-not-be-literal // @TODO: This is a temporary hack, until we can generate the password
      adminUsername: jumpboxVmAdminLogin
      computerName: jumpboxVmName
    }
  }
}

// auto-shutdown schedule
resource jumpboxvmschedule 'Microsoft.DevTestLab/schedules@2018-09-15' = if (deployPrivateEndpoints) {
  name: jumpboxVmShutdownScheduleName
  location: resourceLocation
  tags: resourceTags
  properties: {
    targetResourceId: deployPrivateEndpoints ? jumpboxvm.id : ''
    dailyRecurrence: {
      time: '2100'
    }
    notificationSettings: {
      status: 'Disabled'
    }
    status: 'Enabled'
    taskType: 'ComputeVmShutdownTask'
    timeZoneId: jumpboxVmShutdownScheduleTimezoneId
  }
}

//
// SQL Servers
//

// Products DB
module productsSqlServer './modules/createSqlVm.bicep' = if (deploySqlOnIaas) {
  name: 'createProductsSqlVM'
  params: {
    location: resourceLocation
    resourceTags: resourceTags
    virtualMachineName: '${sqlVmPrefix}-products'
    dnsLabel: productsDbServerName
    adminUsername: sqlVmAdminLogin
    adminPassword: sqlVmAdminPassword
    existingSubnetName: vnetDBSubnetName
    existingVirtualNetworkName: vnetName
    existingVnetResourceGroup: resourceGroup().name
  }
}

// auto-shutdown schedule
resource productsSqlvmschedule 'Microsoft.DevTestLab/schedules@2018-09-15' = if (deploySqlOnIaas) {
  name: '${sqlVmShutdownScheduleName}-products'
  location: resourceLocation
  tags: resourceTags
  properties: {
    targetResourceId: deploySqlOnIaas ? productsSqlServer.outputs.id : ''
    dailyRecurrence: {
      time: '2100'
    }
    notificationSettings: {
      status: 'Disabled'
    }
    status: 'Enabled'
    taskType: 'ComputeVmShutdownTask'
    timeZoneId: sqlVmShutdownScheduleTimezoneId
  }
}

// run script to create databases ./scripts/create-databases.ps1
resource runScriptToCreateProductDatabase 'Microsoft.Resources/deploymentScripts@2020-10-01' = if (deploySqlOnIaas) {
  name: 'RunScriptToCreateProductDatabase'
  location: resourceLocation
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${uistgacc_mi.id}': {}
    }
  }
  dependsOn: [
    // we need to ensure we wait for the role assignment to be deployed
    roleAssignment
  ]
  properties: {
    azPowerShellVersion: '3.0'
    scriptContent: loadTextContent('./scripts/create-databases.ps1')
    retentionInterval: 'PT4H'
    environmentVariables: [
      {
        name: 'serverName'
        value: productsSqlServer.outputs.publicIP
      }
      {
        name: 'userName'
        value: sqlVmAdminLogin
      }
      {
        name: 'password'
        value: sqlVmAdminPassword
      }
      {
        name: 'databaseNames'
        value: productsDbName
      }
      
    ]
  }
}

// Profiles DB
module profilesSqlServer './modules/createSqlVm.bicep' = if (deploySqlOnIaas) {
  name: 'createProfilesSqlVM'
  params: {
    location: resourceLocation
    resourceTags: resourceTags
    virtualMachineName: '${sqlVmPrefix}-profiles'
    dnsLabel: profilesDbServerName
    adminUsername: sqlVmAdminLogin
    adminPassword: sqlVmAdminPassword
    existingSubnetName: vnetDBSubnetName
    existingVirtualNetworkName: vnetName
    existingVnetResourceGroup: resourceGroup().name
  }
}

// auto-shutdown schedule
resource profilesSqlvmschedule 'Microsoft.DevTestLab/schedules@2018-09-15' = if (deploySqlOnIaas) {
  name: '${sqlVmShutdownScheduleName}-profiles'
  location: resourceLocation
  tags: resourceTags
  properties: {
    targetResourceId: deploySqlOnIaas ? profilesSqlServer.outputs.id : ''
    dailyRecurrence: {
      time: '2100'
    }
    notificationSettings: {
      status: 'Disabled'
    }
    status: 'Enabled'
    taskType: 'ComputeVmShutdownTask'
    timeZoneId: sqlVmShutdownScheduleTimezoneId
  }
}

// run script to create databases ./scripts/create-databases.ps1
resource runScriptToCreateProfileDatabase 'Microsoft.Resources/deploymentScripts@2020-10-01' = if (deploySqlOnIaas) {
  name: 'RunScriptToCreateProfileDatabase'
  location: resourceLocation
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${uistgacc_mi.id}': {}
    }
  }
  dependsOn: [
    // we need to ensure we wait for the role assignment to be deployed
    roleAssignment
  ]
  properties: {
    azPowerShellVersion: '3.0'
    scriptContent: loadTextContent('./scripts/create-databases.ps1')
    retentionInterval: 'PT4H'
    environmentVariables: [
      {
        name: 'serverName'
        value: profilesSqlServer.outputs.publicIP
      }
      {
        name: 'userName'
        value: sqlVmAdminLogin
      }
      {
        name: 'password'
        value: sqlVmAdminPassword
      }
      {
        name: 'databaseNames'
        value: profilesDbName
      }
      
    ]
  }
}

//
// private dns zone
//

module privateDnsZone './modules/createPrivateDnsZone.bicep' = if (deployPrivateEndpoints && !deployVmBasedApis) {
  name: 'createPrivateDnsZone'
  params: {
    privateDnsZoneName: (deployPrivateEndpoints && !deployVmBasedApis) ? join(skip(split(cartsinternalapiaca.properties.configuration.ingress.fqdn, '.'), 2), '.') : ''
    privateDnsZoneVnetId: deployPrivateEndpoints ? vnet.id : ''
    privateDnsZoneVnetLinkName: privateDnsZoneVnetLinkName
    privateDnsZoneARecordName: (deployPrivateEndpoints && !deployVmBasedApis) ? join(take(split(cartsinternalapiaca.properties.configuration.ingress.fqdn, '.'), 2), '.') : ''
    privateDnsZoneARecordIp: (deployPrivateEndpoints && !deployVmBasedApis) ? cartsinternalapiacaenv.properties.staticIp : ''
    resourceTags: resourceTags
  }
}
 
// aca environment (internal)
resource cartsinternalapiacaenv 'Microsoft.App/managedEnvironments@2022-06-01-preview' = if (deployPrivateEndpoints && !deployVmBasedApis) {
  name: cartsInternalApiAcaEnvName
  location: resourceLocation
  tags: resourceTags
  sku: {
    name: 'Consumption'
  }
  properties: {
    zoneRedundant: false
    vnetConfiguration: {
      infrastructureSubnetId: deployPrivateEndpoints ? vnet.properties.subnets[0].id : ''
      internal: true
    }
  }
}

// aca (internal)
resource cartsinternalapiaca 'Microsoft.App/containerApps@2022-06-01-preview' = if (deployPrivateEndpoints && !deployVmBasedApis) {
  name: cartsInternalApiAcaName
  location: resourceLocation
  tags: resourceTags
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userassignedmiforkvaccess.id}': {}
    }
  }
  properties: {
    configuration: {
      activeRevisionsMode: 'Single'
      ingress: {
        external: true
        allowInsecure: false
        targetPort: 80
        traffic: [
          {
            latestRevision: true
            weight: 100
          }
        ]
      }
      registries: [
        {
          passwordSecretRef: cartsInternalApiAcaSecretAcrPassword
          server: acr.properties.loginServer
          username: acr.name
        }
      ]
      secrets: [
        {
          name: cartsInternalApiAcaSecretAcrPassword
          value: acr.listCredentials().passwords[0].value
        }
      ]
    }
    environmentId: (deployPrivateEndpoints && !deployVmBasedApis) ? cartsinternalapiacaenv.id : ''
    template: {
      scale: {
        minReplicas: 1
        maxReplicas: 3
        rules: [
          {
            name: 'http-scaling-rule'
            http: {
              metadata: {
                concurrentRequests: '3'
              }
            }
          }
        ]
      }
      containers: [
        {
          env: [
            {
              name: cartsInternalApiSettingNameKeyVaultEndpoint
              value: kv.properties.vaultUri
            }
            {
              name: cartsInternalApiSettingNameManagedIdentityClientId
              value: userassignedmiforkvaccess.properties.clientId
            }
          ]
          // using a public image initially because no images have been pushed to our private ACR yet
          // at this point. At a later point, our github workflow will update the ACA app to use the 
          // images from our private ACR.
          image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
          name: cartsInternalApiAcaContainerDetailsName
          resources: {
            cpu: json('0.5')
            memory: '1.0Gi'
          }
        }
      ]
    }
  }
}


//
// docker VMs for APIs (JM+)
//
module dockerVms './create-docker-vms.bicep' = if (deployVmBasedApis) {
  name: 'createDockerVms'
    params: {
      location: resourceLocation
      adminUsername: 'localadmin'
      adminPassword: sqlPassword
      managedIdentityId: userassignedmiforkvaccess.id
      subnetId: vnet.properties.subnets[1].id
      cartCname: '${prefixHyphenated}-cartapi${suffix}'
      productCname: '${prefixHyphenated}-prodapi${suffix}'
      resourceTags: resourceTags
    }
}

//JM+ new front door standard for web, images and APIs
module newFrontDoor './modules/front-door-standard.bicep' = if (deployVmBasedApis) {
  name: 'createFrontDoorStandard'
    params: {
      frontdoorname: '${prefixHyphenated}-fd-${suffix}'
      productapicname: productApiCname
      cartapicname: cartApiCname
      imagescname: split(productimagesstgacc.properties.primaryEndpoints.web, '/')[2]
      webstorecname: split(ui2stgacc.properties.primaryEndpoints.web, '/')[2]
      resourceTags: resourceTags
    }
}

//
// chaos studio
//

// target: kv
resource chaoskvtarget 'Microsoft.Chaos/targets@2022-10-01-preview' = {
  name: 'Microsoft-KeyVault'
  location: resourceLocation
  scope: kv
  properties: {}

  // capability: kv (deny access)
  resource chaoskvcapability 'capabilities' = {
    name: 'DenyAccess-1.0'
  }
}

// chaos experiment: kv
resource chaoskvexperiment 'Microsoft.Chaos/experiments@2022-10-01-preview' = {
  name: chaosKvExperimentName
  location: resourceLocation
  tags: resourceTags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    selectors: [
      {
        type: 'List'
        id: chaosKvSelectorId
        targets: [
          {
            id: chaoskvtarget.id
            type: 'ChaosTarget'
          }
        ]
      }
    ]
    startOnCreation: false
    steps: [
      {
        name: 'step1'
        branches: [
          {
            name: 'branch1'
            actions: [
              {
                name: 'urn:csci:microsoft:keyVault:denyAccess/1.0'
                type: 'continuous'
                selectorId: chaosKvSelectorId
                duration: 'PT5M'
                parameters: []
              }
            ]
          }
        ]
      }
    ]
  }
}


// target: aks
resource chaosakstarget 'Microsoft.Chaos/targets@2022-10-01-preview' = if (!deployVmBasedApis) {
  name: 'Microsoft-AzureKubernetesServiceChaosMesh'
  location: resourceLocation
  scope: aks
  properties: {}

  // capability: aks (pod failures)
  resource chaosakscapability 'capabilities' = {
    name: 'PodChaos-2.1'
  }
}

// chaos experiment: aks (chaos mesh)
resource chaosaksexperiment 'Microsoft.Chaos/experiments@2022-10-01-preview' = if (!deployVmBasedApis) {
  name: chaosAksExperimentName
  location: resourceLocation
  tags: resourceTags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    selectors: [
      {
        type: 'List'
        id: chaosAksSelectorId
        targets: [
          {
            id: chaosakstarget.id
            type: 'ChaosTarget'
          }
        ]
      }
    ]
    startOnCreation: false
    steps: [
      {
        name: 'step1'
        branches: [
          {
            name: 'branch1'
            actions: [
              {
                name: 'urn:csci:microsoft:azureKubernetesServiceChaosMesh:podChaos/2.1'
                type: 'continuous'
                selectorId: chaosAksSelectorId
                duration: 'PT5M'
                parameters: [
                  {
                    key: 'jsonSpec'
                    value: '{\'action\':\'pod-failure\',\'mode\':\'all\',\'duration\':\'3s\',\'selector\':{\'namespaces\':[\'default\'],\'labelSelectors\':{\'app\':\'contoso-traders-products\'}}}'
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
  }
}

// outputs
////////////////////////////////////////////////////////////////////////////////

output cartsApiEndpoint string = deployVmBasedApis ? 'https://${newFrontDoor.outputs.VmProdApiEndpoint}' : 'https://${cartsapiaca.properties.configuration.ingress.fqdn}'
//JM- output cartsApiEndpoint string = 'https://${newFrontDoor.outputs.VmProdApiEndpoint}' 
output uiCdnEndpoint string = 'https://${cdnprofile_ui2endpoint.properties.hostName}'
// JM+
output productVmApiEndpoint string = productApiCname
output cartVmApiEndpoint string = cartApiCname

// from FD module
output newFdWebEndpoint string = newFrontDoor.outputs.webEndpoint 
output newFdimagesEndpoint string = newFrontDoor.outputs.imagesEndpoint 
output newFdProdVmApiEndpoint string = newFrontDoor.outputs.VmProdApiEndpoint 
output newFdCartVmApiEndpoint string = newFrontDoor.outputs.VmCartApiEndpoint 
