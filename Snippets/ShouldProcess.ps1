# ask PowerShell whether code should execute:
$shouldProcess = $PSCmdlet.ShouldProcess($env:COMPUTERNAME, 'something insane')

# this will ALWAYS execute
"ConfirmPreference: $ConfirmPreference"
"WhatIfPreference:  $WhatIfPreference"

# turn off automatic confirmation dialogs for all commands
$ConfirmPreference = 'None'

# use a condition wherever appropriate to determine whether
# code should execute:
if ($shouldProcess) {
  Write-Host 'Executing!' -ForegroundColor Green
}
else {
  Write-Host 'Skipping!' -ForegroundColor Red
}
