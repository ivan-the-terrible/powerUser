Set-PSReadlineKeyHandler -Key Tab -Function HistorySearchBackward

oh-my-posh init pwsh --config ~\Documents\PowerShell\powerUser\mytheme.omp.json | Invoke-Expression
Import-Module -Name Terminal-Icons
# For zoxide v0.8.0+
Invoke-Expression (& {
    $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook $hook powershell | Out-String)
})
#Change 'z' to 'cd' if you aren't using that module and put in an absolute path
#Best to use these commands if you aren't already in the local-dev directory

function updateOhMyPosh { winget upgrade JanDeDobbeleer.OhMyPosh -s winget }

#POWERSHELL

function updatePowerShell {winget upgrade --id Microsoft.Powershell --source winget}
function profile {Get-Content "C:\Users\Ivan Chwalik\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"}
function updateProfile {
    Copy-Item "C:\Users\Ivan Chwalik\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    "C:\Users\Ivan Chwalik\Documents\PowerShell\powerUser\Microsoft.PowerShell_profile.ps1" `
    && Set-Location "C:\Users\Ivan Chwalik\Documents\PowerShell\powerUser" `
    && git commit -a -m "Updated profile" `
    && git push
}
function getDef($func) {(Get-Command $func).Definition}

function ch {[Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory()}

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
function jAssign($issueName) {jira issue assign $issueName $(jira me)}
function currentIssue { $Env:CURRENT_ISSUE_NAME }
function updateCurrentIssue($newIssue) {
    [Environment]::SetEnvironmentVariable("CURRENT_ISSUE_NAME", $newIssue, [System.EnvironmentVariableTarget]::User) &&
    refreshenv

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

function restore {dotnet restore --interactive}
function nup {npm run start}
function ghidra {& "C:\Program Files\ghidra_10.2_PUBLIC\ghidraRun.bat"}

