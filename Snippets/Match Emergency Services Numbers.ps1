# Emergency Services Numbers
$matchingSting = '^(000|1(\d{2})|9(\d{2})|\d{1}11)$'

[string[]]$MatchingNumbers = @('000', '111', '112', '133', '711', '911', '999')
Write-Output "Testing Matching Numbers: $MatchingNumbers"
foreach ($Number in $MatchingNumbers) {
  [int]$pad = 80 - ($Number.length + 4)
  $Matching = $Number -match $matchingSting
  $OutputString = if ( $Matching ) { 'matches' } else { "doesn't match" }
  $OutputColour = if ( $Matching ) { 'Green' } else { 'Red' }
  Write-Host "'$number': $($OutputString.PadLeft($pad))" -ForegroundColor $OutputColour
}

[string[]]$NonMatchingNumbers = @('00', '11', '17', '333')
Write-Output "Testing NonMatching Numbers: $NonmatchingNumbers"

foreach ($Number in $NonMatchingNumbers) {
  [int]$pad = 80 - ($Number.length + 4)
  $Matching = $Number -match $matchingSting
  $OutputString = if ( $Matching ) { 'matches' } else { "doesn't match" }
  $OutputColour = if ( $Matching ) { 'Green' } else { 'Red' }
  Write-Host "'$number': $($OutputString.PadLeft($pad))" -ForegroundColor $OutputColour
}