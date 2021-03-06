
function Write-BetterProgress {
  <#
  .SYNOPSIS
    Wrapper for Write-Progress to improve consistency with output
  .DESCRIPTION
    This function improves upon Write-Progress to display more consistent and meaningful progress bars
  .PARAMETER Id
    Required. Synonymous with Write-Progress Parameter Id
    Id to bind it to. Could have been omitted, but for consistent input it should be clearly stated.
  .PARAMETER ParentId
    Optional. Synonymous with Write-Progress Parameter ParentId
    Parent Id to bind it to. If not provided will be assumed one less than the ID provided.
    For Example: Id 2 will result in the Parent ID being calculated as ParentId 1
  .PARAMETER Activity
    Required. Synonymous with Write-Progress Parameter Activity
    When called in Functions, $MyInvocation.MyCommand is a good activity.
    When called in ID higher than 0, the activity should display what is being worked on (Loop item, etc.)
  .PARAMETER Status
    Required. Synonymous with Write-Progress Parameter Status
    Message to display as a Status. This can be the current operation if this level of granularity is enough
  .PARAMETER Step
    Required. Current Step to display progress for
    Calculates Write-Progress Parameter PercentComplete with (StepNumber / StepTotal ) * 100
  .PARAMETER Of
    Required. Total Steps to calculate from
    Calculates Write-Progress Parameter PercentComplete with (StepNumber / StepTotal ) * 100
    If not provided or received as 0, will be assumed as 100 to avoid running into errors
  .PARAMETER CurrentOperation
    Optional. Synonymous with Write-Progress Parameter CurrentOperation
    Provides more granularity over the Status if required.
  .EXAMPLE
    Write-BetterProgress -Id 0 -Activity $MyInvocation.MyCommand -Status "Step $i" -Step $i -of 10
    Assumes running an a foreach loop of 'foreach ($i in (1..10)) {Write-BetterProgress -Id 0...}'
    Displays the Progress for ID 0 - with the activity set to the calling command (useful when used in a Function)
  .EXAMPLE
    Write-BetterProgress -Id 1 -Activity "Processing Item #$i" -Status "Step $i - Substep $j" -Step $j -of 10
    Assumes running an a foreach loop of 'foreach ($j in (1..10)) {Write-BetterProgress -Id 1...}'
    Displays the Progress for ID 1 - with the activity set to the calling command (useful when used in a Function)
    NOTE: The ParentId is set to 0 automatically (one less than the ID provided, unless Parameter ParentId is used)
  .EXAMPLE
    Write-BetterProgress -Id 2 -ParentId 1 -Activity 'Looping through Activities' -CurrentOperation 'Displaying Level 3' -Status "Step $i - Substep $j - iteration $k" -Step $k -of 10
    Assumes running an a foreach loop of 'foreach ($k in (1..10)) {Write-BetterProgress -Id 2...}'
    Displays the Progress for ID 2 - with the Parent ID set to 1 (this is calculated to 1 anyway, but can be overridden)
    CurrentOperation is optional and will display another line below if needed for more granularity.
  .INPUTS
    System.String
  .OUTPUTS
    System.Progress
  .NOTES
    Inspired by Adam Betrams wonderful take on 'A Better Way to Use Write-Progress'
    https://adamtheautomator.com/write-progress/

    This wrapper functions supports all parameters except Completed.
    Please use the following to cleanly complete your progress bar (swap ID and Activity as required):
    Write-Progress -Id 0 -Activity $MyInvocation.MyCommand -Completed

    NOTE: Run this BEFORE Write-Output or RETURN commands as some terminals suffer from a bleed-through effect that
    super-imposes the Progress over the output: https://github.com/microsoft/vscode/issues/118661
  .COMPONENT
    SupportingFunction
  .FUNCTIONALITY
    Uses Write-Progress without its inherent clunkyness, improving on consistency
  .LINK
    https://github.com/DEberhardt/TeamsFunctions/tree/master/docs/Write-BetterProgress.md
  .LINK
    https://github.com/DEberhardt/TeamsFunctions/tree/master/docs/about_Supporting_Functions.md
  .LINK
    https://github.com/DEberhardt/TeamsFunctions/tree/master/docs/
  #>

  [CmdletBinding()]
  [OutputType([String])]
  param (
    [Parameter (Mandatory)]
    [int]$ID,

    [Parameter ()]
    [int]$ParentId,

    [Parameter (Mandatory)]
    [string]$Activity,

    [Parameter (Mandatory)]
    [string]$Status,

    [Parameter ()]
    [string]$CurrentOperation,

    [Parameter (Mandatory)]
    [int]$Step,

    [Parameter ()]
    [int]$Of
  ) #param

  begin {
    #Show-FunctionStatus -Level Live
    #Write-Verbose -Message "[BEGIN  ] $($MyInvocation.MyCommand)"

  } #begin

  process {
    #Write-Verbose -Message "[PROCESS] $($MyInvocation.MyCommand)"

    if ($Of -eq 0 -or -not $PSBoundParameters.ContainsKey('of')) {
      $Of = 100
    }
    else {
      #Transitioning from Step 1 starting at 0 to starting at 1 (needs one extra step to avoid calculation errors)
      #This allows calling the function with '-Step ($Step++)'
      $Of++
    }

    $WriteProgressParams = @{
      Activity        = $Activity
      Status          = $Status
      PercentComplete = (($Step / $Of) * 100)
      ID              = $ID
    }

    if ($ID -gt 0) {
      $MyParentID = if ($PSBoundParameters.ContainsKey('ParentId')) { $ParentId } else { $($ID - 1) }
      $WriteProgressParams += @{ ParentId = $MyParentID }
    }

    if ($PSBoundParameters.ContainsKey('CurrentOperation')) {
      $WriteProgressParams += @{ CurrentOperation = $CurrentOperation }
    }

    try {
      Write-Progress @WriteProgressParams -ErrorAction Stop
    }
    catch {
      $Of++
      $WriteProgressParams.PercentComplete = (($Step / $Of) * 100)
      Write-Progress @WriteProgressParams
    }

    $VerboseMessage = "$Activity - $Status" + $(if ($PSBoundParameters.ContainsKey('CurrentOperation')) { " - $CurrentOperation" })
    Write-Verbose $VerboseMessage
  } #process

  end {
    #Write-Verbose -Message "[END    ] $($MyInvocation.MyCommand)"
  } #end

} #Write-BetterProgress



