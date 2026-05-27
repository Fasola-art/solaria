# 워크플로우 카탈로그

## 업무 워크플로우 (WF-1~5)

### WF-1: 아침 브리핑
- 트리거: /schedule 매일 9AM 또는 /workflow briefing
- 패턴: Fan-Out & Merge
- 소스: Gmail, Calendar, GitHub, Telegram (미연결 건너뜀)
- 출력: ~/workspace/briefings/YYYY-MM-DD.md + 텔레그램

### WF-2: 리서치 + 보고
- 트리거: /workflow research [주제] 또는 /schedule 주간
- 패턴: Sequential
- 출력: ~/workspace/reports/YYYY-MM-DD-[주제].md + 텔레그램

### WF-3: 콘텐츠 제작
- 트리거: /workflow content [유형] [주제]
- 유형: lecture, book, blog, sns
- 패턴: Hybrid (리서치 순차 → 섹션 병렬 → 검토 순차)
- 출력: ~/workspace/content/[유형]/YYYY-MM-DD-[주제]/ + 텔레그램

### WF-4: 코딩/프로젝트
- 트리거: /workflow code [설명]
- 패턴: Sequential + Conditional
- 출력: ~/workspace/projects/[이름]/ + Git + GitHub PR + 텔레그램

### WF-5: 조건부 알림
- 트리거: /schedule 매시간
- 패턴: Fan-Out + Conditional
- 출력: 변동 있을 때만 텔레그램

## 수익 워크플로우 (WF-6~10)

### WF-6: 콘텐츠 자동 발행
- 트리거: /schedule 주 3회 또는 /workflow revenue-content
- 패턴: Sequential
- 단계: 트렌드 선정 → 블로그 초안 → reviewer 검토 → 포맷 변환 (블로그/뉴스레터/SNS)
- 출력: ~/workspace/revenue/content/ + 텔레그램 (사용자 확인 후 발행)

### WF-7: 강의 제작
- 트리거: /workflow revenue-course [주제]
- 패턴: Sequential
- 단계: 시장 조사 → 커리큘럼 설계 → 모듈별 스크립트 → 실습/퀴즈 → 판매 카피
- 출력: ~/workspace/revenue/courses/[주제]/

### WF-8: Micro SaaS 개발
- 트리거: /workflow revenue-saas [아이디어]
- 패턴: Sequential
- 단계: 아이디어 검증 → PRD → 아키텍처 → 코드 → 검증 → 배포 가이드 → 랜딩 페이지
- 출력: ~/workspace/revenue/products/[제품명]/

### WF-9: 프리랜서 효율화
- 트리거: /workflow revenue-freelance [설명]
- 패턴: Sequential
- 단계: 요구사항 분석 → 견적서 → 코드 → 테스트 → 납품 문서
- 출력: ~/workspace/revenue/freelance/YYYY-MM-[클라이언트]/

### WF-10: 수익 기회 탐색
- 트리거: /schedule 주 1회 또는 /workflow revenue-scout
- 패턴: Fan-Out & Merge
- 단계: SaaS/강의/프리랜서/콘텐츠 4개 분야 병렬 리서치 → ROI 평가 → Top 3
- 출력: ~/workspace/revenue/scout/YYYY-MM-DD.md + 텔레그램
