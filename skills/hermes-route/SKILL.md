---
name: hermes-route
description: "자연어로 Hermes Agent CLI를 호출하는 라우터. 'hermes', 'hermes-agent', '디스코드로', '슬랙에', '시그널로', '매트릭스에', '홈어시', 'SMS로', '웹훅', '매일 N시', '매주', 'N시간마다', '크론', '스케줄' 키워드로 자동 활성화. 의도를 분류(딜리버리/크론/일반 위임)하여 hermes CLI를 비대화형으로 호출하고 결과를 요약 반환."
---

# Hermes Route

Codex 세션 안에서 Hermes Agent CLI를 자연어로 호출하는 라우터. 텔레그램은 기존 launchd(jarvis)가 담당하고, 이 스킬은 **텔레그램 외 플랫폼 딜리버리 + 일반 크론 자동화 + Home Assistant 제어**를 전담한다.

## 트리거 키워드
아래 키워드 중 하나라도 감지되면 즉시 이 스킬로 라우팅:

- **직접 지칭**: "hermes", "hermes-agent", "헤르메스", "헤르메스한테", "헤르메스로"
- **플랫폼 딜리버리**: "디스코드로", "디스코드에", "슬랙에", "슬랙으로", "시그널로", "매트릭스에", "홈어시", "home assistant", "SMS로", "웹훅으로", "웹훅 보내", "이메일로 알림"
- **크론/스케줄**: "매일 N시", "매주 X요일", "N시간마다", "N분마다", "cron", "크론 등록", "스케줄"
- **Home Assistant**: "불 켜", "온도 조절", "센서 상태", "HA 호출"

**비트리거** (다른 스킬로):
- "텔레그램으로" → 기존 launchd (수정 불필요)
- "일반 작업" → Codex 본체 직접 처리

## 사전 조건

실행 전 Bash로 hermes CLI 가용성 확인:

```bash
command -v hermes >/dev/null 2>&1 || echo "HERMES_NOT_INSTALLED"
```

없으면 `references/bridge-install.md` 안내 후 중단.

구성 확인:

```bash
test -f ~/.hermes/config.yaml && echo "CONFIG_OK" || echo "CONFIG_MISSING"
```

config.yaml 없으면 `hermes setup` 또는 `bridge-install.md`의 초기 설정 단계 안내.

## 의도 분류 (3가지)

### 1) 플랫폼 딜리버리 / Delivery
**시그널**: 플랫폼 키워드 + 메시지 내용 ("디스코드로 보내", "슬랙에 포스트")

**실행**:
```bash
hermes exec "send_message 도구를 사용해 <플랫폼>의 <채널 ID>에 다음 메시지 전송: <내용>"
```

일회성 전송은 `hermes exec`, 반복/스케줄은 크론(아래 2번).

**결과 처리**: 전송 성공/실패 + 플랫폼 응답 ID만 반환. 상세 로그 제거.

### 2) 크론 / Schedule
**시그널**: 시간 표현("매일 9시", "1시간마다") + 작업 내용

**실행**:
```bash
hermes cron add \
  --name "<짧은 이름>" \
  --schedule "<cron 표현>" \
  --prompt "<실행할 작업>" \
  --delivery "<플랫폼>:<채널 ID>"
```

예시 변환:
- "매일 9시 요약 디스코드로" → `--schedule "0 9 * * *"`
- "1시간마다 GitHub 알림" → `--schedule "0 * * * *"`
- "매주 월요일 10시" → `--schedule "0 10 * * 1"`

관리 명령:
```bash
hermes cron list                 # 등록 조회
hermes cron remove <name>        # 삭제
hermes cron enable/disable <name>
```

**결과 처리**: 등록된 job 이름 + 다음 실행 시간만 반환.

### 3) 일반 위임 / General Exec
**시그널**: 위 1·2에 해당하지 않는 나머지 hermes 호출

**실행**:
```bash
hermes exec "<사용자 요청 그대로>"
```

