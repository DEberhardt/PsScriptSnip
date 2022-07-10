#TODO:
# Constant variables cannot be altered. - Define as constants until overwritten?
#Set-Variable -Name 'Constant' -Value 25 -Option Constant

#ValidateScript and ArgumentCompleter in PARAM Block, ArgumentCompleter in PSM1
#NOTE ArgumentCompletions only works in PS7 (and PS5 only with tweak), they only work with Static lists.
#NOTE If ScriptBlocks are to be used, use: [ArgumentCompleter({ &$global:TfAcSbA... })]
param(
  #region General - UPN, PhoneNumber, etc.
  [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage = 'UPN of the Object to create.')]
  [Alias('Identity', 'ObjectId')]
  [ValidateScript( {
      If ($_ -match '@') { $True } else {
        throw [System.Management.Automation.ValidationMetadataException] 'Value must be a valid UPN'
      } })]
  [string[]]$UserPrincipalName,

  [Alias('Identity', 'ObjectId')]
  [ValidateScript( {
      If ($_ -match '@' -or $_ -match '^[0-9a-f]{8}-([0-9a-f]{4}\-){3}[0-9a-f]{12}$') { $True } else {
        throw [System.Management.Automation.ValidationMetadataException] 'Value must be a valid UPN or ObjectId'
      } })]
  [string[]]$UserPrincipalName2,

  [Parameter(ParameterSetName = 'Number', ValueFromPipelineByPropertyName, HelpMessage = 'Telephone Number of the Object')]
  [ValidateScript( {
      If ( $_ -match '^(tel:\+|\+)?([0-9]?[-\s]?(\(?[0-9]{3}\)?)[-\s]?([0-9]{3}[-\s]?[0-9]{4})|([0-9][-\s]?){4,20})((x|;ext=)([0-9]{3,8}))?$' ) { $True } else {
        throw [System.Management.Automation.ValidationMetadataException] 'Value must be a valid phone number. E.164 format expected, min 4 digits, but multiple formats accepted. Extensions will be stripped'
      } })]
  [Alias('Tel', 'Number', 'TelephoneNumber')]
  [string]$PhoneNumber,
  #endregion

  #region License & ServicePlan
  [Parameter(Mandatory, HelpMessage = 'License to be tested')]
  [ValidateScript( {
      if ($_ -in $(&$global:TfAcSbAzureAdLicense)) { return $true } else {
        throw [System.Management.Automation.ValidationMetadataException] 'Value must be a valid License. Use Intellisense for options or Get-AzureAdLicense (ParameterName)'
      } })]
  [ArgumentCompleter({ &$global:TfAcSbAzureAdLicense })]
  [string]$License,

  [Parameter(Mandatory, HelpMessage = 'Calling Plan to be tested')]
  [ValidateScript( {
      if ($_ -in $(&$global:TfAcSbCallingPlanLicense)) { return $true } else {
        throw [System.Management.Automation.ValidationMetadataException] 'Value must be a valid Calling Plan. Use Intellisense for options or Get-AzureAdLicense (ParameterName)'
      } })]
  [ArgumentCompleter({ &$global:TfAcSbCallingPlanLicense })]
  [string[]]$CallingPlanLicense,

  [Parameter(Mandatory, HelpMessage = 'AzureAd Service Plan')]
  [ValidateScript( {
      if ($_ -in $(&$global:TfAcSbAzureAdLicenseServicePlan)) { return $true } else {
        throw [System.Management.Automation.ValidationMetadataException] 'Value must be a valid ServicePlan. Use Intellisense for options or Get-AzureAdLicenseServicePlan (ServicePlanName)'
      } })]
  [ArgumentCompleter({ &$global:TfAcSbAzureAdLicenseServicePlan })]
  [string]$ServicePlan,
  #endregion

  #region Usage Location & CountryCode
  [Parameter(Mandatory, HelpMessage = 'Country as TwoLetterCountryCode')]
  [ValidateScript( {
      if ($_ -in $(&$global:TfAcSbTwoLetterCountryCode)) { $True } else {
        throw [System.Management.Automation.ValidationMetadataException] 'Value must be a valid ISO3166-alpha2 Two-Letter CountryCode. Use Intellisense for options'
      } })]
  [ArgumentCompleter({ &$global:TfAcSbTwoLetterCountryCode })]
  [string]$UsageLocation,

  [Parameter(Mandatory, HelpMessage = 'Country as TwoLetterCountryCode')]
  [ValidateScript( {
      if ($_ -in $(&$global:TfAcSbTwoLetterCountryCode)) { $True } else {
        throw [System.Management.Automation.ValidationMetadataException] 'Value must be a valid ISO3166-alpha2 Two-Letter CountryCode. Use Intellisense for options'
      } })]
  [ArgumentCompleter({ &$global:TfAcSbTwoLetterCountryCode })]
  [string]$CountryCode,
  #endregion

  #region Language & TimeZone
  [Parameter(HelpMessage = 'Language Identifier from Get-CsAutoAttendantSupportedLanguage.')]
  [ValidateScript( {
      if ($_ -in $(&$global:TfAcSbSupportedLanguageIds)) { $True } else {
        throw [System.Management.Automation.ValidationMetadataException] 'Value must be a supported Langauge Id. Use Intellisense for options'
      } })]
  [ArgumentCompleter({ &$global:TfAcSbSupportedLanguageIds })]
  [string]$LanguageId,

  [Parameter(HelpMessage = 'TimeZone Identifier from Get-CsAutoAttendantSupportedTimeZone')]
  [ValidateScript( {
      if ($_ -in $(&$global:TfAcSbSupportedTimeZone)) { $True } else {
        throw [System.Management.Automation.ValidationMetadataException] 'Value must be a supported TimeZone. Use Intellisense for options'
      } })]
  [ArgumentCompleter({ &$global:TfAcSbSupportedTimeZone })]
  [string]$TimeZone = 'UTC',
  #endregion

  #region Policies
  [Parameter(Mandatory, ParameterSetName = 'DirectRouting', ValueFromPipelineByPropertyName, HelpMessage = 'Name of the Online Voice Routing Policy')]
  [Alias('OVP')]
  [ValidateScript( {
      if ($_ -in $(&$global:TfAcSbVoiceRoutingPolicy)) { return $true } else {
        throw [System.Management.Automation.ValidationMetadataException] 'Value must be a valid Policy in the Tenant. Use Intellisense for options'
      } })]
  [ArgumentCompleter({ &$global:TfAcSbVoiceRoutingPolicy })]
  [string]$OnlineVoiceRoutingPolicy,

  [Parameter(ValueFromPipelineByPropertyName, HelpMessage = 'Name of the Tenant Dial Plan')]
  [Alias('TDP')]
  [ValidateScript( {
      if ($_ -in $(&$global:TfAcSbTenantDialPlan)) { return $true } else {
        throw [System.Management.Automation.ValidationMetadataException] 'Value must be a valid Dial Plan in the Tenant. Use Intellisense for options'
      } })]
  [ArgumentCompleter({ &$global:TfAcSbTenantDialPlan })]
  [string]$TenantDialPlan,

  [Parameter(HelpMessage = 'IP Phone Policy')]
  [ValidateScript( {
      if ($_ -in $(&$global:TfAcSbTeamsIPPhonePolicy)) { return $true } else {
        throw [System.Management.Automation.ValidationMetadataException] 'Value must be a valid Policy in the Tenant. Use Intellisense for options'
      } })]
  [ArgumentCompleter({ &$global:TfAcSbTeamsIPPhonePolicy })]
  [string]$IPPhonePolicy,

  [Parameter(HelpMessage = 'Teams Calling Line Identity')]
  [ValidateScript( {
      if ($_ -in $(&$global:TfAcSbTeamsCallingLineIdentity)) { return $true } else {
        throw [System.Management.Automation.ValidationMetadataException] 'Value must be a valid Policy in the Tenant. Use Intellisense for options'
      } })]
  [ArgumentCompleter({ &$global:TfAcSbTeamsCallingLineIdentity })]
  [string]$TeamsCallingLineIdentity,

  [Parameter(HelpMessage = 'Teams Calling Policy')]
  [ValidateScript( {
      if ($_ -in $(&$global:TfAcSbTeamsCallingPolicy)) { return $true } else {
        throw [System.Management.Automation.ValidationMetadataException] 'Value must be a valid Policy in the Tenant. Use Intellisense for options'
      } })]
  [ArgumentCompleter({ &$global:TfAcSbTeamsCallingPolicy })]
  [string]$TeamsCallingPolicy,

  [Parameter(HelpMessage = 'Teams Call Park Policy')]
  [ValidateScript( {
      if ($_ -in $(&$global:TfAcSbTeamsCallParkPolicy)) { return $true } else {
        throw [System.Management.Automation.ValidationMetadataException] 'Value must be a valid Policy in the Tenant. Use Intellisense for options'
      } })]
  [ArgumentCompleter({ &$global:TfAcSbTeamsCallParkPolicy })]
  [string]$TeamsCallParkPolicy,

  [Parameter(HelpMessage = 'Teams Emergency Calling Policy')]
  [ValidateScript( {
      if ($_ -in $(&$global:TfAcSbEmergencyCallingPolicy)) { return $true } else {
        throw [System.Management.Automation.ValidationMetadataException] 'Value must be a valid Policy in the Tenant. Use Intellisense for options'
      } })]
  [ArgumentCompleter({ &$global:TfAcSbEmergencyCallingPolicy })]
  [string]$TeamsEmergencyCallingPolicy,

  [Parameter(HelpMessage = 'Teams Emergency CallRouting Policy')]
  [ValidateScript( {
      if ($_ -in $(&$global:TfAcSbEmergencyCallRoutingPolicy)) { return $true } else {
        throw [System.Management.Automation.ValidationMetadataException] 'Value must be a valid Policy in the Tenant. Use Intellisense for options'
      } })]
  [ArgumentCompleter({ &$global:TfAcSbEmergencyCallRoutingPolicy })]
  [string]$TeamsEmergencyCallRoutingPolicy,
  #endregion

  #region Network Site and Subnet
  [Parameter(Mandatory, ParametersetName = 'Site', ValueFromPipelineByPropertyName, HelpMessage = 'Name of the Network Site for the User')]
  [ValidateScript( {
      if ($_ -in $(&$global:TfAcSbTeamsNetworkSiteId)) { $True } else {
        throw [System.Management.Automation.ValidationMetadataException] 'Value must be a valid NetworkSiteId. Use Intellisense for options'
      } })]
  [ArgumentCompleter({ &$global:TfAcSbTeamsNetworkSiteId })]
  [String[]]$NetworkSite,

  [Parameter(Mandatory, ParametersetName = 'Subnet', ValueFromPipelineByPropertyName, HelpMessage = 'Name of the Network Subnet for the User')]
  [ValidateScript( {
      if ($_ -in $(&$global:TfAcSbTeamsNetworkSubnetId)) { $True } else {
        throw [System.Management.Automation.ValidationMetadataException] 'Value must be a valid SubnetId. Use Intellisense for options'
      } })]
  [ArgumentCompleter({ &$global:TfAcSbTeamsNetworkSubnetId })]
  [String[]]$NetworkSubnet,
  #endregion


  $script:otherParams
)

$License # ParameterName
$CallingPlan # ParameterName
$ServicePlan # ServicePlanName

$TimeZone # Get-CsAutoAttendantSupportedTimeZone / Custom String
$LanguageId # Get-CsAutoAttendantSupportedLanguage / ID
$CountryCode # Get-ISO3166Country / TwoLetterCode (Alpha2)