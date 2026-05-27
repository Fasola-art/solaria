# 온톨로지 스키마 가이드

## 엔티티 타입

| 타입 | 용도 | 필수 필드 | 예시 |
|------|------|----------|------|
| Person | 사람/조직 | name, role | 사용자, 클라이언트 |
| Project | 프로젝트 | name, status | 커머스앱 (active) |
| Task | 작업 | title, status | 결제 API 연동 (in_progress) |
| Tool | 도구/기술 | name, category | Node.js (language), Firebase (service) |
| Pattern | 패턴 | name, type, description | Firebase API 구조 (architecture) |
| Document | 문서 | title, type | API 가이드 (api_doc) |
| Workflow | 워크플로우 | name, steps | 아침 브리핑 |
| Product | 제품 | name, type, status | 회의록 봇 (saas, launched) |
| Revenue | 수익 | source, amount, period | 강의 수익 (course, monthly) |
| ErrorPattern | 에러 패턴 | name, error_type, solution | tsc 타입 에러 (type) |
| Event | 일정 | title, datetime | 클라이언트 미팅 |

## 관계 타입

| 관계 | from → to | 예시 |
|------|----------|------|
| uses | Person/Project → Tool/Pattern | 사용자 → uses → Node.js |
| owns | Person → Project/Task | 사용자 → owns → 커머스앱 |
| depends_on | Project/Task → Tool/Project/Task | 커머스앱 → depends_on → Firebase |
| part_of | Task/Tool → Project | 결제 API → part_of → 커머스앱 |
| documents | Document → any | API 가이드 → documents → Firebase |
| evolved_from | Pattern → Pattern | 확정 패턴 → evolved_from → instinct |
| generates | Product → Revenue | 회의록 봇 → generates → 구독 수익 |
| built_with | Product → Tool/Pattern | 회의록 봇 → built_with → Node.js |
| resolves | Pattern → ErrorPattern | null 체크 패턴 → resolves → TypeError |
