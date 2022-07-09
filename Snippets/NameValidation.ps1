﻿#TODO:
# Constant variables cannot be altered. - Define as constants until overwritten?
#Set-Variable -Name 'Constant' -Value 25 -Option Constant


# Parameter validation for Licenses and Service Plans:
#region ValidateScript and ArgumentCompleter in PARAM Block
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
      $LicenseParams | Sort-Object | ForEach-Object {
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
      $LicenseParams | Sort-Object | ForEach-Object {
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
      $ServicePlanNames | Sort-Object | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "$($ServicePlanNames.Count) records available")
      }
    })]
  [string[]]$ServicePlan,

  #Time Zone
  [Parameter(HelpMessage = 'TimeZone Identifier from Get-CsAutoAttendantSupportedTimeZone')]
  [ValidateScript( {
      if (-not $global:TeamsFunctionsCsAutoAttendantSupportedTimeZone) { $global:TeamsFunctionsCsAutoAttendantSupportedTimeZone = Get-CsAutoAttendantSupportedTimeZone }
      [System.Collections.Arraylist]$TimeZoneUTCStrings = ($TeamsFunctionsCsAutoAttendantSupportedTimeZone | Where-Object DisplayName -NotLike '(UTC)*').DisplayName.Substring(1, 9) | Get-Unique
      [void]$TimeZoneUTCStrings.Add('UTC')
      if ($_ -in $TimeZoneUTCStrings) { $True } else {
        throw [System.Management.Automation.ValidationMetadataException] "Parameter 'TimeZone' must be of the set: $($TimeZoneUTCStrings -join ',')"
      }
    })]
  [ArgumentCompleter( {
      if (-not $global:TeamsFunctionsCsAutoAttendantSupportedTimeZone) { $global:TeamsFunctionsCsAutoAttendantSupportedTimeZone = Get-CsAutoAttendantSupportedTimeZone }
      [System.Collections.Arraylist]$TimeZoneUTCStrings = ($TeamsFunctionsCsAutoAttendantSupportedTimeZone | Where-Object DisplayName -NotLike '(UTC)*').DisplayName.Substring(1, 9) | Get-Unique
      [void]$TimeZoneUTCStrings.Add('UTC')
      $TimeZoneUTCStrings | Sort-Object | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "$($TimeZoneUTCStrings.Count) records available")
      }
    })]
  [string]$TimeZone = 'UTC',

  # Language
  [Parameter(HelpMessage = 'Language Identifier from Get-CsAutoAttendantSupportedLanguage.')]
  [ValidateScript( {
      if (-not $global:TeamsFunctionsCsAutoAttendantSupportedLanguageIds) { $global:TeamsFunctionsCsAutoAttendantSupportedLanguageIds = (Get-CsAutoAttendantSupportedLanguage).Id }
      if ($_ -in $TeamsFunctionsCsAutoAttendantSupportedLanguageIds) { $True } else {
        throw [System.Management.Automation.ValidationMetadataException] "Parameter 'LanguageId' must be of the set: $TeamsFunctionsCsAutoAttendantSupportedLanguageIds"
      }
    })]
  [ArgumentCompleter( {
      if (-not $global:TeamsFunctionsCsAutoAttendantSupportedLanguageIds) { $global:TeamsFunctionsCsAutoAttendantSupportedLanguageIds = (Get-CsAutoAttendantSupportedLanguage).Id }
      $TeamsFunctionsCsAutoAttendantSupportedLanguageIds | Sort-Object | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "$($TeamsFunctionsCsAutoAttendantSupportedLanguageIds.Count) records available")
      }
    })]
  [string]$LanguageId,

  [Parameter(HelpMessage = 'ISO3166-alpha2 CountryCode from Get-ISO3166Country.')]
  [ValidateScript( {
      if (-not $global:TeamsFunctionsCountryTable) { $global:TeamsFunctionsCountryTable = (Get-ISO3166Country).TwoLetterCode }
      if ($_ -in $TeamsFunctionsCountryTable) { $True } else {
        throw [System.Management.Automation.ValidationMetadataException] "Parameter 'CountryCode' must be of the set: $TeamsFunctionsCountryTable"
      }
    })]
  [ArgumentCompleter( {
      if (-not $global:TeamsFunctionsCountryTable) { $global:TeamsFunctionsCountryTable = (Get-ISO3166Country).TwoLetterCode }
      $TeamsFunctionsCountryTable | Sort-Object | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "$($TeamsFunctionsCountryTable.Count) records available")
      }
    })]
  [string]$CountryCode
)
#endregion

