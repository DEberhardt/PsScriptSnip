# installing
winget install JanDeDobbeleer.OhMyPosh -s winget

# checking source
(Get-Command oh-my-posh).Source

# updating
winget upgrade JanDeDobbeleer.OhMyPosh -s winget


# load (in profile)
$UserPsScripts = $PSGetPath.CurrentUserScripts
oh-my-posh init pwsh --config $UserPsScripts\ParagnosterPlus.omp.json | Invoke-Expression