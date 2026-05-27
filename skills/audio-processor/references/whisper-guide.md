# Whisper 모델 가이드


## Contents

- [모델 비교 (Apple Silicon 기준)](#모델-비교-apple-silicon-기준)
- [출력 포맷](#출력-포맷)
- [실전 명령어](#실전-명령어)
  - [한국어 자막 생성](#한국어-자막-생성)
  - [한→영 번역 자막](#한영-번역-자막)
  - [전체 포맷 동시 출력](#전체-포맷-동시-출력)
  - [출력 디렉토리 지정](#출력-디렉토리-지정)
- [자막 → 번인 파이프라인](#자막-번인-파이프라인)
  - [Step 1: 자막 생성](#step-1-자막-생성)
  - [Step 2: ffmpeg 번인](#step-2-ffmpeg-번인)
  - [force_style 주요 옵션](#force_style-주요-옵션)
- [mlx-whisper (Apple Silicon 최적화)](#mlx-whisper-apple-silicon-최적화)
  - [설치](#설치)
  - [사용 (Python)](#사용-python)
- [품질 팁](#품질-팁)

## 모델 비교 (Apple Silicon 기준)

| 모델 | 파라미터 | 속도 | 정확도 | 용도 |
|------|---------|------|--------|------|
| tiny | 39M | 27x | 낮음 | 빠른 테스트 |
| base | 74M | 20x | 보통 | 간단한 영어 |
| small | 244M | 8x | 양호 | 기본값 |
| medium | 769M | 4x | 높음 | Apple Silicon 균형 |
| large-v3 | 1.5B | 1.5x | 최고 | 품질 우선 |
| large-v3-turbo | ~800M | ~10x | large-v2급 | **한국어 권장** |

> **한국어**: large-v3-turbo 권장 (small 이하는 한국어 오류 빈도 높음)

## 출력 포맷

| 포맷 | 설명 | 주요 용도 |
|------|------|-----------|
| srt | SubRip 자막 | 유튜브/NLE 범용, ffmpeg 번인 |
| vtt | WebVTT | 웹(HTML5 track) |
| json | JSON | 단어별 타임스탬프, 프로그래밍 |
| txt | 평문 텍스트 | 글/요약/RAG |

## 실전 명령어

### 한국어 자막 생성
```bash
whisper input.mp4 \
  --language ko \
  --model large-v3-turbo \
  --output_format srt
```

### 한→영 번역 자막
```bash
whisper input.mp4 \
  --language ko \
  --task translate \
  --model large-v3-turbo \
  --output_format srt
```

### 전체 포맷 동시 출력
```bash
whisper input.mp4 \
  --language ko \
  --model turbo \
  --output_format all
```

### 출력 디렉토리 지정
```bash
whisper input.mp4 \
  --language ko \
  --model large-v3-turbo \
  --output_format srt \
  --output_dir ~/workspace/content/video/projects/20260408_프로젝트명/06_subtitles/
```

## 자막 → 번인 파이프라인

### Step 1: 자막 생성
```bash
whisper input.mp4 --language ko --model large-v3-turbo --output_format srt
```

### Step 2: ffmpeg 번인
```bash
ffmpeg -i input.mp4 \
  -vf "subtitles=input.srt:force_style='FontSize=24,PrimaryColour=&HFFFFFF,BorderStyle=4,Outline=2'" \
  -c:v libx264 \
  -crf 20 \
  -c:a copy \
  output.mp4
```

### force_style 주요 옵션
| 파라미터 | 설명 | 예시 |
|---------|------|------|
| FontSize | 글꼴 크기 | FontSize=24 |
| PrimaryColour | 글자 색 (BGR+Alpha) | &HFFFFFF (흰색) |
| BorderStyle | 테두리 스타일 | 4=박스, 1=외곽선 |
| Outline | 외곽선 두께 | Outline=2 |
| Bold | 굵게 | Bold=1 |
| Alignment | 위치 | 2=하단 중앙 |

## mlx-whisper (Apple Silicon 최적화)

### 설치
```bash
pip install mlx-whisper
```

### 사용 (Python)
```python
import mlx_whisper

# 한국어 자막
result = mlx_whisper.transcribe(
    "input.mp4",
    language="ko",
    path_or_hf_repo="mlx-community/whisper-large-v3-turbo"
)

# 결과 접근
print(result["text"])          # 전체 텍스트
print(result["segments"])      # 타임스탬프별 세그먼트
```

## 품질 팁
- 배경 음악이 있는 영상: `--condition_on_previous_text False` 추가
- 긴 영상 (1시간+): 세그먼트별 분할 처리 권장
- 녹음 품질 낮을 때: WAV 48kHz로 전처리 후 whisper 입력
