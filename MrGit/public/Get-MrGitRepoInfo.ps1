function Get-MrGitRepoInfo {
  [CmdletBinding()]
  param (
    [Parameter(ValueFromPipeline)]
    [ValidateScript({
      If (Test-Path -Path $_ -PathType Container) {
          $True
      } else {
          Throw "'$_' is not a valid path."
      }
    })]
    [string[]]$Path = 'C:\git'
  )

  BEGIN {
    Push-Location
  }

  PROCESS {

    foreach ($p in $Path) {
      Set-Location -Path $p

      try {
        $gitPath = [bool](git rev-parse --is-inside-work-tree 2> $null)
      } catch {
        Write-Warning -Message $_.Exception.Message
        continue
      }

      if ($gitPath) {
        $RepoName = Split-Path -Leaf (git remote get-url origin)
        $TopLevelPath = git rev-parse --show-toplevel
      }

      [pscustomobject]@{
        RepoName = $RepoName
        TopLevelPath = $TopLevelPath
        Path = $p
        IsGitRepo = if ($gitPath) {$gitPath} else {$false}
      }

    }

  }

  END {
    Pop-Location
  }

}