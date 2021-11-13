# Measure-Object to return an average per iteration

# Long version (for multiple consecute Tests

$max = 10 # Number of tests
$Test = 'Description'
$target = 4000 # Target duration in MS (used for colour)
$Result = $([math]::Round((
      1..$max | Measure-Command -Expression {
        #Test

      }
    ).TotalMilliSeconds / $max))
$Color = $(if ($Result -gt $Target) { if ($Result -gt (2 * $Target)) { 'Red' } else { 'Yellow' } } else { 'Green' })
Write-Host "$Result ms - $Test" -ForegroundColor $Color



# Short version (ideal for quick tests)
$max = 1000 # Number of tests

$Test = 'Description'
Write-Host "$([math]::Round((
  1..$max | Measure-Command -Expression {
    #Test
    
  }
).TotalMilliSeconds/$max)) ms - $Test" -ForegroundColor Green
