# Hermes Bridge 설치 가이드


## Contents

- [전제](#전제)
- [설치 (권장: uv)](#설치-권장-uv)
- [전역 CLI 등록](#전역-cli-등록)
- [초기 설정](#초기-설정)
  - [1. config.yaml 생성](#1-configyaml-생성)
  - [2. 최소 설정 (claude route 용도)](#2-최소-설정-claude-route-용도)
  - [3. API 키 설정](#3-api-키-설정)
- [크론 딜리버리 활성](#크론-딜리버리-활성)
  - [Discord 예시](#discord-예시)
  - [Slack 예시](#slack-예시)
  - [크론 틱 데몬 (필수)](#크론-틱-데몬-필수)
- [업데이트](#업데이트)
- [제거](#제거)
- [문제 해결](#문제-해결)
- [보안 주의](#보안-주의)

hermes-route 스킬이 호출하는 `hermes` CLI 설치·구성 SSOT.

## 전제
- Python 3.11+
- macOS / Linux (Windows는 WSL2)
- `uv` 권장 (없으면 `pip` 가능)
- 저장소는 `~/workspace/projects/hermes-agent/`에 이미 클론되어 있다고 가정

## 설치 (권장: uv)

```bash
cd ~/workspace/projects/hermes-agent
uv venv venv --python 3.11
source venv/bin/activate
uv pip install -e "."
```

**옵션 extras** (필요에 따라 선택):
- `.[messaging]` — Discord/Slack/Signal/Matrix/WhatsApp 등 플랫폼 딜리버리
- `.[voice]` — TTS (faster-whisper, edge-tts)
- `.[homeassistant]` — Home Assistant 통합
- `.[all]` — 전체 (macOS에서 matrix 암호화는 제외됨)

선택 설치 예:
```bash
uv pip install -e ".[messaging,voice,homeassistant]"
```

## 전역 CLI 등록

venv 활성 없이 `hermes` 명령을 전역에서 사용하려면:

```bash
# ~/.zshrc에 추가
export PATH="$HOME/workspace/projects/hermes-agent/venv/bin:$PATH"
```

또는 심볼릭 링크:
```bash
ln -s ~/workspace/projects/hermes-agent/venv/bin/hermes /usr/local/bin/hermes
```

검증:
```bash
command -v hermes && hermes --version
```

## 초기 설정

### 1. config.yaml 생성
```bash
mkdir -p ~/.hermes
cp ~/workspace/projects/hermes-agent/cli-config.yaml.example ~/.hermes/config.yaml
```

### 2. 최소 설정 (claude route 용도)

`~/.hermes/config.yaml` 주요 섹션:

```yaml
# 모델: Claude Code가 뇌이므로 hermes는 경량 보조 모델 사용
model:
  default: "anthropic/claude-haiku-4-5"
  provider: "anthropic"

# 터미널 백엔드: 로컬만
terminal:
  backend: "local"

# 게이트웨이는 사용 안 함 (텔레그램은 launchd가 처리)
# gateway 섹션 전체 주석 처리

# 크론은 활성
# 크론 저장 경로: ~/.hermes/cron/jobs.json (기본값)

# Toolsets: 최소만
toolsets: ["hermes-cli"]

# 에이전트 턴 제한 (crons는 짧게)
agent:
  max_turns: 10
```

### 3. API 키 설정

`~/.hermes/.env` 생성 (chmod 600):

```bash
ANTHROPIC_API_KEY=<ANTHROPIC_API_KEY>
# 플랫폼별 (사용하는 것만)
DISCORD_BOT_TOKEN=<DISCORD_BOT_TOKEN>
SLACK_BOT_TOKEN=<SLACK_BOT_TOKEN>
SIGNAL_CLI_PATH=/usr/local/bin/signal-cli
HOME_ASSISTANT_URL=http://homeassistant.local:8123
HOME_ASSISTANT_TOKEN=<HOME_ASSISTANT_TOKEN>
```

**주의**: 시크릿은 보안 규칙에 따라 대화에 노출 금지. 직접 파일에 작성.

## 크론 딜리버리 활성

### Discord 예시
```bash
hermes cron add \
  --name "daily-summary-discord" \
  --schedule "0 9 * * *" \
  --prompt "오늘의 요약을 생성해라" \
  --delivery "discord:channel_id=123456789"
```

### Slack 예시
```bash
hermes cron add \
  --name "weekly-report-slack" \
  --schedule "0 10 * * 1" \
  --prompt "지난 주 활동 보고서" \
  --delivery "slack:channel=#reports"
```

### 크론 틱 데몬 (필수)

크론 실행을 위해 `hermes cron tick`을 주기적으로 돌려야 함.

**옵션 A**: 시스템 cron (간단)
```cron
# crontab -e
* * * * * /usr/local/bin/hermes cron tick >/dev/null 2>&1
```

**옵션 B**: launchd plist (권장, 기존 패턴 일치)

`~/Library/LaunchAgents/com.mane23.hermes.cron-tick.plist` 생성 후 `launchctl load`. 템플릿은 `~/.claude/launchd/INSTALL.md` 참조.

## 업데이트

```bash
cd ~/workspace/projects/hermes-agent
git pull
source venv/bin/activate
uv pip install -e "." --upgrade
```

## 제거

```bash
rm -rf ~/workspace/projects/hermes-agent/venv
rm -rf ~/.hermes
# PATH 또는 심볼릭 링크 제거
```

## 문제 해결

| 증상 | 원인 | 해결 |
|---|---|---|
| `HERMES_NOT_INSTALLED` | PATH 미설정 | 위 "전역 CLI 등록" 단계 |
| `CONFIG_MISSING` | config.yaml 없음 | `hermes setup` 또는 수동 복사 |
| 플랫폼 전송 실패 | API 키 누락 | `~/.hermes/.env` 확인 |
| 크론 실행 안 됨 | tick 데몬 미등록 | 위 "크론 틱 데몬" 단계 |
| matrix 암호화 에러 (macOS) | 플랫폼 제약 | matrix extra 미설치 유지 |

## 보안 주의
- `~/.hermes/.env`, `~/.hermes/config.yaml`은 chmod 600
- API 키 하드코딩 금지 (항상 .env 경유)
- `hermes exec`로 임의 코드 실행 가능 → 프롬프트 주입 주의 (신뢰 출처만)
