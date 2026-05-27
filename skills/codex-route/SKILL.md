---
name: codex-route
description: "자연어로 OpenAI Codex CLI를 호출하는 라우터. '코덱스', 'Codex', '코덱스한테/로/에게', '다른 AI 리뷰', '두 번째 의견', 'OpenAI한테 맡겨', '렌스큐', 'rescue' 키워드로 자동 활성화. 의도를 분류(리뷰/렌스큐/일반 위임)하여 codex CLI(codex exec, codex review)를 비대화형으로 호출하고 결과를 요약 반환."
---

# Codex Route

Codex 세션 안에서 OpenAI Codex CLI를 자연어로 호출하는 라우터. 플러그인의 슬래시 커맨드(`/codex:review` 등)를 타이핑하지 않고, 평범한 한국어·영어 문장으로 Codex를 호출하게 한다.

## 트리거 키워드
아래 키워드 중 하나라도 감지되면 즉시 이 스킬로 라우팅:

- **직접 지칭**: "코덱스", "Codex", "codex"
- **위임 표현**: "코덱스한테", "코덱스로", "코덱스에게", "코덱스가"
- **두 번째 의견**: "다른 AI로 리뷰", "두 번째 의견", "OpenAI한테 맡겨", "GPT한테 맡겨", "크로스 체크"
- **렌스큐**: "막혔어 codex", "코덱스가 해결", "rescue", "렌스큐"
- **리뷰**: "코덱스 리뷰", "codex review", "코덱스한테 검토"

## 사전 조건
실행 전 Bash로 codex CLI 가용성 확인:
```bash
command -v codex >/dev/null 2>&1 || echo "CODEX_NOT_INSTALLED"
```
없으면 사용자에게 `/codex:setup` 또는 `npm install -g @openai/codex` 안내 후 중단.

인증 확인 (선택):
```bash
codex exec "hello" --dry-run 2>&1 | head -5
```
401/로그인 오류 감지 시 `!codex login` 안내.

## 의도 분류 (3가지)

### 1) 리뷰 / Review
**시그널**: "리뷰", "review", "검토", "봐줘", "확인해줘", "체크"
**실행**:
```bash
# 변경분 리뷰 (git 저장소 내부일 때 기본)
codex review --uncommitted

# 특정 파일/프롬프트로 리뷰
codex review "다음 파일을 검토: <파일 경로들>"

# 브랜치 대비 리뷰
codex review --base main
```
**결과 처리**: 출력 전체를 메인 컨텍스트로 넣지 말 것. 핵심 지적사항(심각도별)만 압축해 반환.

### 2) 렌스큐 / Rescue
**시그널**: "막혔어", "해결해줘", "rescue", "렌스큐", "이 에러 좀"
**실행 우선순위**:
1. 플러그인이 설치되어 있고 `codex:codex-rescue` 서브에이전트가 존재하면 → `Agent(subagent_type="codex:codex-rescue", prompt="<컨텍스트+에러>")` 호출
2. 그렇지 않으면 → `codex exec` 폴백:
```bash
codex exec "현재 문제: <설명>. 관련 파일: <경로>. 에러: <메시지>. 해결책을 제안해줘."
```
**결과 처리**: 제안된 수정이 코드 변경일 경우 **사용자에게 적용 여부 확인 후** 수동 편집 또는 `codex apply`.

### 3) 일반 위임 / General Exec
**시그널**: 위 1·2에 해당하지 않는 나머지 "코덱스" 호출
**실행**:
```bash
codex exec "<사용자 요청 그대로>"
```
긴 컨텍스트는 stdin으로:
```bash
echo "<context>" | codex exec -
```
**결과 처리**: Codex 출력 요약 → 메인 스레드에 반환. 불필요한 로그/진행 메시지 제거.

## 실행 규칙 (공통)

### Bash 호출 규약
- 모든 codex 호출은 **Bash 도구**로 실행
- 타임아웃 기본 120초, 복잡 작업은 최대 300초까지 허용
- 실행 전 `description` 필드에 "Codex에 <의도> 위임" 형식으로 명시
- 실패 시 에러 메시지 분석 → 재시도는 1회만 (blind retry 금지)

### 컨텍스트 방화벽
- Codex 출력 전체를 메인 컨텍스트에 넣지 않음
- 요약 원칙: 핵심 결론 + 액션 아이템 + (필요 시) 코드 스니펫 한두 개만
- 긴 로그는 `/tmp/codex-<timestamp>.log` 저장 후 경로만 반환

### 코드 변경 안전 규칙
- Codex가 파일 수정을 제안하면 **반드시 사용자 확인** 후 적용
- `codex apply` 는 사용자 명시 승인 시에만 실행
- 파일 수정 전 git status 확인, 미커밋 변경 보존

### 중복 호출 방지
- 같은 세션에서 동일 프롬프트로 3회 이상 호출되면 경고
- 결과가 반복되면 다른 접근(예: `--model` 변경 또는 Codex로 돌아가기) 제안

## 예시 라우팅

| 사용자 입력 | 분류 | 실행 |
|-----|-----|-----|
| "이 변경분 코덱스한테 리뷰 맡겨" | Review | `codex review --uncommitted` |
| "코덱스한테 두 번째 의견 받아봐" | Review | `codex review "현재 변경분"` |
| "이 에러 막혔어, 코덱스 렌스큐" | Rescue | `Agent(codex:codex-rescue)` or `codex exec` |
| "코덱스한테 이 정규식 최적화 시켜" | General | `codex exec "..."` |
| "OpenAI한테 이 아키텍처 검토 맡겨" | Review | `codex exec "아키텍처 리뷰: ..."` |

## 출력 포맷
메인 스레드로 반환할 때 다음 구조 유지:

```
## Codex 결과 (<의도>)

**명령**: `codex <subcommand> ...`
**소요시간**: <초>
**상태**: 성공 / 실패

### 핵심 결론
- <포인트 1>
- <포인트 2>

### 권장 액션
- <액션 1>
- <액션 2>

(상세 로그: /tmp/codex-xxx.log)
```

## 학습 훅
- 성공적인 호출 패턴은 세션 종료 시 learner 에이전트가 자동 캡처
- 실패 호출(인증 에러, 타임아웃, 잘못된 프롬프트)은 autofix KB에 등록
- 반복되는 사용 패턴은 `/learn --evolve` 로 온톨로지에 `CodexUsage` 엔티티로 승격 고려

## 비고
- 본 스킬은 `openai/codex-plugin-cc` 플러그인과 **독립**적으로 동작 (codex CLI만 있으면 충분)
- 플러그인이 설치되어 있으면 `codex:codex-rescue` 서브에이전트를 우선 활용
- 슬래시 커맨드 `/codex:review`, `/codex:rescue` 는 사용자가 직접 타이핑할 때의 "명시적 경로"로 병행 유지
