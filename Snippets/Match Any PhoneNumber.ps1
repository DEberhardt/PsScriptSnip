# Number matching
function MatchNumber {
  param (
    $matchString,
    $MatchingNumbers,
    [bool]$NotMatch
  )

  foreach ($Number in $MatchingNumbers) {
    [int]$pad = $Number.length + 4
    $Matching = $Number -match $matchString
    $OutputString = if ( $Matching ) { 'matches' } else { 'NO match' }
    $OutputColour = if ( $Matching ) { if ($NotMatch) { 'DarkYellow' } else { 'DarkGreen' } } else { if ($NotMatch) { 'Green' } else { 'Red' } }

    $FindUVC = Format-StringForUse "$($Number.split(';')[0].split('x')[0])" -SpecialChars 'telx:+() -'
    $LineUri = Format-StringForUse $Number -As LineURI
    $PhoneNumber = Format-StringForUse $Number -As E164
    Write-Host "'$number': $($OutputString.PadLeft(60 - $pad));  " -ForegroundColor $OutputColour -NoNewline
    if ($Normalise) { Write-Host "as UVC: $($FindUVC.PadLeft(20));  as LineUri: $($LineUri.PadLeft(32));  as E164: $($PhoneNumber.PadLeft(16));" } else { Write-Host '' }
  }
}

# Display Normalisation to E164 and LineUri
$Normalise = $false
$Normalise = $true

#region Emergency Number formats
$Pattern = '^(000|1(\d{2})|9(\d{2})|\d{1}11)$'
$Test = "Testing Emergency Numbers"

Write-Output "$Test - SHOULD MATCH String: '$Pattern'"
[string[]]$NumberInput = @('000', '111', '112', '133', '711', '911', '999')
MatchNumber -matchString $Pattern -MatchingNumbers $NumberInput -NotMatch $false

Write-Output "$Test - SHOULDN'T MATCH String: '$Pattern'"
[string[]]$NumberInput = @('00', '11', '1121', '2000', '9911')
MatchNumber -matchString $Pattern -MatchingNumbers $NumberInput -NotMatch $true
#endregion

#region Matching US Number formats incl. spaces and dashes
$Pattern = '^(tel:\+[1]|\+?[1])?[-\s]?(\(?[0-9]{3}\)?)[-\s]?([0-9]{3}[-\s]?[0-9]{4})$'
$Test = "Testing US Number Format"

Write-Output "$Test - SHOULD MATCH String: '$Pattern'"
[string[]]$NumberInput = @(
  # spaces at various places
  '5551234567', '555 1234567', '555123 4567', '555 123 4567', '15551234567', '1555 1234567', '1555123 4567', '1555 123 4567',
  '1 555 123 4567', '1 5551234567', '1 (555)1234567', '1 (555) 1234567', '1 (555) 123 4567',
  # dashes everywhere
  '1-5551234567', '1-5551234567', '1-555-1234567', '1-555-123-4567', '1-5551234567', '1-(555)1234567', '1-(555)-1234567', '1-(555)-123-4567', '1(555) 123-4567',
  '1 (555)-123 4567', '1 5551234567', '1 (555)1234567', '1(555)1234567', '1(555) 123-4567', '1 (555)-123 4567',
  # mix and match
  '(555)1234567', '(555) 123-4567', '(555)-123 4567', '(555)-123-4567', '(555) 123 4567',
  '+15551234567', '+1 555 123 4567', '+1 (555) 123 4567', '+1 (555)-123-4567',
  'tel:+15551234567', 'tel:+1 555 123 4567', 'tel:+1 (555) 123 4567', 'tel:+1 (555)-123-4567'
)
MatchNumber -matchString $Pattern -MatchingNumbers $NumberInput -NotMatch $false

Write-Output "$Test - SHOULDN'T MATCH String: '$Pattern'"
[string[]]$NumberInput = @(
  '555 123456', '555123 456', '555 123 456', '1555 123456', '1555123 456', '1555 123 456',
  '555-123456', '555123-456', '555-123-456', '1555-123456', '1555123-456', '1555 123-456',
  '11 555 123 4567', '11 5551234567', '11 (555)1234567', '11 (555) 1234567', '11 (555) 123 4567',
  '555123456', '55512345671', '155512345671', '155512345671' #out of bounds
  )
MatchNumber -matchString $Pattern -MatchingNumbers $NumberInput -NotMatch $true
#endregion

#region Matching LineURI Formats
$Test = "Testing LineURI Format"
$Pattern = '^(tel:\+|\+)?([0-9]{8,15})((;ext=)([0-9]{3,8}))?$'

Write-Output "$Test - SHOULD MATCH String: '$Pattern'"
[string[]]$NumberInput = @(
  '12345678', '+12345678', 'tel:+12345678', # Standard Number formats (incl. E.164) lower bounds
  '123456789012345', '+123456789012345', 'tel:+123456789012345', # Standard Number formats (incl. E.164) upper bounds
  'tel:+12345678', 'tel:+123456789012345', # LineURI upper and lower bounds
  'tel:+12345678;ext=123', 'tel:+123456789012345;ext=123' # LineURI upper and lower bounds incl. Extension lower bounds
  'tel:+12345678;ext=12345678', 'tel:+123456789012345;ext=12345678' # LineURI upper and lower bounds incl. Extension upper bounds
)
MatchNumber -matchString $Pattern -MatchingNumbers $NumberInput -NotMatch $false

