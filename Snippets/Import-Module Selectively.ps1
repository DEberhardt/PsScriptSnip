# Using a Module to allow access to private functions
# This must be the first statement in the script
using Module AzureAdPreview

# Selectively import specific CmdLets from a different Module - otherwise use Live (AzureAd) Cmdlets
Import-Module AzureADPreview -Cmdlet Open-AzureADMSPrivilegedRoleAssignmentRequest, Get-AzureADMSPrivilegedRoleAssignment
