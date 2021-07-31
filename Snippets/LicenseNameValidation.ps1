# Parameter validation for Licenses and Service Plans:

param (
  #License
  [Parameter(HelpMessage = 'License(s)')]
  [ValidateScript( {
      if (-not $global:TeamsFunctionsMSAzureAdLicenses) { $global:TeamsFunctionsMSAzureAdLicenses = Get-AzureAdLicense -WarningAction SilentlyContinue }
      $LicenseParams = ($global:TeamsFunctionsMSAzureAdLicenses).ParameterName.Split('', [System.StringSplitOptions]::RemoveEmptyEntries)
      if ($_ -in $LicenseParams) { return $true } else {
        throw [System.Management.Automation.ValidationMetadataException] "Parameter 'License' - Invalid license string. Supported Parameternames can be found with Intellisense or Get-AzureAdLicense"
      }
    })]
  [ArgumentCompleter( {
      if (-not $global:TeamsFunctionsMSAzureAdLicenses) { $global:TeamsFunctionsMSAzureAdLicenses = Get-AzureAdLicense -WarningAction SilentlyContinue }
      $LicenseParams = ($global:TeamsFunctionsMSAzureAdLicenses).ParameterName.Split('', [System.StringSplitOptions]::RemoveEmptyEntries)
      $LicenseParams | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "$($LicenseParams.Count) records available")
      }
    })]
  [string[]]$License,


  # CallingPlan
  [Parameter(HelpMessage = 'Calling Plan License(s)')]
  [ValidateScript( {
      if (-not $global:TeamsFunctionsMSAzureAdLicenses) { $global:TeamsFunctionsMSAzureAdLicenses = Get-AzureAdLicense -WarningAction SilentlyContinue }
      $LicenseParams = ($global:TeamsFunctionsMSAzureAdLicenses | Where-Object LicenseType -EQ 'CallingPlan').ParameterName.Split('', [System.StringSplitOptions]::RemoveEmptyEntries)
      if ($_ -in $LicenseParams) { $True } else {
        throw [System.Management.Automation.ValidationMetadataException] "Parameter 'CallingPlanLicense' must be of the set: $LicenseParams"
      }
    })]
  [ArgumentCompleter( {
      if (-not $global:TeamsFunctionsMSAzureAdLicenses) { $global:TeamsFunctionsMSAzureAdLicenses = Get-AzureAdLicense -WarningAction SilentlyContinue }
      $LicenseParams = ($global:TeamsFunctionsMSAzureAdLicenses | Where-Object LicenseType -EQ 'CallingPlan').ParameterName.Split('', [System.StringSplitOptions]::RemoveEmptyEntries)
      $LicenseParams | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "$($LicenseParams.Count) records available")
      }
    })]
  [string[]]$CallingPlan,


  #ServicePlan
  [Parameter(HelpMessage = 'Service Plan(s)')]
  [ValidateScript( {
      if (-not $global:TeamsFunctionsMSAzureAdLicenseServicePlans) { $global:TeamsFunctionsMSAzureAdLicenseServicePlans = Get-AzureAdLicenseServicePlan -WarningAction SilentlyContinue }
      $ServicePlanNames = ($global:TeamsFunctionsMSAzureAdLicenseServicePlans).ServicePlanName.Split('', [System.StringSplitOptions]::RemoveEmptyEntries)
      if ($_ -in $ServicePlanNames) { return $true } else {
        throw [System.Management.Automation.ValidationMetadataException] "Parameter 'ServicePlan' - Invalid ServicePlan string. Supported Parameternames can be found with Intellisense or Get-AzureAdLicenseServicePlan (ServicePlanName)"
      }
    })]
  [ArgumentCompleter( {
      if (-not $global:TeamsFunctionsMSAzureAdLicenseServicePlans) { $global:TeamsFunctionsMSAzureAdLicenseServicePlans = Get-AzureAdLicenseServicePlan -WarningAction SilentlyContinue }
      $ServicePlanNames = ($global:TeamsFunctionsMSAzureAdLicenseServicePlans).ServicePlanName.Split('', [System.StringSplitOptions]::RemoveEmptyEntries)
      $ServicePlanNames | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "$($ServicePlanNames.Count) records available")
      }
    })]
  [string[]]$ServicePlan

)


$License
$CallingPlan
$ServicePlan