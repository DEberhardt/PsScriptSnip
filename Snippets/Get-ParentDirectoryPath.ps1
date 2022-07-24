# Helper Function to determine the parent directory name from a string


function Get-ParentDirectoryPath {
  <#
	.SYNOPSIS
		Returns the Parent Directory Path for the Parent Directory Name given.
	.DESCRIPTION
		Crawls through the Directory structure (upstream only, no recursive downstream!) and searches for a parent directory
    with the name given. If no DirectoryName is provided will use the current directory.
	.PARAMETER DirectoryName
		Optional. Folder path to search for. If not provided is provided will use the current directory.
	.PARAMETER TargetParentDirectory
		Required. String to be searched for. This string is required to be found in the current Folder Path
  .EXAMPLE
    Get-ParentDirectoryPath -TargetParentDirectory "test"

    Returns the path if a parent directory is called test. Searches from the current directory
  .EXAMPLE
    Get-ParentDirectoryPath -TargetParentDirectory "test" -DirectoryName C:\Temp\Test\Subfolder\Level2\Test

    Returns the path if a parent directory is called test: C:\Temp\Test -- Note, the own directory name is ignored.
  .EXAMPLE
    Get-ParentDirectoryPath -TargetParentDirectory "test" -DirectoryName C:\Temp\Testing\Subfolder\Level2\Test

    Throws an error as the TargetParentDirectory is not part of the folder name
  .INPUTS
    System.String
  .OUTPUTS
    System.String
	.NOTES
    Used for Traversing Folder structure to find files in parent folders.
  .COMPONENT
    Helper
	.FUNCTIONALITY
		Finds correct folder names
  .LINK
    https://github.com/DEberhardt/TeamsFunctions/tree/master/docs/
	#>

  param (
    [Parameter()]
    [string]$DirectoryName = (Get-Location),

    [Parameter(Mandatory)]
    [string]$TargetParentDirectory
  )

  begin {
    #Write-Verbose -Message "[BEGIN  ] $($MyInvocation.MyCommand)"

  } #begin

  process {
    #Write-Verbose -Message "[PROCESS] $($MyInvocation.MyCommand)"
    if ( $DirectoryName -match $TargetParentDirectory ) {
      $Directory = $DirectoryName
      do {
        try {
          $Directory = Split-Path $Directory -Parent
          $Name = Split-Path $Directory -Leaf
        }
        catch {
          throw "Error encountered when splitting paths: $($_.Exception.Message)"
        }
      }
      until ($Name -eq $TargetParentDirectory)
      return $Directory
    }
    else {
      throw "No directory found in the Folder Path with the Name '$TargetParentDirectory'"
    }
  } #process

  end {
    #Write-Verbose -Message "[END    ] $($MyInvocation.MyCommand)"
  } #end
} # Get-ParentDirectoryPath
