[CmdletBinding()]
param(
    [switch]$Force
)

function Fail {
    param([string]$Message)
    Write-Host "ERROR: $Message" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "flutter release publish" -ForegroundColor Cyan
Write-Host "=====================" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path ".git")) {
    Fail "Not in a git repository."
}

if (-not (Test-Path "pubspec.yaml")) {
    Fail "pubspec.yaml not found."
}

try {
    $match = Select-String -Path "pubspec.yaml" -Pattern "^version:\s*(.+)$" | Select-Object -First 1
} catch {
    Fail "Unable to read pubspec.yaml: $_"
}

if (-not $match) {
    Fail "Could not find version in pubspec.yaml."
}

$fullVersion = $match.Matches[0].Groups[1].Value.Trim()
if (-not $fullVersion) {
    Fail "Version entry in pubspec.yaml is empty."
}

$version = $fullVersion.Split('+')[0]
if (-not $version) {
    Fail "Version value is invalid."
}

$tag = "v$version"

Write-Host "Version detected: $fullVersion"
Write-Host "Tag to publish: $tag"
Write-Host ""

$status = git status --porcelain
if ($LASTEXITCODE -ne 0) {
    Fail "Unable to read git status."
}

if ($status) {
    Write-Host "WARNING: Uncommitted changes detected." -ForegroundColor Yellow
    git status --short
    Write-Host ""
    $response = Read-Host "Continue anyway? (y/N)"
    if ($response -notin @('y','Y')) {
        Fail "Aborted by user."
    }
}

$branch = (git rev-parse --abbrev-ref HEAD).Trim()
if ($LASTEXITCODE -ne 0 -or -not $branch) {
    Fail "Unable to determine current branch."
}

if ($branch -eq 'HEAD') {
    Fail "You are in a detached HEAD state. Checkout a branch before publishing."
}

$remotes = git remote
if ($LASTEXITCODE -ne 0) {
    Fail "Unable to read git remotes."
}

if (-not ($remotes -contains 'origin')) {
    Fail "Remote 'origin' is not configured."
}

$originUrl = (git remote get-url origin)
if ($LASTEXITCODE -ne 0 -or -not $originUrl) {
    Fail "Unable to determine remote 'origin' URL."
}
$originUrl = $originUrl.Trim()

$existingTag = git tag -l $tag | Select-Object -First 1
if ($LASTEXITCODE -ne 0) {
    Fail "Unable to check for existing tag '$tag'."
}
if ($existingTag) {
    $existingTag = $existingTag.Trim()
}

if ($existingTag) {
    if ($Force) {
        Write-Host "Deleting existing tag '$tag' (force mode)." -ForegroundColor Yellow
        git tag -d $tag | Out-Null
        if ($LASTEXITCODE -ne 0) {
            Fail "Failed to delete local tag '$tag'."
        }
        git push origin --delete $tag 2>$null
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Remote tag '$tag' did not exist or could not be deleted." -ForegroundColor Yellow
        }
    } else {
        Write-Host "Tag '$tag' already exists." -ForegroundColor Yellow
        $response = Read-Host "Delete and recreate it? (y/N)"
        if ($response -in @('y','Y')) {
            git tag -d $tag | Out-Null
            if ($LASTEXITCODE -ne 0) {
                Fail "Failed to delete local tag '$tag'."
            }
            git push origin --delete $tag 2>$null
            if ($LASTEXITCODE -ne 0) {
                Write-Host "Remote tag '$tag' did not exist or could not be deleted." -ForegroundColor Yellow
            }
        } else {
            Fail "Aborted by user."
        }
    }
}

Write-Host "Pushing branch '$branch' to origin..." -ForegroundColor Cyan
git push origin $branch
if ($LASTEXITCODE -ne 0) {
    Write-Host "Remote URL: $originUrl" -ForegroundColor Yellow
    Fail "Failed to push branch '$branch'. Ensure you have access to 'origin'."
}

Write-Host "Creating annotated tag '$tag'..." -ForegroundColor Cyan
git tag -a $tag -m "Release $version"
if ($LASTEXITCODE -ne 0) {
    Fail "Failed to create tag '$tag'."
}

Write-Host "Pushing tag '$tag' to origin..." -ForegroundColor Cyan
git push origin $tag
if ($LASTEXITCODE -ne 0) {
    Write-Host "Tag push failed. Removing local tag." -ForegroundColor Yellow
    git tag -d $tag | Out-Null
    Fail "Failed to push tag '$tag'."
}

Write-Host ""
Write-Host "Publish succeeded." -ForegroundColor Green

if ($originUrl -like 'https://github.com/*' -or $originUrl -like 'git@github.com:*') {
    $repoPath = $originUrl -replace '.*github\\.com[:/]', '' -replace '\\.git$', ''
    if ($repoPath) {
        Write-Host "GitHub Actions: $repoPath/actions" -ForegroundColor Cyan
        Write-Host "Release page: $repoPath/releases/tag/$tag" -ForegroundColor Cyan
    }
}
