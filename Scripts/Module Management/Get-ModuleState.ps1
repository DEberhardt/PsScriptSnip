function Get-ModuleState {

  Write-Host 'this will report all modules with duplicate (older and newer) versions installed'
  Write-Host 'be sure to run this as an admin' -ForegroundColor yellow
  Write-Host '(You can update all your Azure RMmodules with update-module Azurerm -force)'

  $mods = Get-InstalledModule

  foreach ($Mod in $mods) {
    Write-Host "Checking $($mod.name)"
    $latest = Get-InstalledModule $mod.name
    $specificmods = Get-InstalledModule $mod.name -AllVersions
    Write-Host "$($specificmods.count) versions of this module found [ $($mod.name) ]"

    foreach ($sm in $specificmods) {
      if ($sm.version -eq $latest.version)
      { $color = 'green' }
      else
      { $color = 'magenta' }
      Write-Host " $($sm.name) - $($sm.version) [highest installed is $($latest.version)]" -ForegroundColor $color

    }
    Write-Host '------------------------'
  }
  Write-Host 'done'

}