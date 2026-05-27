# Coverage Rules

이 문서는 `빠짐없는 조사`를 discovery-first 방식으로 강제하는 규칙이다. 카테고리만 잡고 끝나는 것을 막기 위해 사용한다.

## 활성화 트리거

다음 표현이 보이면 broad 또는 exhaustive discovery를 켠다.

- 최대한 많이
- 빠짐없이
- 모든 방식
- 종류별로
- 사례까지
- 한국에서도 가능한
- 숨은 방법
- 로컬 프로그램
- 비주류 / 대안 / 잘 안 알려진

## Discovery Axes

기본 discovery 뒤에 아래 축을 강제로 돈다.

- reward axis: 현금 / 제품 / 쿠폰 / 포인트 / 수수료 / 리드 / 원고료 / 혼합
- recruitment axis: 브랜드 직접 / 대행사 / 플랫폼 모집 / 커뮤니티 / 네트워크
- action axis: 리뷰 작성 / 체험 후기 / 기자단형 배포 / 공동구매 연결 / 리드 전달 / 서비스 연결
- language axis: 한국어 / 영어 / 업계 용어 / 커뮤니티 표현 / 로컬 속어
- policy axis: 광고 표기 / 플랫폼 허용 / SEO 리스크 / 운영 리스크
- locality axis: 한국 / 미국 / 글로벌 / 특정 국가 / 플랫폼 특화

## 검색 규칙

하나의 후보군에 대해 아래 조합을 만든다.

- `seed term x reward axis`
- `seed term x recruitment axis`
- `seed term x action axis`
- `seed term x locality axis`
- `seed term x 실제 사례`
- `seed term x 대안/비주류/숨은 표현`

한국어와 영어 쿼리를 둘 다 만든다.

## Candidate Mining 규칙

먼저 후보를 찾고 나중에 분류한다.

- `affiliate` 같은 정식 프로그램형만 보지 않는다
- `체험단`, `기자단`, `원고료 포스팅`, `서포터즈`, `협찬 포스팅` 같은 로컬 표현을 그대로 후보로 저장한다
- 근거가 약해도 반복 등장하면 `unresolved_candidates`로 남긴다
- suppression은 마지막까지 금지하고, 정말 제거하면 이유를 남긴다

## Local Language Mining 예시

블로그 수익화처럼 한국 로컬 시장 표현이 중요한 주제에서는 아래를 seed로 쓴다.

- 블로그 체험단
- 블로그 기자단
- 원고료 포스팅
- 협찬 포스팅
- 리뷰단 모집
- 서포터즈 모집
- paid review blog korea
- sponsored post blogger korea

## 로컬 프로그램 발굴 규칙

후보가 정식 프로그램형이면 실제 프로그램까지 내려간다.

예:

- `affiliate` -> `쿠팡 파트너스`, `Amazon Associates`
- `광고 수익` -> 구체 네트워크 / 채널
- `서비스 판매` -> 진단, 템플릿, 대행, 자문
- `캠페인형 수익화` -> 체험단, 기자단, 서포터즈, 원고료 포스팅

## Coverage Ledger 체크리스트

- 주요 discovery axis별로 최소 1개 이상의 후보가 있는가
- 한국/글로벌 차이를 분리했는가
- 플랫폼 제약이 있으면 반영했는가
- well-known 모델 외에 local/emergent 모델이 있는가
- unresolved candidate를 숨기지 않았는가
- suppressed candidate가 있으면 이유를 남겼는가

## 실패 신호

아래 상태면 discovery 품질이 부족한 것이다.

- 잘 알려진 프로그램형만 있고 로컬 표현 후보가 없다
- reward/recruitment/action axis 중 둘 이상이 비어 있다
- unresolved candidate가 0인데도 조사 범위가 넓다
- suppression reason 없이 후보가 사라진다
- `놓치기 쉬운 관점`은 있는데 실제 emergent/local 후보가 없다
