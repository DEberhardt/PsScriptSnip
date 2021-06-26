# Emergency Services Numbers
$matchingSting = '^(000|1(\d{2})|9(\d{2})|\d{1}11)$'


[string]$Number = '000'
$Number -match $matchingSting

[string]$Number = '112'
$Number -match $matchingSting

[string]$Number = '111'
$Number -match $matchingSting

[string]$Number = '711'
$Number -match $matchingSting

[string]$Number = '911'
$Number -match $matchingSting

[string]$Number = '999'
$Number -match $matchingSting