<#
  skill-path-guard.ps1 — bin/skill-path-guard(bash) 의 Windows 포팅판.

  공유 SSOT(~/.agents/skills) 밖에서 SKILL.md 를 직접 수정하는 것을 가드한다.
  PreToolUse 훅으로 등록해 사용한다. jq 대신 PowerShell 의 ConvertFrom-Json 을 쓴다.
  stdin 으로 훅 입력(JSON)을 받고, 차단이 필요할 때만 ask 결정 JSON 을 stdout 으로 출력한다.
#>
$ErrorActionPreference = "SilentlyContinue"

# 로그 준비
$runtimeDir = Join-Path $HOME ".agents\runtime"
$logFile    = Join-Path $runtimeDir "skill-path-guard.log"
New-Item -ItemType Directory -Force -Path $runtimeDir | Out-Null
function Write-GuardLog {
  param([string]$Message)
  try {
    $ts = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    "[$ts] $Message" | Add-Content -Path $logFile -Encoding UTF8
  } catch {}
}

# stdin JSON 읽기
$raw = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($raw)) { exit 0 }
try { $payload = $raw | ConvertFrom-Json } catch { exit 0 }

$tool = [string]$payload.tool_name
$file = [string]$payload.tool_input.file_path

# Write/Edit 가 아니면 통과
if ($tool -ne "Write" -and $tool -ne "Edit") { exit 0 }
# SKILL.md 가 아니면 통과 (경로 구분자 무관)
if ([string]::IsNullOrEmpty($file) -or ($file -notmatch "[\\/]SKILL\.md$")) { exit 0 }

# 경로 비교를 위해 슬래시로 정규화
$norm  = $file.Replace("\", "/")
$homeN = $HOME.Replace("\", "/").TrimEnd("/")

$agentsSkills = "$homeN/.agents/skills/"
$claudeSkills = "$homeN/.claude/skills/"
$codexSkills  = "$homeN/.codex/skills/"

$decisionReason = $null

# 디렉토리가 링크(심볼릭/정션)인지 검사
function Test-IsLink {
  param([string]$Path)
  if (-not (Test-Path $Path)) { return $false }
  return [bool](Get-Item $Path -Force).LinkType
}

if ($norm.StartsWith($agentsSkills)) {
  # SSOT 내부 편집은 허용
  exit 0
}
elseif ($norm.StartsWith($claudeSkills)) {
  $rel = $norm.Substring($claudeSkills.Length)
  $top = ($rel -split "/")[0]
  if ([string]::IsNullOrEmpty($top) -or $top.StartsWith("_")) { exit 0 }
  $skillDir = Join-Path (Join-Path $HOME ".claude\skills") $top
  if (Test-IsLink $skillDir) { exit 0 }
  $decisionReason = "Shared skills must be created or edited in ~/.agents/skills, then exposed to Claude with a symlink. Direct Claude skill edits require explicit approval: $file"
}
elseif ($norm.StartsWith($codexSkills)) {
  $rel = $norm.Substring($codexSkills.Length)
  $top = ($rel -split "/")[0]
  $codexAllow = @(".system", "codex-primary-runtime", "gpt-image-2", "jarvis-claude-workflows")
  if ([string]::IsNullOrEmpty($top) -or ($codexAllow -contains $top)) { exit 0 }
  $skillDir = Join-Path (Join-Path $HOME ".codex\skills") $top
  if (Test-IsLink $skillDir) { exit 0 }
  $decisionReason = "Shared skills must be created or edited in ~/.agents/skills. Direct Codex skill edits require explicit approval unless this is a system/runtime skill: $file"
}
else {
  exit 0
}

# 가드 발동: ask 결정 JSON 출력
Write-GuardLog "ASK $file"
$decision = [ordered]@{
  hookSpecificOutput = [ordered]@{
    hookEventName            = "PreToolUse"
    permissionDecision       = "ask"
    permissionDecisionReason = $decisionReason
  }
}
$decision | ConvertTo-Json -Depth 5 -Compress
exit 0
