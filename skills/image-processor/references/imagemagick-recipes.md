# ImageMagick 레시피 모음


## Contents

- [썸네일 생성](#썸네일-생성)
  - [유튜브 썸네일 (1280x720 + 텍스트)](#유튜브-썸네일-1280x720-텍스트)
  - [인스타 정사각형 (1080x1080)](#인스타-정사각형-1080x1080)
  - [쇼츠 커버 (1080x1920)](#쇼츠-커버-1080x1920)
- [배치 처리](#배치-처리)
  - [배치 리사이즈 (mogrify)](#배치-리사이즈-mogrify)
- [워터마크](#워터마크)
  - [로고 워터마크 (우하단, 50% 불투명도)](#로고-워터마크-우하단-50-불투명도)
- [텍스트 + 그라데이션 오버레이](#텍스트-그라데이션-오버레이)
  - [그라데이션 오버레이 + 텍스트](#그라데이션-오버레이-텍스트)
- [포맷 변환](#포맷-변환)
  - [JPEG → WebP (손실)](#jpeg-webp-손실)
  - [PNG → WebP (무손실)](#png-webp-무손실)
  - [배치 WebP 변환](#배치-webp-변환)
- [유용한 옵션 메모](#유용한-옵션-메모)

검증된 magick 명령어. 모두 ImageMagick v7 기준 (`magick` 명령어 사용).

---

## 썸네일 생성

### 유튜브 썸네일 (1280x720 + 텍스트)
```bash
magick background.jpg \
  -resize 1280x720^ -gravity center -extent 1280x720 \
  -font NanumGothic-Bold -pointsize 80 \
  -fill white -stroke black -strokewidth 3 \
  -gravity South -annotate +0+60 "제목" \
  thumbnail.jpg
```

### 인스타 정사각형 (1080x1080)
```bash
magick input.jpg \
  -resize 1080x1080^ -gravity center -extent 1080x1080 \
  instagram.jpg
```

### 쇼츠 커버 (1080x1920)
```bash
magick input.jpg \
  -resize 1080x1920^ -gravity center -extent 1080x1920 \
  shorts_cover.jpg
```

---

## 배치 처리

### 배치 리사이즈 (mogrify)
```bash
# ./resized/ 폴더에 1280x720으로 저장
magick mogrify \
  -resize 1280x720^ -gravity center -extent 1280x720 \
  -path ./resized/ \
  *.jpg
```

---

## 워터마크

### 로고 워터마크 (우하단, 50% 불투명도)
```bash
magick background.jpg \
  \( logo.png -resize 200x200 -alpha set -channel Alpha -evaluate multiply 0.5 +channel \) \
  -gravity SouthEast -geometry +20+20 -composite \
  output.jpg
```

---

## 텍스트 + 그라데이션 오버레이

### 그라데이션 오버레이 + 텍스트
```bash
magick background.jpg \
  -resize 1280x720^ -gravity center -extent 1280x720 \
  \( -size 1280x200 gradient:"#00000088-#00000000" \) \
  -gravity South -composite \
  -font NanumGothic-Bold -pointsize 60 \
  -fill white -gravity South -annotate +0+40 "텍스트" \
  output.jpg
```

---

## 포맷 변환

### JPEG → WebP (손실)
```bash
magick input.jpg -quality 80 output.webp
```

### PNG → WebP (무손실)
```bash
magick input.png -define webp:lossless=true output.webp
```

### 배치 WebP 변환
```bash
# ./webp/ 폴더에 저장
magick mogrify -format webp -quality 80 -path ./webp/ *.jpg
```

---

## 유용한 옵션 메모

| 옵션 | 설명 |
|------|------|
| `-resize 1280x720^` | 비율 유지 + 크기 이상으로 확대 (crop 전용) |
| `-gravity center -extent 1280x720` | 중앙 기준 크롭하여 정확한 크기 맞춤 |
| `-quality 85` | JPEG/WebP 품질 (0-100) |
| `-annotate +0+60 "텍스트"` | gravity 기준 x+0 y+60 위치에 텍스트 |
| `-strokewidth 3` | 텍스트 외곽선 두께 |
| `-evaluate multiply 0.5` | 알파 채널 50% 불투명도 |
