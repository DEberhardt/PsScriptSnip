# Module:   None
# Function: Eyeglass Prescription Positive/Negative Cylinder Conversion
# Author:   David Eberhardt
# Updated:  19-SEP-2021
# Status:   Live




function Convert-Rx {

  [OutputType([PSCustomObject])]
  param(
    [ValidateSet('L', 'R', 'Left', 'Right')]
    [string]$Eye,

    [Alias('Sphere')]
    [double]$SPH,

    [Alias('Cylinder')]
    [double]$CYL,

    [Alias('Degrees')]
    [int]$AXIS

  ) #param

  begin {
    Write-Verbose -Message "[BEGIN  ] $($MyInvocation.MyCommand)"

  } #begin

  process {
    Write-Verbose -Message "[PROCESS] $($MyInvocation.MyCommand)"

    if ($CYL -lt 0) {
      $source = 'NEGATIVE'
      $target = 'POSITIVE'

      [double]$targetSPH = $SPH + $CYL
      [double]$targetCYL = $CYL * -1
      $targetAXIS = $AXIS + 90
      if ( ($AXIS + 90) -gt 180 ) { $targetAXIS = $targetAXIS - 180 }
    }
    else {
      $source = 'POSITIVE'
      $target = 'NEGATIVE'

      [double]$targetSPH = $SPH + $CYL
      [double]$targetCYL = $CYL * -1
      $targetAXIS = $AXIS - 90
      if ( ($AXIS - 90) -lt 0 ) { $targetAXIS = $targetAXIS + 180 }
    }
    Write-Information [string]::Format('{0} CYL provided. Calculating to {1} Cylinders', $source, $target)

    $newNotation = [PSCustomObject][ordered] @{
      Eye       = $(try { $Eye.Substring(0, 1) } catch { 'X' })
      Spheres   = $('{0:N2}' -f $targetSPH) #[math]::Round( $targetSPH, 2 )
      Cylinders = $('{0:N2}' -f $targetCYL) #[math]::Round( $targetCYL, 2 )
      Axis      = [math]::Round( $targetAXIS, 2 )
      #Year      = $Year
    }

    Write-Output $newNotation
  } #process

  end {
    Write-Verbose -Message "[END    ] $($MyInvocation.MyCommand)"
  } #end
} # Convert-Rx
