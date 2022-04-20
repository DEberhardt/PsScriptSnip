function UnInstall-Modules {

  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $false)]
    [string]
    $RetentionMonths = 3
  )

  if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {
    $DebugPreference = 'Continue'
  }
  $CMDLetName = $MyInvocation.MyCommand.Name

  # Get a list of the current modules installed.
  Write-Debug 'Getting list of current modules installed …'
  $Modules = Get-InstalledModule
  $Counter = 0 # Used to track count of un-installations

  foreach ($Module in $Modules) {
    Write-Debug $($Module.Name) # List out all the modules installed.
  }

  foreach ($Module in $Modules) {

    Write-Host “`n”
    $ModuleVersions = Get-InstalledModule -Name $($Module.Name) -AllVersions # Get all versions of the module
    $ModuleVersionsArray = New-Object System.Collections.ArrayList
    foreach ($ModuleVersion in $ModuleVersions) {
      $ModuleVersionsArray.Add($ModuleVersion.Version) > $Null
    }
    Write-Debug “Reviewing module: $($Module.name) – Versions installed: $($ModuleVersionsArray.Count)”

    $VersionsToKeepArray = New-Object System.Collections.ArrayList
    $MajorVersions = @($ModuleVersionsArray.Major | Get-Unique) # Get unique majors
    $MinorVersions = @($ModuleVersionsArray.Minor | Get-Unique) # Get unique minors

    foreach ($MajorVersion in $MajorVersions) {
      foreach ($MinorVersion in $MinorVersions) {
        $ReturnedVersion = (Get-InstalledModule -Name $($Module.Name) -MaximumVersion “${MajorVersion}.${MinorVersion}.99999” -ErrorAction SilentlyContinue)
        $VersionsToKeepArray.add($ReturnedVersion) > $Null # Versions to keep
        $ModuleVersionsArray.Remove($ReturnedVersion.Version) # Remove versions we’re keeping.
      }
    }

    # Groom the builds
    if ($ModuleVersionsArray) {
      foreach ($Version in $ModuleVersionsArray) {
        Write-Debug “Removing Module: $($Module.Name) – Version: ${Version} ”
        try {
          Uninstall-Module -Name $($Module.Name) -RequiredVersion “${Version}” -ErrorAction Stop
          $Counter++
        }
        catch {
          Write-Warning 'Problem'
        }
      }
    }
    else {
      Write-Debug 'No builds to remove'
    }

    # Evaluate removing previous builds older than retention period.
    $VersionsToRemoveArray = New-Object System.Collections.ArrayList # Create an array a versions to remove
    $Oldest = ($VersionsToKeepArray.version | Measure-Object -Minimum).Minimum # Get oldest version
    $Newest = ($VersionsToKeepArray.version | Measure-Object -Maximum).Maximum # Get newest version
    $ReturnedVersion = (Get-InstalledModule -Name $($Module.Name) -RequiredVersion $Oldest) # Find the oldest of the keepers
    if ($Oldest -ne $Newest) {
      # Skip adding it the current is both newest and oldest.
      $VersionsToRemoveArray.add($ReturnedVersion) > $Null # Versions to remove
    }

    if ($VersionsToRemoveArray) {
      foreach ($Module in $VersionsToRemoveArray) {
        if ($Module.version -eq $Oldest -and $Module.InstalledDate -lt (Get-Date).AddMonths( – ${RetentionMonths})) {
          try {
            Uninstall-Module -Name $($Module.Name) -RequiredVersion “${Version}” -ErrorAction Stop
            $Counter++
          }
          catch {
            Write-Warning 'Problem'
          }
        }
        else {
          Write-Debug “Module: $($Module.Name) – Version: $($Module.version) is not yet older than retention of ${RetentionMonths} months, skipping removal. ”
        }
      }
    }

  } # For each module end

  if ($Counter -gt 0) {
    Write-Debug “Removed ${Counter} module versions”
  }
} # Function end