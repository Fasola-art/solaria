---
name: audio-processor
description: Generate subtitles, extract and convert audio, analyze narration, burn in captions, and translate video subtitles. Use for audio, voice, narration, captions, SRT, VTT, whisper, mlx-whisper, or video translation tasks.
---

# audio-processor 스킬

## 메타데이터
- **스킬 이름**: audio-processor
- **버전**: 1.0.0
- **생성일**: 2026-04-08
- **역할**: AI 자막 생성, 오디오 추출/변환, 나레이션 분석

## 트리거 키워드
다음 키워드가 포함된 요청 시 이 스킬을 자동 활성화:
- 자막, 캡션, SRT, VTT
- 오디오, 음성, 나레이션
- whisper, mlx-whisper
- 번역 (영상 맥락에서)

## 역할 정의

### 주요 기능
1. **AI 자막 생성**: mlx-whisper-mcp 또는 whisper CLI로 음성 → 텍스트 변환
2. **오디오 추출/변환**: ffmpeg으로 영상에서 오디오 분리, 포맷 변환
3. **나레이션 분석**: 자막 텍스트 분석 및 품질 검토
4. **자막 번인(Burn-in)**: ffmpeg subtitles 필터로 자막을 영상에 합성
5. **한→영 번역 자막**: whisper translate 모드로 한국어 → 영어 자막 생성

### 출력 디렉토리 규칙
```
~/workspace/content/video/projects/YYYYMMDD_프로젝트명/06_subtitles/
```
- YYYYMMDD: 작업 날짜 (예: 20260408)
- 프로젝트명: 영상 제목 또는 프로젝트 코드
- 자막 파일 네이밍: `{원본파일명}_{언어코드}.{확장자}` (예: intro_ko.srt, intro_en.srt)

## MCP 연동: mlx-whisper-mcp

### 우선순위
1. mlx-whisper-mcp 사용 가능 시 → MCP 우선 사용
2. MCP 불가 시 → whisper CLI 직접 실행

### mlx-whisper-mcp 도구 목록
- `transcribe`: 음성 → 텍스트 변환 (기본)
- `translate`: 한국어 → 영어 번역 자막 생성

### MCP 호출 예시
```
# 한국어 자막 생성
transcribe(file="input.mp4", language="ko", model="mlx-community/whisper-large-v3-turbo")

# 한→영 번역
translate(file="input.mp4", language="ko", model="mlx-community/whisper-large-v3-turbo")
```

## whisper CLI 직접 실행

### 기본 명령어 패턴
```bash
# 한국어 자막 (권장 설정)
whisper input.mp4 \
  --language ko \
  --model large-v3-turbo \
  --output_format srt \
  --output_dir ~/workspace/content/video/projects/YYYYMMDD_프로젝트명/06_subtitles/

# 한→영 번역 자막
whisper input.mp4 \
  --language ko \
  --task translate \
  --model large-v3-turbo \
  --output_format srt \
  --output_dir ~/workspace/content/video/projects/YYYYMMDD_프로젝트명/06_subtitles/

# 전체 포맷 동시 출력
whisper input.mp4 \
  --language ko \
  --model turbo \
  --output_format all \
  --output_dir ~/workspace/content/video/projects/YYYYMMDD_프로젝트명/06_subtitles/
```

### 모델 선택 기준
| 용도 | 권장 모델 |
|------|-----------|
| 한국어 (품질 우선) | large-v3-turbo |
| 영어 (빠른 처리) | small |
| 빠른 테스트 | tiny |
| 최고 품질 | large-v3 |

> 한국어는 반드시 large-v3-turbo 이상 사용 (small 이하는 오류 빈도 높음)

## 출력 포맷 가이드
| 포맷 | 용도 |
|------|------|
| srt | 유튜브 업로드, NLE(프리미어/다빈치), ffmpeg 번인 |
| vtt | 웹(HTML5 `<track>`), Notion 임베드 |
| json | 단어별 타임스탬프, 프로그래밍 연동 |
| txt | 글/요약/RAG 파이프라인 |

## 작업 흐름 (표준)

```
1. 입력 확인 (영상/오디오 파일 경로)
   ↓
2. 출력 디렉토리 생성
   mkdir -p ~/workspace/content/video/projects/YYYYMMDD_프로젝트명/06_subtitles/
   ↓
3. MCP or CLI로 자막 생성
   ↓
4. 결과 파일 확인 (SRT 내용 미리보기)
   ↓
5. (선택) 자막 번인 - ffmpeg subtitles 필터
   ↓
6. 결과 경로 보고
```

## 의존성
- **필수**: ffmpeg (오디오 추출/번인)
- **권장**: mlx-whisper-mcp (MCP 방식)
- **대체**: openai-whisper 패키지 (CLI 방식)

## 참조 문서
- [whisper 모델 가이드](references/whisper-guide.md)
- [오디오 처리 레시피](references/audio-recipes.md)
