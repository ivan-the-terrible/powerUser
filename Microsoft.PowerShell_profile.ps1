# Chocolatey required
Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1

Set-PSReadLineOption -HistorySearchCursorMovesToEnd

oh-my-posh init pwsh --config ~\Documents\PowerShell\powerUser\mytheme.omp.json | Invoke-Expression
Import-Module -Name Terminal-Icons
# For zoxide v0.8.0+
Invoke-Expression (& {
    $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook $hook powershell | Out-String)
})
#Change 'z' to 'cd' if you aren't using that module and put in an absolute path
#Best to use these commands if you aren't already in the local-dev directory

function firstTimeWingetInstall {
    Install-Module Terminal-Icons
    $packages = @(
        'Git.Git',
        '7zip.7zip',
        'junegunn.fzf',
        'Chocolatey.Chocolatey',
        'JanDeDobbeleer.OhMyPosh',
        'Microsoft.PowerToys',
        'Docker.DockerDesktop'
    )
    foreach ($package in $packages) {
        winget install $package
    }
}
function firstTimeChocoInstall {
    $packages = @(
        'nvm',
        'pyenv-win',
        'gh',
        'zoxide',
        'bat',
        'fd'
    )
    foreach ($package in $packages) {
        choco install $package -y
    }
}

function updateOhMyPosh { winget upgrade JanDeDobbeleer.OhMyPosh -s winget }

#POWERSHELL

function updatePowerShell {winget upgrade --id Microsoft.Powershell --source winget}
function profile {Get-Content "~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"}
function copyProfile($updateRemote) {
    $localProfile = "~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    $remoteProfile = "~\Documents\PowerShell\powerUser\Microsoft.PowerShell_profile.ps1"

    $toBeReplaced = ""
    $recentlyUpdated = ""

    if ([bool]$updateRemote) {
      $toBeReplaced = $remoteProfile
      $recentlyUpdated = $localProfile
    } else {
      $toBeReplaced = $localProfile
      $recentlyUpdated = $remoteProfile
    }

    $client = Select-String -Path $recentlyUpdated -Pattern "# CLIENT"
    if (($client.LineNumber)[1] -gt 0) {
      $clientSectionStartingLine = ($client.LineNumber)[1]
      $nonClientCode = Get-Item -Path $recentlyUpdated | Get-Content -Head ($clientSectionStartingLine - 1)
    } else {
      $nonClientCode = Get-Item -Path $recentlyUpdated | Get-Content
    }
    $nonClientCode | Out-File $toBeReplaced
}
function getDef($func) {(Get-Command $func).Definition}

function open {explorer .}

function path($file) {Get-Item $file | Select-Object FullName}

function ch {[Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory()}

function getPublicIP {(Invoke-WebRequest ifconfig.me/ip).Content.Trim()}

function wifiPass($SSID) {netsh wlan show profile name=$SSID key=clear}

#END POWERSHELL

#DOCKER
# https://docs.docker.com/engine/reference/commandline/cli/
function dv {docker compose down -v}
function up {docker compose up}
function bup {docker compose up --build}

function rebup($containerName) {docker compose build $containerName --no-cache && docker compose up -d}

function bnc {docker compose build --no-cache}
function buildall {docker compose build}
function build($containerName) {docker compose build $containerName}
function vbup {docker compose down -v && docker compose build --no-cache && docker compose up}
function prune {docker system prune}

#END DOCKER

#JIRA CLI
# https://github.com/ankitpokhrel/jira-cli#usage
function jList { jira sprint list --current -ax --columns "Key,Summary" }
function jMine { jira sprint list --current -a(jira me) --columns "Key,Summary,Status" }
function jFixVersion($fixVersion) {
    $tickets = jira sprint list --current -a(jira me) --plain --no-headers --columns "Key"
    foreach ($ticket in $tickets) {
        jira issue edit $ticket --fix-version $fixVersion --no-input
    }
}
function jAssign($issueName) {jira issue assign $issueName $(jira me)}
function jIssue { $Env:CURRENT_ISSUE_NAME }
function jSet($newIssue) {
    [Environment]::SetEnvironmentVariable("CURRENT_ISSUE_NAME", $newIssue, [System.EnvironmentVariableTarget]::User) `
    && refreshenv
    # refreshenv is from Chocolatey
}
function jView($issueName) {
    if ([bool]$issueName) {
        jira issue view $issueName
    } else {
        jira issue view $Env:CURRENT_ISSUE_NAME
    }
}
function jMove($newState, $issueName) {
    if ([bool]$issueName) {
        jira issue move $issueName $newState
    } else {
        jira issue move $Env:CURRENT_ISSUE_NAME $newState
    }
}
function jInProg($issueName) {
    if ([bool]$issueName) {
        jira issue move $issueName "In Progress"
    } else {
        jira issue move $Env:CURRENT_ISSUE_NAME "In Progress"
    }
}
function jReview($issueName) {
    if ([bool]$issueName) {
        jira issue move $issueName "Code Review"
    } else {
        jira issue move $Env:CURRENT_ISSUE_NAME "Code Review"
    }
}
function jDone($issueName) {
    if ([bool]$issueName) {
        jira issue move $issueName Done
    } else {
        jira issue move $Env:CURRENT_ISSUE_NAME Done
    }
}

#END JIRA CLI

function combinePDFs {magick -density 150 $(Get-ChildItem *pdf) output.pdf}

function restore {dotnet restore --interactive}
function nup {npm run start}
function ghidra {& "C:\Program Files\ghidra_10.2_PUBLIC\ghidraRun.bat"}

#GIT

function wt($branchName) {git worktree add -b $branchName $branchName}
function apply {
    git stash show -p | git apply
}

function reverse {
    git stash show -p | git apply -R
}

#END GIT