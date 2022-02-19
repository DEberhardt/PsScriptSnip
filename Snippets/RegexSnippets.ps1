# Regex Matches for certain objects

# GUID - User accounts (ObjectId), Teams, etc.
"^[0-9a-f]{8}-([0-9a-f]{4}\-){3}[0-9a-f]{12}$"

# One word (no spaces)
'^[^\W_]+$'

# Abbreviated LineUri (starting with tel:+)
'^tel:\+[0-9]'

# Two or three numerical digits
'\d{2,3}' # allows locale (do not use)!
'[0-9]{2,3]' # better

# Two or three numerical digits (separated by dash or white space)
'([0-9][-\s]){2,3]'


# Emergency Services Numbers (99% coverage)
'^(000|1(\d{2})|9(\d{2})|\d{1}11)$'

# match US Phone Numbers with spaces, dashes and leading CountryCode
'^(tel:\+[1]|\+?[1])?[-\s]?(\(?[0-9]{3}\)?)[-\s]?([0-9]{3}[-\s]?[0-9]{4})$'

# match for LineURIs (with optional + or tel:+)
'^(tel:\+|\+)?([0-9]{8,15})((;ext=)([0-9]{3,8}))?$'

# Universal Match for Phone Numbers, LineUri, etc. - FOR LOOKUP (Find-TeamsUVC) - 4-20 digits (does account for spaces everywhere)
'^(tel:\+|\+)?([0-9]?[-\s]?(\(?[0-9]{3}\)?)[-\s]?([0-9]{3}[-\s]?[0-9]{4})|([0-9][-\s]?){4,20})((x|;ext=)([0-9]{3,8}))?$'

# Universal Match for Phone Numbers, LineUri, etc. - FOR APPLICATION (SET-TeamsUVC) - 8-15 digits (no spaces)
'^(tel:\+|\+)?([0-9]?[-\s]?(\(?[0-9]{3}\)?)[-\s]?([0-9]{3}[-\s]?[0-9]{4})|[0-9]{8,15})((;ext=)([0-9]{3,8}))?$'

# Match an Extension
'([0-9]{3,15})?;?ext=([0-9]{3,8})'
# $matches[1] #will match the phone number
# $matches[2] #will match the extension

# Teams ChannelId
'^(19:)[0-9a-f]{32}(@thread.)(skype|tacv2|([0-9a-z]{5}))$'

# anything between two parenthesis: () - $matches is then populated with the <content>
if ( $_.Exception.Message -match "'(?<content>.*)'" ) {
  $matches[0]
  $matches.content
}

# Address format (for Get-CsOnlineLisLocation -LocationId $LocationId)
'^[0-9a-f]{8}-([0-9a-f]{4}\-){3}[0-9a-f]{12}$'
