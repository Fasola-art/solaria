# Red/Blue Team 분석 프레임워크

플랜/전략/아이디어 검증을 위한 이중 관점 분석.

## Red Team (공격자/비판자 관점)

### 분석 항목
1. 약점 식별: 기술적/비즈니스적 취약점
2. 리스크 시나리오: 최악의 경우 3가지
3. 실패 모드: 단일 장애점(SPOF), 연쇄 실패
4. 비용 초과: 예상 대비 비용 폭발 시나리오
5. 경쟁 위협: 경쟁자가 이 플랜을 무력화하는 방법

### Red Score 산정
- Critical 이슈: -50점/건
- Warning 이슈: -10점/건
- Info 이슈: -3점/건
- Red Score = max(0, 100 - sum(감점))

## Blue Team (방어자/옹호자 관점)

### 분석 항목
1. 강점 식별: 차별화 포인트, 기술 우위
2. 기회 포착: 시장 트렌드와의 정렬
3. 성공 조건: 필수 달성 마일스톤
4. 방어 전략: Red Team 이슈 각각에 대한 완화 방안
5. 빠른 승리: 30일 내 달성 가능한 Quick Win

### Blue Score 산정
- High 가중치 항목: 0-20점
- Medium 가중치 항목: 0-15점
- Low 가중치 항목: 0-10점
- Blue Score = min(100, sum(가점))

## 최종 판정

final_score = (red_score × 0.5) + (blue_score × 0.5)

| 점수 | 판정 | 액션 |
|------|------|------|
| 70+ | Pass | 진행 |
| 40-69 | Warning | 보완 후 재검토 |
| 0-39 | Critical | 재설계 필요 |

## 출력 포맷

```
[Red/Blue 분석 결과]

Red Score: 75/100
- [R1] Critical: 단일 DB 의존으로 SPOF 존재 (-50)
- [R2] Warning: MVP 일정 타이트 (-10)

Blue Score: 82/100
- [B1] 차별화된 AI 기능 (+20)
- [B2] 시장 수요 확인됨 (+15)
- [B3] 기존 인프라 활용 가능 (+12)

Final: 78.5/100 [Pass]
```

## /simulate 스킬 연동
simulate 스킬 실행 시 4-Dimension 분석의 2번째 차원으로 Red/Blue 적용.
