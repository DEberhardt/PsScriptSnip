# Foreach Loop to test
foreach ( $i in 1..10 ) {
  Write-Progress -Id 0 -Activity "Activity $i" -Status "Status $i" -CurrentOperation "CurrentOperation $i"
  foreach ( $j in 1..10 ) {
    Write-Progress -Id 1 -ParentId 0 -Activity "CurrentOperation $i" -Status "Status $j" -CurrentOperation "CurrentOperation $j"
    foreach ( $k in 1..10 ) {
      Write-Progress -Id 2 -ParentId 1 -Activity "CurrentOperation $j" -Status "Status $k" -CurrentOperation "CurrentOperation $k"; Start-Sleep -m 150
    }
  }
}


#BEGIN

#Initialising Counters
$script:StepsID0, $script:StepsID1 = Get-WriteBetterProgressSteps -Code $($MyInvocation.MyCommand.Definition) -MaxId 1
$script:ActivityID0 = $($MyInvocation.MyCommand.Name)
[int] $script:CountID0 = [int] $script:CountID1 = 1


#PROCESS

# MaxId is 0
#before foreach ($s in $X)
[int] $script:StepsID0 = $X.Count

#inside foreach
$StatusID0 = 'Processing'
$CurrentOperationID0 = "'$UPN'"
Write-BetterProgress -Id 0 -Activity $ActivityID0 -Status $StatusID0 -CurrentOperation $CurrentOperationID0 -Step ($script:CountID0++) -Of $script:StepsID0

## MaxID is 1
$StatusID0 = 'Processing'
$CurrentOperationID0 = $ActivityID1 = "'$UPN'"
Write-BetterProgress -Id 0 -Activity $ActivityID0 -Status $StatusID0 -CurrentOperation $CurrentOperationID0 -Step ($script:CountID0++) -Of $script:StepsID0

#before foreach ($s in $X)
[int] $script:StepsID1 = $X.Count

#inside foreach
$StatusID1 = "User '$UPN'"
$CurrentOperationID1 = 'Querying User Account'
Write-BetterProgress -Id 1 -Activity $ActivityID1 -Status $StatusID1 -CurrentOperation $CurrentOperationID1 -Step ($script:CountID1++) -Of $script:StepsID1

#Situational
Write-Information "INFO:    $ActivityID1 $StatusID1 $CurrentOperationID1`: <Information>"
Write-Warning -Message "$ActivityID1 $StatusID1 $CurrentOperationID1`: <Warning>: $($_.Exception.Message)"
Write-Error -Message "$ActivityID1 $StatusID1 $CurrentOperationID1`: <Error Description> $($_.Exception.Message)"

Write-Debug -Message "$ActivityID1 $StatusID1 $CurrentOperationID1`: Not enumerated: $($_.Exception.Message)"



<# MaxId is 2
$StatusID1 = 'Processing'
$CurrentOperationID1 = $ActivityID2 = "Querying User Account"
Write-BetterProgress -Id 1 -Activity $ActivityID1 -Status $StatusID1 -CurrentOperation $CurrentOperationID1 -Step ($script:CountID1++) -Of $script:StepsID1

$StatusID2 = "User '$UPN'"
$CurrentOperationID2 = 'Querying User Account'
Write-BetterProgress -Id 2 -Activity $ActivityID2 -Status $StatusID2 -CurrentOperation $CurrentOperationID2 -Step ($script:CountID2++) -Of $script:StepsID2


#Situational
Write-Information "INFO:    $ActivityID2 $StatusID2 $CurrentOperationID2`: <Information>"
Write-Warning -Message "$ActivityID2 $StatusID2 $CurrentOperationID2`: <Warning>: $($_.Exception.Message)"
Write-Error -Message "$ActivityID2 $StatusID2 $CurrentOperationID2`: <Error Description> $($_.Exception.Message)"

Write-Debug -Message "$ActivityID2 $StatusID2 $CurrentOperationID2`: Not enumerated: $($_.Exception.Message)"

#>


# Output
Write-Progress -Id 1 -Activity $ActivityID1 -Completed

Write-Progress -Id 0 -Activity $ActivityID0 -Completed


#END