function Update-MrGitRepo {
  [CmdletBinding()]
  param (
    [ValidateScript({
      If (Test-Path -Path $_ -PathType Container) {
          $True
      } else {
          Throw "'$_' is not a valid path."
      }
    })]
    [string]$Path = 'C:\git',

    [ValidateNotNullOrEmpty()]
    [string]$Upstream = 'upstream',

    [ValidateNotNullOrEmpty()]
    [string]$Origin = 'origin',

    [ValidateNotNullOrEmpty()]
    [string]$DefaultBranch = 'main'

  )

  Push-Location

  if (Test-MrGitPath -Path $Path) {
    $searchPath = $Path
  } else {
    $searchPath = (Get-ChildItem -Path $Path -Directory).FullName
  }

  foreach ($s in $searchPath) {
    $repoInfo = Get-MrGitRepoInfo -Path $s

    if ($repoInfo.IsGitRepo) {
      Set-Location -Path $repoInfo.TopLevelPath
      Get-Location
      git checkout $DefaultBranch
      git fetch $Upstream $DefaultBranch
      git merge $Upstream/$DefaultBranch
      git push $Origin $DefaultBranch
    }

  }

  Pop-Location

}