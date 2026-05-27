---
name: image-processor
description: Process images with thumbnails, resizing, text overlays, watermarks, batch conversion, and format changes. Use for requests involving thumbnails, images, resizing, posters, watermarks, batch image processing, WebP, or PNG.
---

# image-processor 스킬

## 메타데이터
- **스킬 이름**: image-processor
- **버전**: 1.0.0
- **생성일**: 2026-04-08
- **역할**: 썸네일 생성, 이미지 리사이즈, 텍스트 오버레이, 워터마크, 배치 처리, 포맷 변환

## 트리거 키워드
썸네일, 이미지, 리사이즈, 포스터, 워터마크, 배치, WebP, PNG

## 기능 범위
- 유튜브/인스타/쇼츠 썸네일 생성
- 이미지 리사이즈 (단일 / 배치)
- 텍스트 오버레이 + 그라데이션
- 로고 워터마크 합성
- 포맷 변환 (JPEG, PNG, WebP, AVIF)
- 배치 처리 (mogrify)

## MCP 연동
- **서버**: mcp-media-processor
- **도구**:
  - `resize-image`: 단일 이미지 리사이즈
  - `convert-image`: 포맷 변환
  - `add-watermark`: 워터마크 합성
  - `apply-effect`: 효과 적용 (그라데이션, 블러 등)

## CLI 직접 실행
- 명령어: `magick` (ImageMagick v7)
- MCP 도구로 처리 불가한 복잡한 합성은 magick 명령어로 직접 실행
- 레시피 참조: [imagemagick-recipes.md](references/imagemagick-recipes.md)

## 출력 디렉토리 규칙
- 일반 이미지: `~/workspace/content/images/projects/<프로젝트명>/`
- 영상 프로젝트 그래픽: `<video-project>/03_graphics/`
- 배치 출력: 원본 위치의 `./resized/` 또는 `./webp/` 하위 폴더

## 실행 흐름
1. 입력 파악: 원본 파일, 목표 크기/포맷, 텍스트 여부
2. 도구 선택: MCP 가능 → MCP 우선 / 복합 합성 → magick CLI
3. 출력 경로 확인 및 디렉토리 생성 (`mkdir -p`)
4. 명령 실행
5. 결과 파일 경로 반환

## 참조
- [imagemagick-recipes.md](references/imagemagick-recipes.md) — 검증된 magick 명령어 모음
- [format-guide.md](references/format-guide.md) — 포맷별 품질 설정 + 소셜 미디어 크기 기준
