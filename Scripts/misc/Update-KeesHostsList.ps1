# function Update-KeesHostsList {
# Updating a list of servers used for Ad and Tracking purposes from Github User Kees 1958
# Transforming them into a list of hosts that are diverted to 0.0.0.0 (nirvana) for use in HOSTS file
param(
  [Parameter()]
  [string]$Directory = 'C:\Temp',

  [Parameter()]
  [string]$FileName = 'KeesHostsList.txt'
)

if ( -not (Test-Path "$Directory")) { New-Item -ItemType Directory -Path $Directory }
Set-Location $Directory
if ((Get-ChildItem -Path $Directory).Name -contains $Filename) { Remove-Item -Path $Directory -Include $Filename }

# Importing published tracking networks and domains
$url = 'https://raw.githubusercontent.com/Kees1958/W3C_annual_most_used_survey_blocklist/master/EU_US+most_used_ad_and_tracking_networks'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$content = (Invoke-WebRequest $url -UseBasicParsing).Content

# Creating array
$content = $content -split '\r?\n'
Write-Debug -Message "$($content.Count) Total entries, filtering..."

#Filter all that don't start with ||, skip subdomains ".*" and ignore end "^$third-party" and "$third-party")
$content2 = $content | ForEach-Object { if ($_ -match '^(\|\|)(?<Domain>.*\.[a-zA-Z]{2,})(\^)?(\$third-party)$') { $Matches.Domain } }
Write-Debug -Message "$($content2.Count) Filtered entries, preparing output"

# Output to C:\Temp
$content3 = $content2 | ForEach-Object { '0.0.0.0 ' + $_ }
Write-Debug -Message "$($content3.Count) Hosts generated"

#TEST Set-Content -Append would enable also adding a header in front pointing to the URL and last update/execution
$content3 | Out-File -FilePath $Directory\$Filename
Write-Host "$($Content3.Count) Hosts written to file: $Directory\$Filename"
Write-Verbose 'To import, Please copy/paste manually to your HOSTS file' -Verbose
#}