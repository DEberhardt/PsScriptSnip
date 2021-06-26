# Regex Matches for certain objects

# GUID - User accounts (ObjectId), Teams, etc.
"^[0-9a-f]{8}-([0-9a-f]{4}\-){3}[0-9a-f]{12}$"

# One word
'^[^\W_]+$'

# Abbreviated LineUri (starting with tel:+)
'^tel:\+\d'

# Two numerical digits
'\d{2}'

# Emergency Services Numbers (99% coverage)
'^(000|1(\d{2})|9(\d{2})|\d{1}11)$'

# Universal Match for Phone Numbers, LineUri, etc.
'^(tel:)?\+?(([0-9]( |-)?)?(\(?[0-9]{3}\)?)( |-)?([0-9]{3}( |-)?[0-9]{4})|([0-9]{4,15}))?((;( |-)?ext=[0-9]{3,8}))?$'

# Teams ChannelId
'^(19:)[0-9a-f]{32}(@thread.)(skype|tacv2|([0-9a-z]{5}))$'

# anything between two parenthesis: () - $matches is then populated with the <content>
if ( $_.Exception.Message -match "'(?<content>.*)'" ) {
  $matches[0]
  $matches.content
}

# Address format (for Get-CsOnlineLisLocation -LocationId $LocationId)
'^[0-9a-f]{8}-([0-9a-f]{4}\-){3}[0-9a-f]{12}$'
