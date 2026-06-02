# OpenClaw Trader 一键安装（Windows PowerShell）
# 需要: Docker Desktop
param(
  [string]$ApiKey = "",
  [string]$SimToken = "",
  [string]$InstallDir = "$env:USERPROFILE\.openclaw-trader"
)

$ErrorActionPreference = "Stop"
$ProductDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Version = Get-Content (Join-Path $ProductDir "VERSION") -Raw
$Version = $Version.Trim()

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
  Write-Error "请先安装 Docker Desktop: https://docs.docker.com/desktop/setup/install/windows-install/"
}

if (-not $ApiKey) { $ApiKey = Read-Host "请输入 API Key（DeepSeek）" }
if (-not $SimToken) { $SimToken = Read-Host "请输入模拟盘 Token" }

New-Item -ItemType Directory -Force -Path $InstallDir, "$InstallDir\data", "$InstallDir\workspace" | Out-Null

$gatewayToken = -join ((48..57) + (97..102) | Get-Random -Count 48 | ForEach-Object { [char]$_ })
# 简化：用 GUID
$gatewayToken = [guid]::NewGuid().ToString("N")

@"
DEEPSEEK_API_KEY=$ApiKey
MX_APIKEY=$ApiKey
SIM_TRADING_TOKEN=$SimToken
OPENCLAW_HOME=$InstallDir\data
OPENCLAW_GATEWAY_TOKEN=$gatewayToken
GATEWAY_PORT=18789
TZ=Asia/Shanghai
TRADER_IMAGE=openclaw-trader:$Version
INSTALL_DIR=$InstallDir
"@ | Set-Content -Path (Join-Path $InstallDir ".env") -Encoding UTF8

Copy-Item (Join-Path $ProductDir "docker-compose.yml") (Join-Path $InstallDir "docker-compose.yml")
(Get-Content (Join-Path $InstallDir "docker-compose.yml")) -replace '\$\{INSTALL_DIR:-\./install\}', $InstallDir | Set-Content (Join-Path $InstallDir "docker-compose.yml")

Write-Host "请在 WSL2 或 Git Bash 中执行镜像构建:"
Write-Host "  cd $ProductDir && bash scripts/build-image.sh"
Write-Host "启动:"
Write-Host "  cd $InstallDir && docker compose up -d"