Write-Output "$Test - SHOULDN'T MATCH String: '$Pattern'"
[string[]]$NumberInput = @(
  '000', '111', '112', '133', '711', '911', '999', # Emergency Services Numbers
  '+1234567', '+1234567890123456', # out of bounds TEL
  'tel:+1234567', 'tel:+1234567890123456', # out of bounds TEL

  '+1234567;ext=1234', '+1234567890123456;ext=1234', # out of bounds TEL incl. EXT
  '+12345678;ext=12', '+123456789012345;ext=12', # TEL with out of bounds EXT (lower)
  '+12345678;ext=123456789', '+123456789012345;ext=123456789', # TEL with out of bounds EXT (upper)

  'tel:1234567890', 'tel:+1 234567890', 'tel:+1-234567890;ext=12345' # malformed
)
MatchNumber -matchString $Pattern -MatchingNumbers $NumberInput -NotMatch $true
#endregion

#region Matching Any Phone Number Formats
$Test = 'Testing FindString Format (any number or fragment)'
$Pattern = '^(tel:\+|\+)?([0-9]?[-\s]?(\(?[0-9]{3}\)?)[-\s]?([0-9]{3}[-\s]?[0-9]{4})|([0-9][-\s]?){3,20})((x|;ext=)([0-9]{3,8}))?$'

Write-Output "$Test - SHOULD MATCH String: '$Pattern'"
[string[]]$NumberInput = @(
  #region Emergency Numbers
  '000', '111', '112', '133', '711', '911', '999',

  #Emergency Phone Numbers (variations)
  '1 2 3', '9-1-1' # Emergency Services Numbers with spaces and dashes
  #endregion

  #region US Number formats
  # spaces at various places
  '1234567890', '123 4567890', '123456 7890', '123 456 7890', '11234567890', '1123 4567890', '1123456 7890', '1123 456 7890',
  '1 123 456 7890', '1 1234567890', '1 (123)4567890', '1 (123) 4567890', '1 (123) 456 7890',
  # dashes everywhere
  '1-1234567890', '1-1234567890', '1-123-4567890', '1-123-456-7890', '1-1234567890', '1-(123)4567890', '1-(123)-4567890', '1-(123)-456-7890', '1(123) 456-7890',
  '1 (123)-456 7890', '1 1234567890', '1 (123)4567890', '1(123)4567890', '1(123) 456-7890', '1 (123)-456 7890',
  # mix and match
  '(123)4567890', '(123) 456-7890', '(123)-456 7890', '(123)-456-7890', '(123) 456 7890',
  '+11234567890', '+1 123 456 7890', '+1 (123) 456 7890', '+1 (123)-456-7890',
  'tel:+11234567890', 'tel:+1 123 456 7890', 'tel:+1 (123) 456 7890', 'tel:+1 (123)-456-7890'
  #endregion

  #region Line URI formats
  '12345678', '+12345678', 'tel:+12345678', # Standard Number formats (incl. E.164) lower bounds
  '123456789012345', '+123456789012345', 'tel:+123456789012345', # Standard Number formats (incl. E.164) upper bounds
  'tel:+12345678', 'tel:+123456789012345', # LineURI upper and lower bounds
  'tel:+12345678;ext=123', 'tel:+123456789012345;ext=123' # LineURI upper and lower bounds incl. Extension lower bounds
  'tel:+12345678;ext=12345678', 'tel:+123456789012345;ext=12345678' # LineURI upper and lower bounds incl. Extension upper bounds
  #endregion

  #region Alternative Formats
  '+1 123', '+123', '+123;ext=4567', '+123 456 7890 ;ext=1234', # Optional 'tel:'
  '1-2-3-4-5-6-7-8-9-0', '1 2 3 4 5 6 7 8 9 0', # Spaces & Dashes

  'tel:+1234567890 ;ext=12345', 'tel:+1234567890x1234', # LineUri with Alternative Extension
  '1 2 3 4 5 1 2 3 4 5 6 7 8 9 0', 'tel:+1 2 3 4 5 1 2 3 4 5 6 7 8 9 0', 'tel:+1 2 3 4 5 1 2 3 4 5 6 7 8 9 0;ext=1234567' # Longest String
  #endregion
)
MatchNumber -matchString $Pattern -MatchingNumbers $NumberInput -NotMatch $false

