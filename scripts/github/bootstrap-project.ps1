[CmdletBinding()]
param(
    [string]$ProjectTitle = "Incurrent - Distributed Counter Delivery",
    [string]$Milestone = "MVP",
    [string]$LabelsFile = "scripts/github/labels.json",
    [string]$IssuesFile = "scripts/github/issues.json",
    [switch]$SkipProject,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Resolve-InputPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [Parameter(Mandatory = $true)]
        [string]$Base
    )

    if ([System.IO.Path]::IsPathRooted($Path)) {
        return $Path
    }
    return (Join-Path $Base $Path)
}

function Assert-Gh {
    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
        throw "GitHub CLI ('gh') is not installed or not in PATH."
    }
}

Assert-Gh

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Resolve-Path (Join-Path $scriptRoot "..\..")

Push-Location $repoRoot
try {
    Write-Host "Checking GitHub authentication..."
    if (-not $DryRun) {
        gh auth status | Out-Null
    }

    $labelsPath = Resolve-InputPath -Path $LabelsFile -Base $repoRoot
    $issuesPath = Resolve-InputPath -Path $IssuesFile -Base $repoRoot

    if (-not (Test-Path $labelsPath)) {
        throw "Labels file not found: $labelsPath"
    }
    if (-not (Test-Path $issuesPath)) {
        throw "Issues file not found: $issuesPath"
    }

    $repoInfo = if ($DryRun) {
        [PSCustomObject]@{
            nameWithOwner = "owner/repo"
            url = "https://github.com/owner/repo"
        }
    } else {
        gh repo view --json nameWithOwner,url | ConvertFrom-Json
    }
    $repoFull = $repoInfo.nameWithOwner
    $owner = $repoFull.Split("/")[0]

    Write-Host "Target repository: $repoFull"

    $labels = Get-Content -Path $labelsPath -Raw | ConvertFrom-Json
    Write-Host "Syncing labels ($($labels.Count))..."
    foreach ($label in $labels) {
        $name = [string]$label.name
        $color = ([string]$label.color).TrimStart("#")
        $description = [string]$label.description

        if ($DryRun) {
            Write-Host "  [dry-run] gh label create `"$name`" --color `"$color`" --description `"$description`" --force"
        } else {
            gh label create $name --color $color --description $description --force | Out-Null
        }
    }

    Write-Host "Ensuring milestone '$Milestone' exists..."
    if (-not $DryRun) {
        $milestones = gh api "repos/$repoFull/milestones?state=all" | ConvertFrom-Json
        $existingMilestone = $milestones | Where-Object { $_.title -eq $Milestone } | Select-Object -First 1
        if (-not $existingMilestone) {
            gh api "repos/$repoFull/milestones" --method POST -f title="$Milestone" | Out-Null
            Write-Host "  Created milestone: $Milestone"
        } else {
            Write-Host "  Milestone already exists: $Milestone"
        }
    } else {
        Write-Host "  [dry-run] would query/create milestone"
    }

    $projectNumber = $null
    $projectUrl = $null

    if (-not $SkipProject) {
        Write-Host "Ensuring project '$ProjectTitle' exists..."
        if (-not $DryRun) {
            $projectList = gh project list --owner $owner --limit 100 --format json | ConvertFrom-Json
            $existingProject = $projectList.projects | Where-Object { $_.title -eq $ProjectTitle } | Select-Object -First 1
            if ($existingProject) {
                $projectNumber = $existingProject.number
                $projectUrl = $existingProject.url
                Write-Host "  Found existing project: $projectUrl"
            } else {
                $createdProject = gh project create --owner $owner --title $ProjectTitle --format json | ConvertFrom-Json
                $projectNumber = $createdProject.number
                $projectUrl = $createdProject.url
                Write-Host "  Created project: $projectUrl"
            }
        } else {
            Write-Host "  [dry-run] would query/create project"
            $projectNumber = 999
            $projectUrl = "https://github.com/users/$owner/projects/999"
        }
    } else {
        Write-Host "Skipping project creation per flag."
    }

    $issues = Get-Content -Path $issuesPath -Raw | ConvertFrom-Json
    $createdCount = 0
    $existingCount = 0
    $issueRecords = @()

    Write-Host "Syncing issues ($($issues.Count))..."
    foreach ($issue in $issues) {
        $title = [string]$issue.title
        $body = [string]$issue.body
        $body = $body -replace "\\\\n", "`n"
        $key = [string]$issue.key
        $issueMilestone = if ($issue.PSObject.Properties.Name -contains "milestone" -and $issue.milestone) {
            [string]$issue.milestone
        } else {
            $Milestone
        }
        $labelsCsv = if ($issue.labels -and $issue.labels.Count -gt 0) {
            ($issue.labels -join ",")
        } else {
            ""
        }

        if ($DryRun) {
            Write-Host "  [dry-run] would ensure issue: $key - $title"
            $issueUrl = "https://github.com/$repoFull/issues/0"
            $createdCount++
        } else {
            $searchResults = gh issue list --state all --search "$title in:title" --limit 100 --json title,url | ConvertFrom-Json
            $match = $searchResults | Where-Object { $_.title -eq $title } | Select-Object -First 1

            if ($match) {
                $issueUrl = [string]$match.url
                $existingCount++
                Write-Host "  Existing: $key -> $issueUrl"
            } else {
                $createArgs = @("issue", "create", "--title", $title, "--body", $body, "--milestone", $issueMilestone)
                if ($labelsCsv) {
                    $createArgs += @("--label", $labelsCsv)
                }
                $issueUrl = (gh @createArgs).Trim()
                $createdCount++
                Write-Host "  Created: $key -> $issueUrl"
            }
        }

        $issueRecords += [PSCustomObject]@{
            key = $key
            title = $title
            url = $issueUrl
        }
    }

    if (-not $SkipProject -and $projectNumber) {
        Write-Host "Adding issues to project #$projectNumber..."
        foreach ($record in $issueRecords) {
            if ($DryRun) {
                Write-Host "  [dry-run] gh project item-add $projectNumber --owner $owner --url $($record.url)"
                continue
            }

            try {
                gh project item-add $projectNumber --owner $owner --url $record.url | Out-Null
                Write-Host "  Added: $($record.key)"
            } catch {
                # Existing items return a non-zero result; safe to continue.
                Write-Host "  Skipped (already added or unavailable): $($record.key)"
            }
        }
    }

    Write-Host ""
    Write-Host "Bootstrap complete."
    Write-Host "Repository: $repoFull"
    if ($projectUrl) {
        Write-Host "Project: $projectUrl"
    }
    Write-Host "Issues created: $createdCount"
    Write-Host "Issues already existing: $existingCount"
} finally {
    Pop-Location
}
