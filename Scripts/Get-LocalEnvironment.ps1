# Querying PowerShell Modules, Version Table, Host, .NET Frameworks and certain Modules to feed back when raising issues on Github.

function Get-LocalEnvironment {
  Write-Host 'PowerShell Module Paths' -ForegroundColor Magenta
  $env:PSModulePath -split ';'

  Write-Host ''
  Write-Host 'PowerShell Version Table' -ForegroundColor Magenta
  $PSVersionTable

  Write-Host ''
  Write-Host 'PowerShell Host' -ForegroundColor Magenta
  $Host

  Write-Host 'Installed NET Frameworks' -ForegroundColor Magenta
  Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse | `
      Get-ItemProperty -Name Version, Release -EA 0 | `
      Where-Object { $_.PSChildName -match '^(?!S)\p{L}' } | `
      Select-Object PSChildName, Version, Release | Format-Table

      Write-Host ''
  $modules = @('MicrosoftTeams', 'TeamsFunctions', 'AzureAd', 'AzureAdPreview')
  Write-Host 'Relevant Modules (installed)' -ForegroundColor Magenta
  Get-Module $Modules -ListAvailable -ErrorAction SilentlyContinue | Select-Object ModuleType, Version, Name | Format-Table
  Write-Host ''
  Write-Host 'Relevant Modules (loaded)' -ForegroundColor Magenta
  Get-Module $Modules -ErrorAction SilentlyContinue | Select-Object ModuleType, Version, Name | Format-Table
}
Set-Alias -Name gle -Value Get-LocalEnvironment