<#
  pm-output-guard.ps1 — pm-output-guard.sh 의 Windows 포팅판 (team-pm 전용).
  SSOT: rules/pm-skills-integration.md 12절
  경고만 한다(exit 0). 차단은 security-guard 소관. jq/python 대신 PowerShell 사용.
#>
$ErrorActionPreference = "SilentlyContinue"

# stdin JSON 읽기
$raw = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($raw)) { exit 0 }
try { $payload = $raw | ConvertFrom-Json } catch { exit 0 }

# 점검 대상 텍스트 = tool_response.output + tool_input 의 문자열 값들
$text = ""
try { if ($payload.tool_response.output) { $text = [string]$payload.tool_response.output } } catch {}
if ($payload.tool_input) {
  foreach ($prop in $payload.tool_input.PSObject.Properties) {
    if ($prop.Value -is [string]) { $text += "`n" + $prop.Value }
  }
}

# 민감 패턴 (원본 bash 패턴과 동일)
$patterns = @(
  'sk-[A-Za-z0-9]{20,}',
  'AKIA[A-Z0-9]{16}',
  'ghp_[A-Za-z0-9]{20,}',
  'xoxb-[A-Za-z0-9-]{20,}',
  'DATABASE_URL=[a-z]+://\S+',
  'Bearer\s+[A-Za-z0-9_.-]{20,}'
)

$detected = @()
foreach ($pat in $patterns) {
  if ($text -match $pat) { $detected += $pat }
}

if ($detected.Count -gt 0) {
  [Console]::Error.WriteLine("[PM-OUTPUT-GUARD] 경고: 민감 패턴 감지 (pm-data-analytics SQL 출력 주의)")
  foreach ($d in $detected) { [Console]::Error.WriteLine("  - $d") }
  [Console]::Error.WriteLine("  rules/security.md 재발급 프로토콜")
}

exit 0
