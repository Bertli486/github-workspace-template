# 一次性配置：git 身份 + 凭据助手（复用 gh 的登录）
# 用法：pwsh -ExecutionPolicy Bypass -File scripts/setup-git.ps1

$ErrorActionPreference = 'Stop'

$env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' +
            [Environment]::GetEnvironmentVariable('Path', 'User')

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw '找不到 git，先装 Git for Windows：winget install --id Git.Git -e --source winget'
}

if (-not (gh auth status 2>$null)) {
    Write-Host 'gh 未登录，先执行：gh auth login --web'
    exit 1
}

$me = (gh api user) | ConvertFrom-Json
$email = if ($me.email) { $me.email } else { "$($me.login)@users.noreply.github.com" }

git config --global user.name $me.login
git config --global user.email $email
git config --global init.defaultBranch main
git config --global credential."https://github.com".helper '!gh auth git-credential'

Write-Host "已配置：$($me.login) <$email>"
Write-Host "凭据助手：$(git config --global --get credential.https://github.com.helper)"
git --version