긴 컨텍스트는 stdin으로:
```bash
echo "<context>" | hermes exec -
```

**결과 처리**: hermes 출력 요약 → 메인 스레드에 반환. 불필요한 로그/진행 메시지 제거.

## 실행 규칙 (공통)

### Bash 호출 규약
- 모든 hermes 호출은 **Bash 도구**로 실행
- 타임아웃 기본 120초, 복잡 작업은 최대 300초까지 허용
- 실행 전 `description` 필드에 "Hermes에 <의도> 위임" 형식으로 명시
- 실패 시 에러 메시지 분석 → 재시도는 1회만 (blind retry 금지)

### 컨텍스트 방화벽
- hermes 출력 전체를 메인 컨텍스트에 넣지 않음
- 요약 원칙: 핵심 결론 + 액션 아이템 + (필요 시) 전송 ID/job 이름만
- 긴 로그는 `/tmp/hermes-<timestamp>.log` 저장 후 경로만 반환

### 플랫폼 충돌 회피
- 텔레그램 타겟 요청은 기존 launchd(jarvis) 처리. hermes-route는 텔레그램 딜리버리 **거부**하고 사용자에게 "텔레그램은 jarvis 채널이 처리합니다" 안내.
- Hermes 자체 게이트웨이(`hermes gateway`)는 **실행 금지** — 수동 크론/딜리버리만 사용 (중복 수신 방지).

### 크론 안전 규칙
- 크론 등록 전 기존 `hermes cron list` 확인 → 이름 중복 차단
- 삭제는 사용자 명시 승인 시에만
- cron 표현 검증(5자리 형식) 후 등록
- 등록 후 `hermes cron list`로 실제 등록 확인

## 예시 라우팅

| 사용자 입력 | 분류 | 실행 |
|-----|-----|-----|
| "이 리뷰 결과 디스코드로 보내" | Delivery | `hermes exec "send_message discord ..."` |
| "매일 9시에 GitHub 알림을 슬랙으로" | Cron | `hermes cron add --schedule "0 9 * * *" ...` |
| "매주 월요일 10시 주간 요약 시그널로" | Cron | `hermes cron add --schedule "0 10 * * 1" ...` |
| "거실 불 꺼줘" | General(HA) | `hermes exec "ha_call_service light turn_off ..."` |
| "hermes로 이 문서 요약 시켜" | General | `hermes exec "..."` |
| "텔레그램으로 알림" | **비라우팅** | jarvis 채널이 처리, 이 스킬 비활성 |

## 출력 포맷

메인 스레드로 반환할 때 다음 구조 유지:

```
## Hermes 결과 (<의도>)

**명령**: `hermes <subcommand> ...`
**소요시간**: <초>
**상태**: 성공 / 실패

### 핵심 결과
- <포인트 1>
- <포인트 2>

### 권장 액션
- <액션 1>

(상세 로그: /tmp/hermes-xxx.log)
```

## 학습 훅
- 성공적인 호출 패턴은 세션 종료 시 learner 에이전트가 자동 캡처
- 실패 호출(인증 에러, 타임아웃, 플랫폼 API 오류)은 autofix KB에 등록
- 반복 크론 등록 패턴은 `/learn --evolve`로 `HermesUsage` 엔티티 승격 고려

## 비고
- 본 스킬은 `codex-route`와 **형제 관계**. 타겟 CLI만 다름(`codex` vs `hermes`). 공존.
- hermes의 SOUL.md/AGENTS.md/운영 루프는 **사용하지 않음** — Codex가 뇌 유지.
- 도구 카탈로그 중 Codex 네이티브와 중복되는 도구(terminal/file/web/browser)는 hermes-route로 호출하지 않음. 고유 가치 도구(send_message, cronjob, ha_*, tts) 전용.
- 상세 설치: `references/bridge-install.md`
- 위임 결정 트리: `~/.Codex/guides/hermes-delegation.md`
