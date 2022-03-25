function One {
  [CmdletBinding()]
  param(
    [Parameter()]
    [string[]]$Name,

    [Parameter()]
    [string]$SearchString,

    [Parameter()]
    [switch]$Detailed
  ) #param

  Write-Host $args
  Write-Host "Name: $Name"
  Write-Host "SearchString: $SearchString"
  if ( $PSBoundParameters.ContainsKey('Detailed')) {
    # If key is there
    Write-Host "Detailed: $Detailed"
  }


  function two {
    [CmdletBinding()]
    param(
      [Parameter()]
      [string[]]$Name,

      [Parameter()]
      [string]$SearchString,

      [Parameter()]
      [bool]$Detailed
    ) #param

    Write-Host $args
    Write-Host "Name: $Name"
    Write-Host "SearchString: $SearchString"
    if ($Detailed) {
      # Key will be there when called, and this is a BOOL now not a SWITCH
      # we query the T/F Value of $Detailed instead
      Write-Host "Detailed: $Detailed"
    }

  }

  Two -Name $Name -SearchString $SearchString -Detailed $Detailed
}

One
One -Name 'Myname' -SearchString 'String' -Detailed
One -Name 'Myname' -SearchString 'String'