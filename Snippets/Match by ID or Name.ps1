
foreach ($DN in $Name) {
  #TEST matches ID and Name
  if ( $DN -match '^[0-9a-f]{8}-([0-9a-f]{4}\-){3}[0-9a-f]{12}$' ) {
    #Identity or ObjectId

  }
  else {
    #Name

  }

  #Action
}
