#!/usr/bin/env bash
# Sprint 4 회귀 테스트 체크리스트 (수동 실행 가이드 + 자동 검증)
# 사용: bash ~/.claude/skills/team-pm/scripts/regression-test.sh

set -uo pipefail

REPORT="~/workspace/reports/pm/regression-$(date +%Y%m%d).md"
mkdir -p "$(dirname "$REPORT")"

cat > "$REPORT" <<'EOF'
# PM Skills 회귀 테스트 보고서

날짜: $(date -u +%Y-%m-%dT%H:%M:%SZ)

## 자동 검증 (Phase 1)

EOF

echo "## 자동 검증" >&2

# 1. 플러그인 설치 확인
echo "### 1. pm-* 플러그인 설치 상태" | tee -a "$REPORT"
INSTALLED=$(claude plugin list 2>&1 | /usr/bin/grep -c "pm-.*@pm-skills" || echo 0)
if [ "$INSTALLED" -eq 8 ]; then
  echo "- [PASS] 8 플러그인 모두 설치됨" | tee -a "$REPORT"
else
  echo "- [FAIL] $INSTALLED/8 설치됨" | tee -a "$REPORT"
fi

# 2. team-pm 파일 존재
echo "" | tee -a "$REPORT"
echo "### 2. team-pm 골격 파일" | tee -a "$REPORT"
for f in SKILL.md roles/pm-strategist.md roles/discovery-lead.md roles/execution-lead.md roles/research-lead.md roles/analytics-lead.md roles/gtm-lead.md roles/toolkit-lead.md references/role-routing.yaml references/policies.md; do
  if [ -f "~/.claude/skills/team-pm/$f" ]; then
    echo "- [PASS] $f" | tee -a "$REPORT"
  else
    echo "- [FAIL] $f 누락" | tee -a "$REPORT"
  fi
done

# 3. SSOT 파일
echo "" | tee -a "$REPORT"
echo "### 3. SSOT 문서" | tee -a "$REPORT"
for f in ~/.claude/rules/pm-skills-integration.md ~/.claude/skills/prd-create/references/pm-skills-frameworks.md; do
  if [ -f "$f" ]; then
    echo "- [PASS] $(basename $f)" | tee -a "$REPORT"
  else
    echo "- [FAIL] $f 누락" | tee -a "$REPORT"
  fi
done

# 4. 온톨로지 엔티티 enum 확인
echo "" | tee -a "$REPORT"
echo "### 4. 온톨로지 확장 (Assumption/Metric/OKR/Sprint/ABTest/Beachhead/GTMMotion/Battlecard)" | tee -a "$REPORT"
for entity in Assumption Metric OKR UserStory Sprint Release Beachhead GTMMotion Battlecard ABTest; do
  if /usr/bin/grep -q "^  ${entity}:" ~/.claude/memory/ontology/schema.yaml; then
    echo "- [PASS] $entity" | tee -a "$REPORT"
  else
    echo "- [FAIL] $entity 누락" | tee -a "$REPORT"
  fi
done

# 5. 훅 등록 확인
echo "" | tee -a "$REPORT"
echo "### 5. 훅 등록" | tee -a "$REPORT"
if /usr/bin/grep -q "routing-logger" ~/.claude/settings.json; then
  echo "- [PASS] routing-logger (PreToolUse)" | tee -a "$REPORT"
else
  echo "- [FAIL] routing-logger 미등록" | tee -a "$REPORT"
fi
if /usr/bin/grep -q "pm-output-guard" ~/.claude/settings.json; then
  echo "- [PASS] pm-output-guard (PostToolUse)" | tee -a "$REPORT"
else
  echo "- [FAIL] pm-output-guard 미등록" | tee -a "$REPORT"
fi

# 6. routing log 동작
echo "" | tee -a "$REPORT"
echo "### 6. Routing Log 최근 기록" | tee -a "$REPORT"
if [ -f ~/.claude/logs/routing.jsonl ]; then
  RECENT=$(/usr/bin/tail -5 ~/.claude/logs/routing.jsonl | /usr/bin/wc -l | /usr/bin/tr -d ' ')
  echo "- [PASS] 최근 $RECENT 건 기록 있음" | tee -a "$REPORT"
