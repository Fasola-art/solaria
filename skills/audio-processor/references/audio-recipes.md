# 오디오 처리 레시피 (ffmpeg)


## Contents

- [오디오 추출](#오디오-추출)
  - [AAC 추출 (고품질, 작은 파일)](#aac-추출-고품질-작은-파일)
  - [WAV 추출 (무손실, whisper 전처리용)](#wav-추출-무손실-whisper-전처리용)
  - [MP3 추출](#mp3-추출)
- [오디오 교체/합성](#오디오-교체합성)
  - [오디오 트랙 교체](#오디오-트랙-교체)
  - [두 오디오 믹싱](#두-오디오-믹싱)
- [볼륨/음질 조정](#볼륨음질-조정)
  - [볼륨 조절 (1.5배 증폭)](#볼륨-조절-15배-증폭)
  - [볼륨 자동 정규화 (loudnorm)](#볼륨-자동-정규화-loudnorm)
  - [노이즈 감소 (afftdn 필터)](#노이즈-감소-afftdn-필터)
  - [고음역 강조 (나레이션 선명도 향상)](#고음역-강조-나레이션-선명도-향상)
- [포맷 변환](#포맷-변환)
  - [MP4 → WebM](#mp4-webm)
  - [오디오 샘플레이트 변환](#오디오-샘플레이트-변환)
  - [스테레오 → 모노](#스테레오-모노)
- [자막 관련](#자막-관련)
  - [자막 번인 (SRT → 영상)](#자막-번인-srt-영상)
  - [자막 파일 추출 (영상 내장 자막)](#자막-파일-추출-영상-내장-자막)
  - [자막 소프트 삽입 (스트림으로)](#자막-소프트-삽입-스트림으로)
- [영상 분석](#영상-분석)
  - [오디오 정보 확인](#오디오-정보-확인)
  - [영상 길이 확인](#영상-길이-확인)
- [배치 처리](#배치-처리)
  - [폴더 내 전체 MP4 오디오 추출](#폴더-내-전체-mp4-오디오-추출)
  - [폴더 내 전체 MP4 자막 번인](#폴더-내-전체-mp4-자막-번인)
- [자주 쓰는 CRF 값 (품질 기준)](#자주-쓰는-crf-값-품질-기준)

## 오디오 추출

### AAC 추출 (고품질, 작은 파일)
```bash
ffmpeg -i input.mp4 -vn -c:a aac -b:a 320k output.aac
```

### WAV 추출 (무손실, whisper 전처리용)
```bash
ffmpeg -i input.mp4 -vn -c:a pcm_s16le -ar 48000 output.wav
```

### MP3 추출
```bash
ffmpeg -i input.mp4 -vn -c:a libmp3lame -q:a 2 output.mp3
```

## 오디오 교체/합성

### 오디오 트랙 교체
```bash
ffmpeg -i video.mp4 -i new_audio.mp3 \
  -map 0:v \
  -map 1:a \
  -c:v copy \
  -c:a aac \
  -shortest \
  output.mp4
```

### 두 오디오 믹싱
```bash
ffmpeg -i video.mp4 -i bgm.mp3 \
  -filter_complex "[0:a][1:a]amix=inputs=2:duration=first:weights=1 0.3" \
  -c:v copy \
  output.mp4
```

## 볼륨/음질 조정

### 볼륨 조절 (1.5배 증폭)
```bash
ffmpeg -i input.mp4 -af "volume=1.5" output.mp4
```

### 볼륨 자동 정규화 (loudnorm)
```bash
ffmpeg -i input.mp4 \
  -af "loudnorm=I=-16:TP=-1.5:LRA=11" \
  output.mp4
```

### 노이즈 감소 (afftdn 필터)
```bash
ffmpeg -i input.mp4 -af "afftdn=nf=-25" output.mp4
```

### 고음역 강조 (나레이션 선명도 향상)
```bash
ffmpeg -i input.mp4 \
  -af "equalizer=f=3000:width_type=o:width=2:g=3" \
  output.mp4
```

## 포맷 변환

### MP4 → WebM
```bash
ffmpeg -i input.mp4 -c:v libvpx-vp9 -c:a libopus output.webm
```

### 오디오 샘플레이트 변환
```bash
ffmpeg -i input.mp4 -ar 44100 output.mp4
```

### 스테레오 → 모노
```bash
ffmpeg -i input.mp4 -af "pan=mono|c0=0.5*c0+0.5*c1" output.mp4
```

## 자막 관련

### 자막 번인 (SRT → 영상)
```bash
ffmpeg -i input.mp4 \
  -vf "subtitles=subtitle.srt:force_style='FontSize=24,PrimaryColour=&HFFFFFF,BorderStyle=4,Outline=2'" \
  -c:v libx264 \
  -crf 20 \
  -c:a copy \
  output.mp4
```

### 자막 파일 추출 (영상 내장 자막)
```bash
ffmpeg -i input.mkv -map 0:s:0 output.srt
```

### 자막 소프트 삽입 (스트림으로)
```bash
ffmpeg -i video.mp4 -i subtitle.srt \
  -c:v copy \
  -c:a copy \
  -c:s mov_text \
  output.mp4
```

## 영상 분석

### 오디오 정보 확인
```bash
ffprobe -v quiet -print_format json -show_streams -select_streams a input.mp4
```

### 영상 길이 확인
```bash
ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 input.mp4
```

## 배치 처리

### 폴더 내 전체 MP4 오디오 추출
```bash
for f in *.mp4; do
  ffmpeg -i "$f" -vn -c:a aac -b:a 320k "${f%.mp4}.aac"
done
```

### 폴더 내 전체 MP4 자막 번인
```bash
for f in *.mp4; do
  base="${f%.mp4}"
  if [ -f "${base}.srt" ]; then
    ffmpeg -i "$f" \
      -vf "subtitles=${base}.srt" \
      -c:v libx264 -crf 20 -c:a copy \
      "${base}_subtitled.mp4"
  fi
done
```

## 자주 쓰는 CRF 값 (품질 기준)
| CRF | 품질 | 파일 크기 |
|-----|------|-----------|
| 18 | 거의 무손실 | 매우 큼 |
| 20 | 높음 | 큼 |
| 23 | 기본값 | 중간 |
| 28 | 낮음 | 작음 |
