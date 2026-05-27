# ffmpeg 레시피 모음


## Contents

- [1. YouTube 1080p 업로드 최적화](#1-youtube-1080p-업로드-최적화)
- [2. 쇼츠 크롭 (16:9 → 9:16)](#2-쇼츠-크롭-169-916)
- [3. 자막 번인 (SRT 파일 → 영상 직접 렌더링)](#3-자막-번인-srt-파일-영상-직접-렌더링)
- [4. GIF 추출 (팔레트 기반 고품질)](#4-gif-추출-팔레트-기반-고품질)
- [5. 베스트 프레임 추출](#5-베스트-프레임-추출)
- [6. 프록시 생성 (편집용 경량본)](#6-프록시-생성-편집용-경량본)
- [7. 오디오 추출](#7-오디오-추출)
- [8. 오디오 교체](#8-오디오-교체)
- [9. LUT 색보정 적용](#9-lut-색보정-적용)
- [10. 슬로모션 (0.5x 속도)](#10-슬로모션-05x-속도)
- [공통 옵션 참고](#공통-옵션-참고)

> 모든 명령어는 ffmpeg CLI 기준. MCP execute-ffmpeg 도구 사용 시 동일 명령어 전달.
> 원본 파일은 절대 덮어쓰지 않는다 — 출력 파일은 항상 별도 경로 지정.

---

## 1. YouTube 1080p 업로드 최적화

```bash
ffmpeg -i input.mp4 \
  -c:v libx264 -preset slow -crf 18 \
  -vf "scale=1920:1080" -r 30 -pix_fmt yuv420p \
  -c:a aac -b:a 192k -ar 48000 \
  -movflags +faststart \
  output.mp4
```

- `-preset slow`: 압축 효율 최대화 (시간 증가)
- `-crf 18`: 고품질 (낮을수록 고화질, 파일 크기 증가)
- `-movflags +faststart`: 웹 스트리밍 시 빠른 재생 시작
- `-pix_fmt yuv420p`: YouTube 호환 픽셀 포맷

---

## 2. 쇼츠 크롭 (16:9 → 9:16)

```bash
ffmpeg -i input.mp4 \
  -vf "crop=ih*9/16:ih:(iw-ow)/2:0,scale=1080:1920" \
  -c:v libx264 -crf 18 \
  output_shorts.mp4
```

- `crop=ih*9/16:ih`: 높이 기준으로 9:16 비율 너비 계산
- `(iw-ow)/2:0`: 가로 중앙 크롭
- `scale=1080:1920`: 쇼츠 표준 해상도

---

## 3. 자막 번인 (SRT 파일 → 영상 직접 렌더링)

```bash
ffmpeg -i input.mp4 \
  -vf "subtitles=subs.srt:force_style='FontName=NanumGothic,FontSize=24,PrimaryColour=&HFFFFFF,OutlineColour=&H000000,Outline=2'" \
  -c:v libx264 -crf 22 -c:a copy \
  output.mp4
```

- `FontName=NanumGothic`: 한글 폰트 지정 (시스템에 설치 필요)
- `PrimaryColour=&HFFFFFF`: 흰색 자막
- `OutlineColour=&H000000`: 검정 테두리
- `Outline=2`: 테두리 두께
- `-c:a copy`: 오디오 재인코딩 없이 복사 (빠름)

---

## 4. GIF 추출 (팔레트 기반 고품질)

```bash
# Step 1: 팔레트 생성
ffmpeg -ss 10 -t 5 -i input.mp4 \
  -vf "fps=15,scale=640:-1:flags=lanczos,palettegen" \
  palette.png

# Step 2: 팔레트 적용하여 GIF 생성
ffmpeg -ss 10 -t 5 -i input.mp4 -i palette.png \
  -vf "fps=15,scale=640:-1:flags=lanczos,paletteuse" \
  output.gif
```

- `-ss 10`: 10초 지점부터
- `-t 5`: 5초 구간
- `flags=lanczos`: 고품질 다운스케일
- 팔레트 2단계 방식으로 색상 품질 대폭 향상

---

## 5. 베스트 프레임 추출

```bash
ffmpeg -i input.mp4 \
  -vf "select=gt(scene\,0.4),scale=1280:720" \
  -frames:v 1 -vsync vfr \
  best.jpg
```

- `select=gt(scene\,0.4)`: 씬 변화 점수 0.4 초과 프레임만 선택
- `-frames:v 1`: 첫 번째 매칭 프레임만 추출
- 썸네일, 하이라이트 캡처에 활용

---

## 6. 프록시 생성 (편집용 경량본)

```bash
ffmpeg -i input.mp4 \
  -vf "scale=960:540" \
  -c:v libx264 -crf 28 -preset ultrafast \
  -c:a aac -b:a 128k \
  proxy.mp4
```

- `scale=960:540`: 절반 해상도 (QHD → HD)
- `-crf 28`: 낮은 화질 (용량 최소화)
- `-preset ultrafast`: 인코딩 속도 최우선
- 편집 타임라인용, 최종 출력은 원본으로 재인코딩

---

## 7. 오디오 추출

```bash
ffmpeg -i input.mp4 \
  -vn \
  -c:a aac -b:a 320k \
  output.aac
```

- `-vn`: 비디오 트랙 제외
- `-b:a 320k`: 고품질 오디오 비트레이트
- mp3 출력 시: `-c:a libmp3lame -q:a 0`

---

## 8. 오디오 교체

```bash
ffmpeg -i input.mp4 -i new_audio.mp3 \
  -map 0:v -map 1:a \
  -c:v copy -c:a aac \
  -shortest \
  output.mp4
```

- `-map 0:v`: 원본 영상 트랙
- `-map 1:a`: 새 오디오 트랙
- `-c:v copy`: 영상 재인코딩 없이 복사 (빠름, 무손실)
- `-shortest`: 짧은 스트림 기준으로 길이 맞춤

---

## 9. LUT 색보정 적용

```bash
ffmpeg -i input.mp4 \
  -vf "lut3d=film_look.cube" \
  -c:v libx264 -crf 18 -c:a copy \
  output.mp4
```

- `.cube` 파일: DaVinci Resolve, Premiere 등에서 export한 LUT
- 영화 느낌, 빈티지 등 다양한 색감 적용 가능

---

## 10. 슬로모션 (0.5x 속도)

```bash
ffmpeg -i input.mp4 \
  -vf "setpts=2.0*PTS" \
  -af "atempo=0.5" \
  output_slow.mp4
```

- `setpts=2.0*PTS`: 영상 속도 0.5x (2배 느리게)
- `atempo=0.5`: 오디오 속도 0.5x
- 주의: `atempo` 범위는 0.5~2.0 — 그 이상은 체이닝 필요
  - 예) 0.25x: `-af "atempo=0.5,atempo=0.5"`

---

## 공통 옵션 참고

| 옵션 | 설명 |
|------|------|
| `-ss HH:MM:SS` | 시작 시간 (input 앞에 쓰면 빠름) |
| `-t 초` | 처리 구간 길이 |
| `-to HH:MM:SS` | 종료 시간 |
| `-an` | 오디오 제거 |
| `-vn` | 비디오 제거 |
| `-y` | 출력 파일 덮어쓰기 확인 없이 진행 |
| `-threads 0` | CPU 코어 자동 할당 |
