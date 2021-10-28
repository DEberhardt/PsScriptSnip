
$code = (Get-Content D:\Code\Personal\TeamsFunctions\Public\Functions\AutoAttendant\Get-TeamsAutoAttendant.ps1)

#This only gets ALL the uses of Write-BetterProgress and does not differentiate between ID0 and ID1!
#This also uses the old Parser, not the AST
$script:StepsID0 = ([System.Management.Automation.PsParser]::Tokenize($MyInvocation.MyCommand.Definition, [ref]$null) | Where-Object { $_.Type -eq 'Command' -and $_.Content -eq 'Write-BetterProgress' }).Count

<#Ast
$tokens = $errors = $null
$ScriptAst = [System.Management.Automation.Language.Parser]::ParseInput($code, [ref] $tokens, [ref]$errors)
#>

$ScriptAst = [System.Management.Automation.Language.Parser]::ParseInput($MyInvocation.MyCommand.Definition, [ref] $null, [ref]$null)

# This will also find itself
$script:StepsID0 = $ScriptAst.Extent.Text -Split 'Write-BetterProgress -Id 0 ' | Measure-Object | Select-Object -ExpandProperty Count
if ($PSBoundParameters.ContainsKey('Debug')) { "Function: $($MyInvocation.MyCommand.Name): StepsID0: $script:StepsID0" | Write-Debug }

$script:StepsID1 = $ScriptAst.Extent.Text -Split 'Write-BetterProgress -Id 1 ' | Measure-Object | Select-Object -ExpandProperty Count
if ($PSBoundParameters.ContainsKey('Debug')) { "Function: $($MyInvocation.MyCommand.Name): StepsID1: $script:StepsID1" | Write-Debug }


# This will also find itself, so we subtract one
$script:StepsID0 = ($ScriptAst.Extent.Text -Split 'Write-BetterProgress -Id 0 ' | Measure-Object | Select-Object -ExpandProperty Count) - 1
if ($PSBoundParameters.ContainsKey('Debug')) { "Function: $($MyInvocation.MyCommand.Name): StepsID0: $script:StepsID0" | Write-Debug }

$script:StepsID1 = ($ScriptAst.Extent.Text -Split 'Write-BetterProgress -Id 1 ' | Measure-Object | Select-Object -ExpandProperty Count) - 1
if ($PSBoundParameters.ContainsKey('Debug')) { "Function: $($MyInvocation.MyCommand.Name): StepsID1: $script:StepsID1" | Write-Debug }

#et voila!