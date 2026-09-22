# 할 일과 진행 상태

마지막 정리: 2026-09-21

작업 모델 원칙: Luna Light를 기본으로 사용하고, 각 단계의 실행 검증을 완료한다. 설계·보안·접근성·권한·대규모 변경·최종 출고 검토처럼 판단 강도가 필요한 시점에는 더 강한 모델 검토가 필요하다고 사용자에게 알린다. 검증 실패 상태는 OK로 기록하지 않는다. 자세한 결정은 [기술 선택 기록](decisions.md)을 참고한다.

현재 목표: 전체 컴포넌트 전환보다 v0 CMS의 공지 작성→미리보기→게시→공개 조회 세로 흐름을 먼저 구현한다. KRDS 공식 원본은 `reference/krds-uiux`에서 대조하고, 컴포넌트 스타일은 중앙 CSS와 CSS 변수로 관리한다.

## 완료한 확인

- [x] 전체 사업 목적과 세 제품의 역할 문서화 → [사업 목적](vision.md)
- [x] Vue 집중을 검토하는 배경 기록 → [기술 선택 기록](decisions.md)
- [x] React·Vue 구현과 테스트 파일 존재 확인
  - React 기본 구현 파일 78개, 컴포넌트 테스트 파일 41개(블록 포함)
  - Vue 구현 파일 125개, 컴포넌트 테스트 파일 36개
  - Vue는 하위 구성 요소가 별도 파일이므로 두 수치를 기능 개수로 직접 비교하지 않는다.
- [x] React 필수 파일의 Git 삭제 상태 확인
  - `packages/react/package.json`, `src/variables.css`, `tailwind.preset.ts`, `README.md`, `LICENSE`
  - 삭제 이유는 미확인. 복원하지 않음.
- [x] 기존 테스트 실행 시도 결과 기록
  - React·Vue 테스트가 출력 없이 지연돼 중단함. 통과·실패 결과는 미확인.

## 첫 납품 제품 · 현재 우선 작업

- [x] 첫 대상 확정: 소규모 공공기관 대표 홈페이지(사용자 선택)
- [x] [첫 납품 범위와 합격 기준](first-delivery.md) 초안 작성 — 상세 범위는 제안이며 검증 전
- [ ] 첫 제품 기능 F01~F13과 내부 출고 기준 G01~G07 검토·확정
- [ ] 적용 KRDS 판본·웹접근성 기준 원문과 실제 점검 항목 매핑
- [x] [공개·관리자 사이트맵과 권한 구조](sitemap-and-permissions.md) 초안 작성 — 설계이며 구현·검증 전
- [x] [공지 목록·작성·상세 와이어프레임과 필드·상태](notice-wireframes.md) 초안 작성
- [ ] 역할·리비전·파일 공개 규칙을 API·데이터 모델에 반영
- [ ] A01~A02에 필요한 Vue 컴포넌트를 우선 검증
- [ ] A01~A02를 전자정부 표준프레임워크 v5 백엔드·DB와 연결

## 백엔드 · 확정 기술과 적용 준비

- [x] 백엔드 전자정부 표준프레임워크 v5 사용 확정 → [기술 선택 기록](decisions.md)
- [ ] 공식 저장소의 v5 릴리스·태그와 JDK·Spring Boot 호환 버전 확인
- [ ] 기존 백엔드 소스와 빌드 설정 유무 점검, 재사용·보완 범위 정리
- [ ] 사용할 공통컴포넌트와 CMS 전용 기능 구분
- [ ] 프론트 연동용 인증·권한·게시판·파일 API 계약 정리
- [ ] v5 기반 최소 백엔드 빌드·실행·DB 연결 검증
- [x] 기존 백엔드 소스·빌드 설정·공개 페이지 조회 위험 1차 점검 → [백엔드 초기 점검](backend-audit.md)
- [ ] 백엔드 인증 주체·초안/게시/삭제 상태·권한 계약을 더 강한 모델로 독립 검토

## 다음 작업 · 기존 컴포넌트 점검

- [ ] React 파일 삭제가 의도된 것인지 원인과 변경 이력 확인
- [x] iCloud 의존성의 dataless 상태 확인, 임시 로컬 환경에서 테스트 실행
- [x] 임시 로컬 환경 Vue 빌드·타입 검사·전체 309개 테스트 통과 → [1차 점검](vue-audit.md)
- [x] 후속 Checkbox·패키지 단독 실행성 검증: 전체 310개 테스트 통과, 타입 검사·빌드 성공 → [1차 점검](vue-audit.md)
- [ ] 로컬 이전 후 원래 pnpm 잠금 버전으로 재검증
- [x] [Vue 구현·export·개별 테스트 파일 목록](vue-inventory.md) 작성
- [ ] Vue 문서·CLI 대응과 실제 화면 검증
- [x] Vue CLI 빌드 및 임시 프로젝트 `init --yes` 생성 검증 → `hanui.json`, Tailwind v3 preset, `variables.css`, `lib/utils.ts` 생성 확인; 자동 의존성 설치 완료 여부는 환경 서비스 오류로 미확인
- [x] Button·Input·Select·Checkbox·Modal·Table부터 [체크리스트](component-checklist.md)로 1차 점검 → [Vue 점검 결과](vue-audit.md)
- [x] Checkbox의 native form 참여·속성 전달 후속 검증 및 패키지 단독 테스트/빌드 재검증 → 310개 테스트 통과
- [x] FormField·Input·Select의 실제 자동 연결과 상태/오류 메시지 통합 검증 → 311개 테스트 통과
- [x] Vue 패키지에 기본 KRDS CSS 변수와 `styles.css` 산출 경로 추가 → 전체 CLI 토큰과의 통합은 미완료
- [x] CLI `variables.css`·Tailwind 프리셋과 Vue 패키지 토큰의 역할 차이 기록 → 패키지는 baseline CSS, CLI는 전체 Tailwind 통합 담당
- [ ] KRDS 공식 제공 킷과 기존 HANUI의 차이·보완 가치 확인
- [x] KRDS 공식 저장소 구조·HTML/CSS/JS·토큰·라이선스 안내 1차 확인 → [KRDS 소스 점검](krds-source-audit.md)
- [x] KRDS Button 기준표 작성 → [Button 기준표](krds-button-baseline.md)
- [x] Button 중앙 CSS/API 전환 및 기존 API 호환 별칭 유지
- [x] Input·FormField·Select 중앙 CSS/API 전환 및 기존 접근성 테스트 통과
- [x] Vue 패키지 전체 검증: 37개 테스트 파일·312개 테스트, 타입 검사, 빌드 통과
- [x] Vue Storybook에 Button·Input·FormField·Select의 상태별 검증 화면 추가
- [ ] 이후 UI 컴포넌트 변경 시 Storybook 스토리와 화면 검증을 함께 갱신
- [ ] Button·Input·FormField·Select의 실제 브라우저 화면·고대비·스크린리더 독립 검토

## 방향 확인 후 진행할 작업

- [ ] Vue 집중 범위와 React 유지 범위 확정
- [ ] Vue CMS 구성·배포 방식 결정
- [ ] 게시판 목록 → 상세 → 등록·수정 흐름의 작은 검증 구현
- [ ] 검증 결과를 기준으로 CMS 이식 범위와 일정 정리
- [ ] Checker의 실제 검사 항목을 KRDS·접근성·수동 확인 항목으로 정리

위 항목은 작업 목록이며 일괄 실행이나 프레임워크 전환 완료를 뜻하지 않는다. 다음 작업의 완료 근거와 새로 발견한 문제를 이 문서에 이어서 기록한다.
