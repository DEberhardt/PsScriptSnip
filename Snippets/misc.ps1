# Pipelining with Custom properties
Import-Csv c:\users2.csv |
  ➥ Select-Object *, @{l = 'samAccountName'; e = { $_.LoginName } },
  ➥ @{l = 'Name'; e = { $_.LoginName } },
  ➥ @{l = 'GivenName'; e = { $_.FirstName } },
  ➥ @{l = 'Surname'; e = { $_.LastName }}

# reformat column name to allow binding to next command in pipe
@{label = 'Column_or_Property_Name'; expression = { Value_expression } }
# in short:
@{l = 'this'; e = { that } }
# example
@{l = 'ComputerName'; e = { $_.Name } }

# Formatting output
Get-Process | Format-Table Name, @{l = 'VM(MB)'; e = { $_.VM / 1MB -as [int] } } -autosize
# Formats VM to MBs as integers and labels it 'VM(MB)'