#region ValidateScript in PARAM Block, ArgumentCompleter in PSM1
param(
  #region License & ServicePlan
  [Parameter(Mandatory, HelpMessage = 'License to be tested')]
  [ValidateScript( {
      if ($_ -in $(&$global:TfAcSbAzureAdLicense)) { return $true } else {
        throw [System.Management.Automation.ValidationMetadataException] "Parameter 'License' - Invalid license string. Supported Parameternames can be found with Intellisense or Get-AzureAdLicense"
      }
    })]
  [string]$License,

  [Parameter(Mandatory, HelpMessage = 'AzureAd Service Plan')]
  [ValidateScript( {
      if ($_ -in $(&$global:TfAcSbAzureAdLicenseServicePlan)) { return $true } else {
        throw [System.Management.Automation.ValidationMetadataException] "Parameter 'ServicePlan' - Invalid ServicePlan string. Supported Parameternames can be found with Intellisense or Get-AzureAdLicenseServicePlan (ServicePlanName)"
      }
    })]
  [string]$ServicePlan,
  #endregion

  #region Usage Location & CountryCode
  [Parameter(Mandatory, HelpMessage = 'Country as TwoLetterCountryCode')]
  [ValidateScript( {
      if ($_ -in $(&$global:TfAcSbTwoLetterCountryCode)) { $True } else {
        throw [System.Management.Automation.ValidationMetadataException] "Parameter 'UsageLocation' must be of the set: $global:TeamsFunctionsCountryTable"
      }
    })]
  [string]$UsageLocation = 'US',

  [Parameter(Mandatory, HelpMessage = 'Country as TwoLetterCountryCode')]
  [ValidateScript( {
      if ($_ -in $(&$global:TfAcSbTwoLetterCountryCode)) { $True } else {
        throw [System.Management.Automation.ValidationMetadataException] "Parameter 'CountryCode' must be of the set: $global:TeamsFunctionsCountryTable"
      }
    })]
  [string]$CountryCode,
  #endregion

  #region Language & TimeZone
  [Parameter(HelpMessage = 'Language Identifier from Get-CsAutoAttendantSupportedLanguage.')]
  [ValidateScript( {
      if ($_ -in $(&$global:TfAcSbSupportedLanguageIds)) { $True } else {
        throw [System.Management.Automation.ValidationMetadataException] "Parameter 'LanguageId' must be of the set: $global:TeamsFunctionsCsAutoAttendantSupportedLanguageIds"
      }
    })]
  [string]$LanguageId,

  [Parameter(HelpMessage = 'TimeZone Identifier from Get-CsAutoAttendantSupportedTimeZone')]
  [ValidateScript( {
      if ($_ -in $(&$global:TfAcSbSupportedTimeZone)) { $True } else {
        throw [System.Management.Automation.ValidationMetadataException] "Parameter 'TimeZone' must be of the set: $($global:TeamsFunctionsSupportedTimeZone -join ',')"
      }
    })]
  [string]$TimeZone = 'UTC',
  #endregion

  $script:otherParams
)
#endregion


$License # ParameterName
$CallingPlan # ParameterName
$ServicePlan # ServicePlanName

$TimeZone # Get-CsAutoAttendantSupportedTimeZone / Custom String
$LanguageId # Get-CsAutoAttendantSupportedLanguage / ID
$CountryCode # Get-ISO3166Country / TwoLetterCode (Alpha2)