else
  echo "- [WARN] 로그 파일 없음 (아직 Skill/Task/Agent 호출 안 됨)" | tee -a "$REPORT"
fi

# 7. CLAUDE.md 참조
echo "" | tee -a "$REPORT"
echo "### 7. CLAUDE.md 참조" | tee -a "$REPORT"
if /usr/bin/grep -q "pm-skills-integration" ~/.claude/CLAUDE.md; then
  echo "- [PASS] SSOT 참조 있음" | tee -a "$REPORT"
else
  echo "- [FAIL] CLAUDE.md 미갱신" | tee -a "$REPORT"
fi
if /usr/bin/grep -q "team-pm" ~/.claude/CLAUDE.md; then
  echo "- [PASS] team-pm 참조 있음" | tee -a "$REPORT"
else
  echo "- [FAIL] team-pm 미등록" | tee -a "$REPORT"
fi

# 8. SBOM + 백업
echo "" | tee -a "$REPORT"
echo "### 8. 아티팩트" | tee -a "$REPORT"
if [ -f ~/.claude/sbom/pm-skills-20260421.sha256 ]; then
  LINES=$(/usr/bin/wc -l < ~/.claude/sbom/pm-skills-20260421.sha256 | /usr/bin/tr -d ' ')
  echo "- [PASS] SBOM 존재 ($LINES 파일)" | tee -a "$REPORT"
fi
if [ -d ~/.claude/backups/pm-skills-preinstall-20260421 ]; then
  echo "- [PASS] 백업 디렉토리" | tee -a "$REPORT"
fi

# 수동 테스트 체크리스트 추가
cat >> "$REPORT" <<'EOF'

## 수동 검증 (Phase 2 — 사용자 실행)

### PRD 라우팅
- [ ] T1: `PRD 만들어줘, 새 앱 아이디어` → prd-create (한국어 경로)
- [ ] T2: `8섹션 PRD 프레임워크로 작성` → pm-execution:create-prd
- [ ] T3: `이 PRD 개선해줘` + 기존 파일 → pm-execution (보강 경로)

### team-pm Role 라우팅
- [ ] T4: `BMC 만들어줘` → PM Strategist → pm-product-strategy:business-model
- [ ] T5: `가설 우선순위 정리` → Discovery Lead → pm-product-discovery:prioritize-assumptions
- [ ] T6: `스프린트 계획` → Execution Lead → pm-execution:sprint-plan
- [ ] T7: `사용자 페르소나 4종` → Research Lead → pm-market-research:user-personas
- [ ] T8: `A/B 테스트 결과 분석` → Analytics Lead → pm-data-analytics:ab-test-analysis
- [ ] T9: `Beachhead 시장 정의` → GTM Lead → pm-go-to-market:beachhead-segment
- [ ] T10: `이력서 리뷰해줘` → Toolkit Lead → pm-toolkit:review-resume

### 외부 팀 위임
- [ ] T11: `North Star 정해줘` → team-marketing CMO (pm-marketing-growth 위임)
- [ ] T12: `경쟁사 벤치마크` → team-business (주간 크론 유지)

### 회귀 테스트 (기존 경로 보존)
- [ ] T13: `랜딩 카피 써줘` → marketing-skills:copywriting (pm-* 오라우팅 없음)
- [ ] T14: `블로그 써줘` → content-creator (team-pm 오라우팅 없음)
- [ ] T15: `디스코드로 알림` → hermes-route
- [ ] T16: 결제 PRD → security 페르소나 강제 + team-pm 라우팅

### 실행 후 확인
```bash
tail -20 ~/.claude/logs/routing.jsonl  # 라우팅 기록
/ontology query type=Assumption  # 엔티티 생성 검증
/ontology query type=Metric
```

### 2주 모니터링 체크포인트
- 일 10 샘플 수동 라벨링
- 오라우팅 임계 ≤ 10%
- NSM: team-pm 월 8회+, pm-* 월 15회+
- 초과 시 키워드 재조정 or 롤백 (`~/.claude/skills/pm-skills-rollback/SKILL.md` 후속)
EOF

echo "" >&2
echo "보고서: $REPORT" >&2