<# Works only for "Write-Progress -ID" - ID MUST be the first parameter provided, otherwise this will fail!
$script:StepsID0 = ([System.Management.Automation.PsParser]::Tokenize((Get-Content "$PSScriptRoot\$($MyInvocation.MyCommand.Name).ps1"), [ref]$null) | Where-Object { $_.Type -eq 'Command' -and $_.Content -eq 'Write-BetterProgress -ID 0' }).Count
$script:StepsID1 = ([System.Management.Automation.PsParser]::Tokenize((Get-Content "$PSScriptRoot\$($MyInvocation.MyCommand.Name).ps1"), [ref]$null) | Where-Object { $_.Type -eq 'Command' -and $_.Content -eq 'Write-BetterProgress -ID 1' }).Count
#>

<# Call with:
$Step = 0
$Status = "Current Status"
$CurrentOperation = "My current Operation"
Write-BetterProgress -ID 0 -Activity $MyInvocation.MyCommand -Step ($Step++) -Of $StepsID0 -Status $Status
Write-BetterProgress -ID 1 -Activity $MyInvocation.MyCommand -Step ($Step++) -Of $StepsID1 -Status $Status -CurrentOperation $CurrentOperation
#>


#TEST1 - Compare Write-BetterProgress

function Show-BetterProgress3Tier {
  foreach ( $i in 1..10 ) {
    Write-BetterProgress -Id 0 -Activity $MyInvocation.MyCommand -Status "Step $i" -Step $i -of 10
    foreach ( $j in 1..10 ) {
      Write-BetterProgress -Id 1 -Activity "Processing Item #$i" -Status "Step $i - Substep $j" -Step $j -of 10
      foreach ( $k in 1..10 ) {
        Write-BetterProgress -Id 2 -ParentId 1 -Activity 'Looping through Activities' -CurrentOperation 'Displaying Level 3' -Status "Step $i - Substep $j - iteration $k" -Step $k -of 10
        Start-Sleep -m 150
      }
      Write-Progress -Id 2 -Activity $MyInvocation.MyCommand -Completed
    }
    Write-Progress -Id 1 -Activity $MyInvocation.MyCommand -Completed
  }
  Write-Progress -Id 0 -Activity $MyInvocation.MyCommand -Completed

}
Show-BetterProgress3Tier

function Show-BetterProgress2Tier {
  foreach ( $i in 1..10 ) {
    Write-BetterProgress -Id 0 -Activity $MyInvocation.MyCommand -Status "Step $i" -Step $i -of 10
    foreach ( $j in 1..10 ) {
      Write-BetterProgress -Id 1 -Activity "Processing Item #$i" -Status "Step $i - Substep $j" -CurrentOperation "Substep $j of 10" -Step $j -of 10
      Start-Sleep -m 150
    }
    Write-Progress -Id 1 -Activity $MyInvocation.MyCommand -Completed
  }
  Write-Progress -Id 0 -Activity $MyInvocation.MyCommand -Completed

}
Show-BetterProgress2Tier

function Show-BetterProgress1Tier {
  foreach ( $i in 1..10 ) {
    Write-BetterProgress -Id 0 -Activity $MyInvocation.MyCommand -Status "Step $i" -Step $i -of 10 -CurrentOperation "Substep $i of 10"
    Start-Sleep -m 150
  }
  Write-Progress -Id 0 -Activity $MyInvocation.MyCommand -Completed

}
Show-BetterProgress1Tier

#TEST2 - Compare with Write-Progress
function Show-Progress {
  foreach ( $i in 1..10 ) {
    Write-Progress -Id 0 -Activity $MyInvocation.MyCommand -CurrentOperation 'Displaying Level 1' -Status "Step $i" -PercentComplete $(($I / 10) * 100)
    foreach ( $j in 1..10 ) {
      Write-Progress -Id 1 -ParentId 0 -Activity $MyInvocation.MyCommand -CurrentOperation 'Displaying Level 2' -Status "Step $i - Substep $j" -PercentComplete $(($j / 10) * 100)
      foreach ( $k in 1..10 ) {
        Write-Progress -Id 2 -ParentId 1 -Activity $MyInvocation.MyCommand -CurrentOperation 'Displaying Level 3' -Status "Step $i - Substep $j - iteration $k" -PercentComplete $(($k / 10) * 100); Start-Sleep -m 150
      }
    }
  }

}
Show-Progress