Write-Output "$Test - SHOULDN'T MATCH String: '$Pattern'"
[string[]]$NumberInput = @(
  #region Emergency Services numbers (malformed)
  '00', '11', #'1121', '2000', '9911', # rest is matched as it has at least 3 digits! - not relevant for Find String!
  #endregion

  'tel:1 123', 'tel:123', 'tel:123;ext=4567', # Malformed LineURI (missing Plus)

  #region Upper bounds of any number
  'tel:+123456789012345678901',
  'tel:+12345678901234567890;ext=12', 'tel:+12345678901234567890;ext=123456789',
  'tel:+1 2 3 4 5 6 7 8 9 0 1 2 3 4 5;ext=12',
  'tel:+1 2 3 4 5 6 7 8 9 0 1 2 3 4 5;ext=123456789',
  '1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1'
  #endregion
)
MatchNumber -matchString $Pattern -MatchingNumbers $NumberInput -NotMatch $true
#endregion


#region Phone Number Formats suitable for application
$Test = 'Testing PhoneNumber Format (for application)'
# ApplyString (must be unambiguous and result in a valid LineURI (User) or E164 Number (Resource Account))
$Pattern = '^(tel:\+|\+)?([0-9]?[-\s]?(\(?[0-9]{3}\)?)[-\s]?([0-9]{3}[-\s]?[0-9]{4})|[0-9]{8,15})((;ext=)([0-9]{3,8}))?$'

Write-Output "$Test - SHOULD MATCH String: '$Pattern'"
[string[]]$NumberInput = @(
  #region US Number formats
  # spaces at various places
  '1234567890', '123 4567890', '123456 7890', '123 456 7890', '11234567890', '1123 4567890', '1123456 7890', '1123 456 7890',
  '1 123 456 7890', '1 1234567890', '1 (123)4567890', '1 (123) 4567890', '1 (123) 456 7890',
  # dashes everywhere
  '1-1234567890', '1-1234567890', '1-123-4567890', '1-123-456-7890', '1-1234567890', '1-(123)4567890', '1-(123)-4567890', '1-(123)-456-7890', '1(123) 456-7890',
  '1 (123)-456 7890', '1 1234567890', '1 (123)4567890', '1(123)4567890', '1(123) 456-7890', '1 (123)-456 7890',
  # mix and match
  '(123)4567890', '(123) 456-7890', '(123)-456 7890', '(123)-456-7890', '(123) 456 7890',
  '+11234567890', '+1 123 456 7890', '+1 (123) 456 7890', '+1 (123)-456-7890',
  'tel:+11234567890', 'tel:+1 123 456 7890', 'tel:+1 (123) 456 7890', 'tel:+1 (123)-456-7890'
  #endregion

  #region Line URI formats
  '12345678', '+12345678', 'tel:+12345678', # Standard Number formats (incl. E.164) lower bounds
  '123456789012345', '+123456789012345', 'tel:+123456789012345', # Standard Number formats (incl. E.164) upper bounds
  'tel:+12345678', 'tel:+123456789012345', # LineURI upper and lower bounds
  'tel:+12345678;ext=123', 'tel:+123456789012345;ext=123' # LineURI upper and lower bounds incl. Extension lower bounds
  'tel:+12345678;ext=12345678', 'tel:+123456789012345;ext=12345678' # LineURI upper and lower bounds incl. Extension upper bounds
  #endregion
)
MatchNumber -matchString $Pattern -MatchingNumbers $NumberInput -NotMatch $false

Write-Output "$Test - SHOULDN'T MATCH String: '$Pattern'"
[string[]]$NumberInput = @(
  #region Emergency Numbers
  '000', '111', '112', '133', '711', '911', '999',

  #Emergency Phone Numbers (variations)
  '1 2 3', '9-1-1' # Emergency Services Numbers with spaces and dashes

  '00', '11', '1121', '2000', '9911', # malformed Emergency Services Numbers
  #endregion

  #region Upper bounds of any number
  'tel:+123456789012345678901',
  'tel:+12345678901234567890;ext=12', 'tel:+12345678901234567890;ext=123456789',
  'tel:+1 2 3 4 5 6 7 8 9 0 1 2 3 4 5;ext=12',
  'tel:+1 2 3 4 5 6 7 8 9 0 1 2 3 4 5;ext=123456789',
  '1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1'
  #endregion

  #region Alternative Formats
  #NOTE: Some of these may be supportable with the right pattern
  '+1 123', '+123', '+123;ext=4567', '+123 456 7890 ;ext=1234', # Optional 'tel:'
  'tel:1 123', 'tel:123', 'tel:123;ext=4567', # Optional Plus
  '1-2-3-4-5-6-7-8-9-0', '1 2 3 4 5 6 7 8 9 0', # Spaces & Dashes

  'tel:+1234567890 ;ext=12345', 'tel:+1234567890x1234', # LineUri with Alternative Extension
  'tel:+1234512345678901234567890', 'tel:+1234512345678901234567890;ext=123', 'tel:+1234512345678901234567890;ext=12345678',
  '1 2 3 4 5 1 2 3 4 5 6 7 8 9 0', 'tel:+1 2 3 4 5 1 2 3 4 5 6 7 8 9 0', 'tel:+1 2 3 4 5 1 2 3 4 5 6 7 8 9 0;ext=1234567' # Longest String
  #endregion
)
MatchNumber -matchString $Pattern -MatchingNumbers $NumberInput -NotMatch $true
#endregion