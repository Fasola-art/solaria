---
name: video-editor
description: Edit and post-process video with conversion, trimming, cropping, encoding, subtitle burn-in, speed changes, GIF extraction, proxy creation, audio replacement, LUT application, and frame extraction.
---

# Skill: video-editor

## 메타데이터
- **스킬 이름**: video-editor
- **버전**: 1.0.0
- **생성일**: 2026-04-08
- **역할**: 기존 영상의 변환/편집/트리밍/크롭/인코딩/자막번인/속도변경 등 영상 후처리 전담

## 트리거 키워드
영상, 비디오, 변환, 트리밍, 인코딩, 크롭, 쇼츠, GIF, 프록시, 슬로모션

## 책임 범위
- 영상 포맷 변환 (mp4, mov, webm, mkv 등)
- 해상도/비율 변환 (16:9 → 9:16 쇼츠 크롭 포함)
- 트리밍 / 구간 추출
- 인코딩 최적화 (YouTube, 쇼츠, 아카이브 등 목적별)
- 자막 번인 (SRT → 영상 직접 렌더링)
- 속도 변경 (슬로모션, 타임랩스)
- GIF 추출 (팔레트 기반 고품질)
- 프록시 파일 생성 (편집용 경량본)
- 오디오 추출 / 교체
- LUT(색보정 프리셋) 적용
- 베스트 프레임 추출

## MCP 연동
- **서버**: mcp-media-processor
- **도구**:
  - `execute-ffmpeg`: ffmpeg 명령어 직접 실행
  - `convert-video`: 포맷/코덱 변환
  - `compress-video`: 용량 최적화 압축
  - `trim-video`: 구간 트리밍

> MCP 서버가 없는 환경에서는 ffmpeg CLI 직접 실행으로 대체한다.

## 출력 디렉토리 규칙
```
~/workspace/content/video/projects/YYYYMMDD_프로젝트명/05_exports/
```
- 날짜는 작업 시작일 기준 (예: 20260408)
- 프로젝트명은 영어 또는 한글 (공백 없이 언더스코어 사용)
- 출력 파일명 예시: `20260408_shorts_final.mp4`

## 실행 흐름
1. 입력 영상 확인 (경로, 포맷, 해상도, 길이)
2. 작업 유형 판단 (트리거 키워드 기반)
3. 출력 디렉토리 생성 (없으면 mkdir -p)
4. MCP 도구 또는 ffmpeg CLI로 작업 실행
5. 출력 파일 검증 (용량, 재생 가능 여부)
6. 결과 경로 보고

## 참조 문서
- `references/ffmpeg-recipes.md`: 용도별 ffmpeg 명령어 레시피
- `references/codec-guide.md`: 코덱/CRF/비트레이트 선택 가이드

## 제약 사항
- 영상 생성(AI 생성, 촬영 스크립트 등)은 이 스킬의 범위가 아님
- 원본 파일 덮어쓰기 금지 — 항상 별도 출력 파일 생성
- 작업 전 원본 파일 존재 여부 확인 필수
