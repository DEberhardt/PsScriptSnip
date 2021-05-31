# Call Stack options for scripts

$Stack = Get-PSCallStack
$Called = ($stack.length -ge 3)

# $Called can be used to query whether the function is called by Console ($False) or another function ($true)

$CalledByAssertTUVC = ($Stack.Command -Contains 'Assert-TeamsUserVoiceConfig')

# $CalledByAssertTUVC can be used to ascertain whether a certain function called this function ($true) or not ($False)
