<#
.SYNOPSIS
  Solaria 설치 스크립트 (Windows 포팅판).

.DESCRIPTION
  install.sh의 PowerShell 포팅판이다. Solaria를 ~/.agents 에 설치하고
  Claude/Codex 에 skill-management 스킬을 링크로 노출한다.
  동작은 install.sh 와 동일하게 맞추되, Windows 도구(robocopy, New-Item -SymbolicLink)를 쓴다.

.PARAMETER DryRun
  실제 파일을 바꾸지 않고 수행할 작업만 출력한다.
.PARAMETER NoBackup
  기존 ~/.agents 의 타임스탬프 백업을 만들지 않는다.
.PARAMETER NoClaude
  ~/.claude/skills/skill-management 링크를 만들지 않는다.
.PARAMETER NoCodex
  ~/.codex/skills/skill-management 링크를 만들지 않는다.

.NOTES
  Windows 심볼릭 링크는 개발자 모드 또는 관리자 권한이 필요하다.
  권한이 없으면 디렉토리 정션(Junction)으로 자동 대체한다.
#>
[CmdletBinding()]
param(
  [switch]$DryRun,
  [switch]$NoBackup,
  [switch]$NoClaude,
  [switch]$NoCodex
)

$ErrorActionPreference = "Stop"

# 경로 설정 (install.sh의 ROOT_DIR/AGENTS_HOME/BACKUP_ROOT/STAMP 대응)
$RootDir    = $PSScriptRoot
$AgentsHome = Join-Path $HOME ".agents"
$BackupRoot = Join-Path $HOME ".agents-backups"
$Stamp      = Get-Date -Format "yyyyMMdd-HHmmss"

# ~/.agents 로 복사할 항목 (install.sh copy_items 와 동일)
$CopyItems = @(
  "bin", "skills", "personas", "ontology",
  "evals", "external-skills", "reports", "skills-registry.json"
)

# dry-run 이면 설명만 출력, 아니면 실제 실행
function Invoke-Step {
  param([Parameter(Mandatory)][scriptblock]$Action, [Parameter(Mandatory)][string]$Describe)
  if ($DryRun) { Write-Host "[dry-run] $Describe" }
  else { & $Action }
}

# 경로를 타임스탬프 백업 폴더로 복사 (install.sh backup_path 대응)
function Backup-Path {
  param([string]$Path, [string]$Label)
  if (-not (Test-Path $Path)) { return }
  if ($NoBackup) { return }
  $dest = Join-Path (Join-Path $BackupRoot $Stamp) $Label
  Invoke-Step -Describe "backup '$Path' -> '$dest'" -Action {
    New-Item -ItemType Directory -Force -Path (Split-Path $dest -Parent) | Out-Null
    Copy-Item -Path $Path -Destination $dest -Recurse -Force
  }
}

# 항목 하나를 ~/.agents 로 복사 (rsync 제외 규칙은 robocopy /XD /XF 로 대응)
function Copy-InstallItem {
  param([string]$Src, [string]$DestRoot)
  $name = Split-Path $Src -Leaf
  if (Test-Path $Src -PathType Leaf) {
    Invoke-Step -Describe "copy file '$name' -> '$DestRoot'" -Action {
      Copy-Item -Path $Src -Destination (Join-Path $DestRoot $name) -Force
    }
    return
  }
  $dest = Join-Path $DestRoot $name
  Invoke-Step -Describe "robocopy dir '$name' -> '$dest' (exclude .git __pycache__ *.pyc .DS_Store)" -Action {
    $null = robocopy $Src $dest /E /PURGE /XD ".git" "__pycache__" /XF "*.pyc" ".DS_Store" /NFL /NDL /NJH /NJS /NP
    # robocopy 종료 코드: 0~7 정상, 8 이상 오류
    if ($LASTEXITCODE -ge 8) { throw "robocopy 실패: $name (exit $LASTEXITCODE)" }
    $global:LASTEXITCODE = 0
  }
}

# skill-management 링크 생성 (install.sh link_skill_management 대응)
# Windows: 상대경로 대신 절대경로 타깃 사용. SymbolicLink 실패 시 Junction 으로 대체.
function New-SkillManagementLink {
  param([string]$RuntimeRoot, [string]$Label)
  $skillsDir = Join-Path $RuntimeRoot "skills"
  $linkPath  = Join-Path $skillsDir "skill-management"
  $target    = Join-Path $AgentsHome "skills\skill-management"

  if (Test-Path $linkPath) {
    $item = Get-Item $linkPath -Force
    if ($item.LinkType -and ($item.Target -eq $target)) {
      Write-Host "${Label}: skill-management 링크가 이미 존재합니다"
      return
    }
    Backup-Path -Path $linkPath -Label "$Label-skill-management"
    Invoke-Step -Describe "remove existing '$linkPath'" -Action { Remove-Item -Path $linkPath -Recurse -Force }
  }

  Invoke-Step -Describe "mkdir '$skillsDir'" -Action { New-Item -ItemType Directory -Force -Path $skillsDir | Out-Null }

  if ($DryRun) { Write-Host "[dry-run] link '$linkPath' -> '$target' (SymbolicLink, 실패 시 Junction)"; return }

  try {
    New-Item -ItemType SymbolicLink -Path $linkPath -Target $target -ErrorAction Stop | Out-Null
    Write-Host "${Label}: SymbolicLink 생성 -> $target"
  } catch {
    Write-Warning "${Label}: SymbolicLink 생성 실패(개발자 모드/관리자 권한 필요). Junction 으로 대체합니다."
    New-Item -ItemType Junction -Path $linkPath -Target $target | Out-Null
    Write-Host "${Label}: Junction 생성 -> $target"
  }
}

# ---- 메인 ----
Write-Host "Solaria installer (Windows)"
Write-Host "Source: $RootDir"
Write-Host "Target: $AgentsHome"

# 기존 ~/.agents 백업
if ((-not $NoBackup) -and (Test-Path $AgentsHome)) {
  Write-Host "기존 ~/.agents 를 $BackupRoot\$Stamp\agents 로 백업합니다"
  Backup-Path -Path $AgentsHome -Label "agents"
}

Invoke-Step -Describe "mkdir '$AgentsHome'" -Action { New-Item -ItemType Directory -Force -Path $AgentsHome | Out-Null }
Invoke-Step -Describe "mkdir '$AgentsHome\research\creation-briefs'" -Action { New-Item -ItemType Directory -Force -Path (Join-Path $AgentsHome "research\creation-briefs") | Out-Null }

foreach ($item in $CopyItems) {
  $src = Join-Path $RootDir $item
  if (-not (Test-Path $src)) { throw "설치 항목 누락: $src" }
  Copy-InstallItem -Src $src -DestRoot $AgentsHome
}

if (-not $NoClaude) { New-SkillManagementLink -RuntimeRoot (Join-Path $HOME ".claude") -Label "claude" }
if (-not $NoCodex)  { New-SkillManagementLink -RuntimeRoot (Join-Path $HOME ".codex")  -Label "codex" }

# 설치 검증 (install.sh 의 skill-health-check --write 대응)
$healthCheck = Join-Path $AgentsHome "bin\skill-health-check"
if ((-not $DryRun) -and (Test-Path $healthCheck)) {
  $py = Get-Command python -ErrorAction SilentlyContinue
  if (-not $py) { $py = Get-Command python3 -ErrorAction SilentlyContinue }
  if ($py) {
    & $py.Source $healthCheck --write
  } else {
    Write-Warning "python 을 찾을 수 없어 skill-health-check 를 건너뜁니다."
  }
}

Write-Host "Install complete."
