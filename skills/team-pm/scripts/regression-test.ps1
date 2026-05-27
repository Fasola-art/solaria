<#
  regression-test.ps1 — regression-test.sh 의 Windows 포팅판.
  team-pm 스킬 설치/설정의 회귀 점검 + 보고서 생성.
  사용: powershell -File ~/.claude/skills/team-pm/scripts/regression-test.ps1
  (원본 bash 의 따옴표 내 '~' 미확장 버그는 여기서 $HOME 으로 올바르게 처리한다.)
#>
$ErrorActionPreference = "SilentlyContinue"

$claude = Join-Path $HOME ".claude"
$report = Join-Path $HOME ("workspace\reports\pm\regression-{0}.md" -f (Get-Date -Format "yyyyMMdd"))
New-Item -ItemType Directory -Force -Path (Split-Path $report -Parent) | Out-Null

$now = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
Set-Content -Path $report -Encoding UTF8 -Value @"
# PM Skills 회귀 테스트 보고서

날짜: $now

## 자동 검증 (Phase 1)
"@

# 결과 라인을 콘솔과 보고서에 동시 출력
function Emit { param([string]$Line) Write-Host $Line; Add-Content -Path $report -Value $Line -Encoding UTF8 }

# 1. pm-* 플러그인 설치 상태
Emit "### 1. pm-* 플러그인 설치 상태"
$installed = (claude plugin list 2>&1 | Select-String "pm-.*@pm-skills").Count
if ($installed -eq 8) { Emit "- [PASS] 8 플러그인 모두 설치됨" } else { Emit "- [FAIL] $installed/8 설치됨" }

# 2. team-pm 골격 파일
Emit ""
Emit "### 2. team-pm 골격 파일"
$teamPm = Join-Path $claude "skills\team-pm"
$skel = @(
  "SKILL.md","roles/pm-strategist.md","roles/discovery-lead.md","roles/execution-lead.md",
  "roles/research-lead.md","roles/analytics-lead.md","roles/gtm-lead.md","roles/toolkit-lead.md",
  "references/role-routing.yaml","references/policies.md"
)
foreach ($f in $skel) {
  $p = Join-Path $teamPm ($f -replace '/', '\')
  if (Test-Path $p) { Emit "- [PASS] $f" } else { Emit "- [FAIL] $f 누락" }
}

# 3. SSOT 문서
Emit ""
Emit "### 3. SSOT 문서"
$ssot = @(
  (Join-Path $claude "rules\pm-skills-integration.md"),
  (Join-Path $claude "skills\prd-create\references\pm-skills-frameworks.md")
)
foreach ($f in $ssot) {
  if (Test-Path $f) { Emit "- [PASS] $(Split-Path $f -Leaf)" } else { Emit "- [FAIL] $f 누락" }
}

# 4. 온톨로지 엔티티 enum 확인
Emit ""
Emit "### 4. 온톨로지 확장 (Assumption/Metric/OKR/Sprint/ABTest/Beachhead/GTMMotion/Battlecard)"
$schema = Join-Path $claude "memory\ontology\schema.yaml"
foreach ($entity in @("Assumption","Metric","OKR","UserStory","Sprint","Release","Beachhead","GTMMotion","Battlecard","ABTest")) {
  if ((Test-Path $schema) -and (Select-String -Path $schema -Pattern "^  ${entity}:" -Quiet)) { Emit "- [PASS] $entity" } else { Emit "- [FAIL] $entity 누락" }
}

# 5. 훅 등록 확인
Emit ""
Emit "### 5. 훅 등록"
$settings = Join-Path $claude "settings.json"
if ((Test-Path $settings) -and (Select-String -Path $settings -Pattern "routing-logger" -Quiet)) { Emit "- [PASS] routing-logger (PreToolUse)" } else { Emit "- [FAIL] routing-logger 미등록" }
if ((Test-Path $settings) -and (Select-String -Path $settings -Pattern "pm-output-guard" -Quiet)) { Emit "- [PASS] pm-output-guard (PostToolUse)" } else { Emit "- [FAIL] pm-output-guard 미등록" }

# 6. Routing Log 최근 기록
Emit ""
Emit "### 6. Routing Log 최근 기록"
$routing = Join-Path $claude "logs\routing.jsonl"
if (Test-Path $routing) {
  $recent = (Get-Content $routing -Tail 5 | Measure-Object -Line).Lines
  Emit "- [PASS] 최근 $recent 건 기록 있음"
} else {
  Emit "- [WARN] 로그 파일 없음 (아직 Skill/Task/Agent 호출 안 됨)"
}

# 7. CLAUDE.md 참조
Emit ""
Emit "### 7. CLAUDE.md 참조"
$claudeMd = Join-Path $claude "CLAUDE.md"
if ((Test-Path $claudeMd) -and (Select-String -Path $claudeMd -Pattern "pm-skills-integration" -Quiet)) { Emit "- [PASS] SSOT 참조 있음" } else { Emit "- [FAIL] CLAUDE.md 미갱신" }
if ((Test-Path $claudeMd) -and (Select-String -Path $claudeMd -Pattern "team-pm" -Quiet)) { Emit "- [PASS] team-pm 참조 있음" } else { Emit "- [FAIL] team-pm 미등록" }

# 8. 아티팩트 (SBOM + 백업)
Emit ""
Emit "### 8. 아티팩트"
$sbom = Join-Path $claude "sbom\pm-skills-20260421.sha256"
if (Test-Path $sbom) {
  $lines = (Get-Content $sbom | Measure-Object -Line).Lines
  Emit "- [PASS] SBOM 존재 ($lines 파일)"
}
if (Test-Path (Join-Path $claude "backups\pm-skills-preinstall-20260421")) { Emit "- [PASS] 백업 디렉토리" }

# 수동 검증 체크리스트 추가
Add-Content -Path $report -Encoding UTF8 -Value @"

## 수동 검증 (Phase 2 — 사용자 실행)

### PRD 라우팅
- [ ] T1: ``PRD 만들어줘, 새 앱 아이디어`` -> prd-create (한국어 경로)
- [ ] T2: ``8섹션 PRD 프레임워크로 작성`` -> pm-execution:create-prd
- [ ] T3: ``이 PRD 개선해줘`` + 기존 파일 -> pm-execution (보강 경로)

### team-pm Role 라우팅
- [ ] T4: ``BMC 만들어줘`` -> PM Strategist
- [ ] T5: ``가설 우선순위 정리`` -> Discovery Lead
- [ ] T6: ``스프린트 계획`` -> Execution Lead
- [ ] T7: ``사용자 페르소나 4종`` -> Research Lead
- [ ] T8: ``A/B 테스트 결과 분석`` -> Analytics Lead
- [ ] T9: ``Beachhead 시장 정의`` -> GTM Lead
- [ ] T10: ``이력서 리뷰해줘`` -> Toolkit Lead

### 회귀 테스트 (기존 경로 보존)
- [ ] T13: ``랜딩 카피 써줘`` -> marketing-skills:copywriting
- [ ] T14: ``블로그 써줘`` -> content-creator
- [ ] T15: ``디스코드로 알림`` -> hermes-route
- [ ] T16: 결제 PRD -> security 페르소나 강제 + team-pm 라우팅

### 2주 모니터링 체크포인트
- 일 10 샘플 수동 라벨링
- 오라우팅 임계 10% 이하
- NSM: team-pm 월 8회+, pm-* 월 15회+
"@

Write-Host ""
Write-Host "보고서: $report"
