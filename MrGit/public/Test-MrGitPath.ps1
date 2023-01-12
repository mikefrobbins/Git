function Test-MrGitPath {
  [CmdletBinding()]
  param (
    [ValidateScript({
      If (Test-Path -Path $_ -PathType Container) {
          $True
      } else {
          Throw "'$_' is not a valid path."
      }
    })]
    [string[]]$Path = 'C:\git'
  )

  Push-Location

  foreach ($p in $Path) {
    Set-Location -Path $p

    try {
      [bool](git rev-parse --is-inside-work-tree 2> $null)
    } catch [System.Management.Automation.CommandNotFoundException] {
      Write-Warning -Message $_.Exception.Message
    } catch {
      $false
      continue
    }

  }

  Pop-Location

}