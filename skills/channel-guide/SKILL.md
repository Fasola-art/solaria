---
name: channel-guide
description: "채널 및 MCP 서버 설정 가이드. Telegram, Discord, Gmail, Calendar, GitHub 등의 설정 방법 안내. /channel-guide로 호출. '채널 설정', '텔레그램 연결', 'MCP 설정' 키워드로도 호출."
---

# 채널/MCP 설정 가이드

사용자가 연결하고 싶은 서비스에 대한 설정 방법을 안내한다.

## 텔레그램 (1순위 — 주요 소통 채널)

1. 텔레그램에서 @BotFather에게 /newbot 명령
2. 봇 이름 입력 → 토큰 복사
3. 터미널에서:
   ```
   Codex --channels plugin:telegram
   ```
4. 토큰 입력 → 연결 완료
5. 이제 텔레그램에서 봇에게 메시지를 보내면 Codex가 응답

## Gmail + Google Calendar

1. Codex 세션에서 Gmail/Calendar 인증 실행
2. OAuth 인증 화면에서 구글 계정 로그인
3. 권한 허용 → 인증 완료
4. /briefing에서 자동으로 메일/일정 수집됨

## GitHub

1. GitHub Settings → Developer settings → Personal access tokens → Generate new token
2. 권한: repo, read:user, read:org
3. 토큰 복사 → 환경변수 설정:
   ```
   export GITHUB_PERSONAL_ACCESS_TOKEN="<GITHUB_PERSONAL_ACCESS_TOKEN>"
   ```
4. ~/.zshrc에 추가하면 영구 적용
5. /workflow code에서 PR 자동 생성 가능

## Discord

```
Codex --channels plugin:discord
```
- 봇 토큰 필요 (Discord Developer Portal에서 생성)

## iMessage (macOS 전용)

```
Codex --channels plugin:imessage
```
- macOS에서만 동작

## 멀티채널 동시 실행

```
Codex --channels plugin:telegram,plugin:discord
```

## 연결 상태 확인

/briefing을 실행하면 연결된 소스와 미연결 소스를 자동으로 표시합니다.
