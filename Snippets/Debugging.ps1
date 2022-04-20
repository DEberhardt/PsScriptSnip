# Debugging tools

# Functions for the PowerShell Profile
function debugOn {
  $GLOBAL:VerbosePreference = 'Continue'; $GLOBAL:DebugPreference = 'Continue'
  Write-Verbose 'Verbose and Debug: ON'
}
function debugOff {
  $GLOBAL:VerbosePreference = 'SilentlyContinue'; $GLOBAL:DebugPreference = 'SilentlyContinue'
  Write-Verbose 'Verbose and Debug: OFF' -Verbose
}

# Snippets for Scripts - Change $Parameters to what suits your needs
if ($PSBoundParameters.ContainsKey('Debug') -or $DebugPreference -eq 'Continue') {
  "  Function: $($MyInvocation.MyCommand.Name) - Parameters:", ($Parameters | Format-Table -AutoSize | Out-String).Trim() | Write-Debug
}
