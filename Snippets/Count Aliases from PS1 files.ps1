# Query files from the module
$Public = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Recurse -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -Recurse -ErrorAction SilentlyContinue )

# To test - Manual content definition for testing
$Content = @'
# Module:   TeamsFunctions
# Function: Session
# Author:   David Eberhardt
# Updated:  01-JAN-2021
# Status:   Live




function Connect-Me {

  [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Colourful feedback required to emphasise feedback for script executors')]
  [CmdletBinding()]
  [Alias('con','me')]
  param(
    [Parameter(Mandatory, Position = 0, HelpMessage = 'UserPrincipalName, Administrative Account')]
    [Alias('UserPrincipalName', 'Username')]

    [Parameter(HelpMessage = 'Establishes a connection to Exchange Online. Reuses credentials if authenticated already.')]
    [Alias('Exchange')]
  ) #param
'@



$Aliases = $null
#$Aliases = Foreach ($Function in @($Public + $Private)) {
$Aliases = Foreach ($Function in @($Public)) {
  if ( $($Function.Fullname) -match '.tests.ps1' ) { continue }
  $Content = $AliasBlocks = $null

  $Content = $Function | Get-Content

  $AliasBlocks = $Content -split "`n" | Select-String 'Alias\(' -Context 1, 1
  $AliasBlocks | ForEach-Object {
    $Lines = $($_ -split "`n")
    if ( $Lines[0] -match 'CmdletBinding' -or $Lines[0] -match 'OutputType' -or $Lines[2] -match 'CmdletBinding' -or $Lines[2] -match 'OutputType' ) {
      if ( $($_ -split "`n")[1] -match "Alias\('(?<content>.*)'\)" ) {
        $($matches.content -split ',' -replace "'" -replace ' ') | ForEach-Object { if ( $_ -ne '' ) { $_ } }
      }
    }
    else {
      continue
    }
  }
}

$Aliases
$Aliases.Count
