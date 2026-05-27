<#
  skill-change-log.ps1 — bin/skill-change-log(bash) 의 Windows 포팅판.

  Write/Edit 후 스킬 파일 변경을 차단 없이 기록한다(PostToolUse 훅).
  jq 대신 ConvertFrom-Json / ConvertTo-Json 을 쓴다. 항상 exit 0.
#>
$ErrorActionPreference = "SilentlyContinue"

$outDir  = Join-Path $HOME ".agents\runtime"
$outFile = Join-Path $outDir "skill-changes.jsonl"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

# stdin JSON 읽기
$raw = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($raw)) { exit 0 }
try { $payload = $raw | ConvertFrom-Json } catch { exit 0 }

$tool = [string]$payload.tool_name
$file = [string]$payload.tool_input.file_path

# Write/Edit 만 대상
if ($tool -ne "Write" -and $tool -ne "Edit") { exit 0 }

# 공유 스킬 경로(.agents/.claude/.codex)만 대상
$norm  = $file.Replace("\", "/")
$homeN = $HOME.Replace("\", "/").TrimEnd("/")
$inScope = $norm.StartsWith("$homeN/.agents/skills/") -or `
           $norm.StartsWith("$homeN/.claude/skills/") -or `
           $norm.StartsWith("$homeN/.codex/skills/")
if (-not $inScope) { exit 0 }

# SKILL.md / references / scripts / assets 만 대상
if ($norm -notmatch "([\\/]SKILL\.md$|/references/|/scripts/|/assets/)") { exit 0 }

# jsonl 한 줄 추가
$entry = [ordered]@{
  ts    = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
  event = "skill_file_changed"
  tool  = $tool
  file  = $file
}
try { ($entry | ConvertTo-Json -Compress) | Add-Content -Path $outFile -Encoding UTF8 } catch {}

exit 0
