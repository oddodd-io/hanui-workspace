# 할 일과 진행 상태

마지막 정리: 2026-10-01

작업 모델 원칙: Luna Light를 기본으로 사용하고, 각 단계의 실행 검증을 완료한다. 설계·보안·접근성·권한·대규모 변경·최종 출고 검토처럼 판단 강도가 필요한 시점에는 더 강한 모델 검토가 필요하다고 사용자에게 알린다. 검증 실패 상태는 OK로 기록하지 않는다. 자세한 결정은 [기술 선택 기록](decisions.md)을 참고한다.

현재 목표: v0 CMS의 공지 작성→미리보기→게시→공개 조회 세로 흐름을 구현한다. 지금은 `repos/hanui-vue-cms`에서 공개 앱(Nuxt) 화면을 조립하는 중이다(→ [작업 정리](work-summary-2026-09-30.md)).
Vue 컴포넌트(`@hanui/vue`)는 KRDS 리소스를 vendor로 그대로 쓰며, 원본 결함은 `_hanui-fixes.scss`로만 보완한다(→ [기술 선택](decisions.md) 2026-09-22·09-30).

상시 규칙: UI 컴포넌트를 바꾸면 Storybook 스토리와 브라우저 화면 확인을 함께 갱신한다.

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
  - → 2026-10-01 재확인: git 이력상 삭제된 적이 없고 현재 추적·존재한다. iCloud 복사본 작업 폴더에서만 보인 상태로 판단, 해결.
- [x] 기존 테스트 실행 시도 결과 기록
  - React·Vue 테스트가 출력 없이 지연돼 중단함. 통과·실패 결과는 미확인.

## 첫 납품 제품 · 현재 우선 작업

- [x] 첫 대상 확정: 소규모 공공기관 대표 홈페이지(사용자 선택)
- [x] [첫 납품 범위와 합격 기준](first-delivery.md) 초안 작성 — 상세 범위는 제안이며 검증 전
- [x] v1 범위와 차수 확정 → [v1 로드맵](v1-roadmap.md) (그누보드 기준, 회원 제외, 1·2·3차, 2026-10-01)
- [ ] 첫 제품 기능 F01~F13과 내부 출고 기준 G01~G07 검토·확정 — 1차 완료 기준으로 사용하기로 확정, 항목별 세부 검토는 남음
- [ ] 적용 KRDS 판본·웹접근성 기준 원문과 실제 점검 항목 매핑
- [x] [공개·관리자 사이트맵과 권한 구조](sitemap-and-permissions.md) 초안 작성 — 설계이며 구현·검증 전
- [x] [공지 목록·작성·상세 와이어프레임과 필드·상태](notice-wireframes.md) 초안 작성
- [ ] 역할·리비전·파일 공개 규칙을 API·데이터 모델에 반영
- [ ] A01~A02에 필요한 Vue 컴포넌트를 우선 검증 — 진행 중: 필요한 컴포넌트는 완성(21개, 2026-09-30). CMS 화면에 조립해 SSR·실화면으로 확인하는 단계 남음
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

## 기존 컴포넌트 점검 (2026-09-21, 재구축 전 125개 패키지 기준 — 기록용)

- [x] React 파일 삭제가 의도된 것인지 원인과 변경 이력 확인 → 삭제된 적 없음(위 '완료한 확인' 참고, 2026-10-01)
- [x] iCloud 의존성의 dataless 상태 확인, 임시 로컬 환경에서 테스트 실행
- [x] 임시 로컬 환경 Vue 빌드·타입 검사·전체 309개 테스트 통과 → [1차 점검](vue-audit.md)
- [x] 후속 Checkbox·패키지 단독 실행성 검증: 전체 310개 테스트 통과, 타입 검사·빌드 성공 → [1차 점검](vue-audit.md)
- [x] 로컬 이전 후 원래 pnpm 잠금 버전으로 재검증 → 로컬 `pnpm install` 상태에서 재구축 Vue 패키지 테스트 341개·빌드 통과(2026-09-30). `--frozen-lockfile` 단독 재설치는 하지 않음
- [x] [Vue 구현·export·개별 테스트 파일 목록](vue-inventory.md) 작성
- [x] ~~Vue 문서·CLI 대응과 실제 화면 검증~~ → 9/22 재구축으로 대상 변경. 문서는 아래 '재구축' 섹션의 docs 정리 항목으로 통합, Vue CLI는 2026-10-01 제거
- [x] Vue CLI 빌드 및 임시 프로젝트 `init --yes` 생성 검증 → `hanui.json`, Tailwind v3 preset, `variables.css`, `lib/utils.ts` 생성 확인; 자동 의존성 설치 완료 여부는 환경 서비스 오류로 미확인
- [x] Button·Input·Select·Checkbox·Modal·Table부터 [체크리스트](component-checklist.md)로 1차 점검 → [Vue 점검 결과](vue-audit.md)
- [x] Checkbox의 native form 참여·속성 전달 후속 검증 및 패키지 단독 테스트/빌드 재검증 → 310개 테스트 통과
- [x] FormField·Input·Select의 실제 자동 연결과 상태/오류 메시지 통합 검증 → 311개 테스트 통과
- [x] Vue 패키지에 기본 KRDS CSS 변수와 `styles.css` 산출 경로 추가 → 전체 CLI 토큰과의 통합은 미완료
- [x] CLI `variables.css`·Tailwind 프리셋과 Vue 패키지 토큰의 역할 차이 기록 → 패키지는 baseline CSS, CLI는 전체 Tailwind 통합 담당
- [x] KRDS 공식 제공 킷과 기존 HANUI의 차이·보완 가치 확인 → KRDS 리소스를 그대로 쓰고 Vue는 동작·접근성만 담당하는 방식으로 결론(2026-09-22 재구축). 원본 결함 목록은 [KRDS 소스 점검](krds-source-audit.md)
- [x] KRDS 공식 저장소 구조·HTML/CSS/JS·토큰·라이선스 안내 1차 확인 → [KRDS 소스 점검](krds-source-audit.md)
- [x] KRDS Button 기준표 작성 → [Button 기준표](krds-button-baseline.md)
- [x] Button 중앙 CSS/API 전환 및 기존 API 호환 별칭 유지
- [x] Input·FormField·Select 중앙 CSS/API 전환 및 기존 접근성 테스트 통과
- [x] Vue 패키지 전체 검증: 37개 테스트 파일·312개 테스트, 타입 검사, 빌드 통과
- [x] Vue Storybook에 Button·Input·FormField·Select의 상태별 검증 화면 추가
- [x] ~~Button·Input·FormField·Select의 실제 브라우저 화면·고대비·스크린리더 독립 검토~~ → 9/22 재구축 전 패키지 대상. 재구축 후 브라우저·고대비는 컴포넌트별로 확인 완료, 스크린리더는 아래 통합 항목으로

## 2026-09-22 · Vue 패키지 재구축 (KRDS 리소스 그대로 사용)

방향 변경: 기존 125개 Tailwind/cva 기반 Vue 컴포넌트를 버리고, KRDS HTML ComponentKit의 CSS·토큰·아이콘을 그대로 쓰는 얇은 Vue 래퍼로 새로 만든다. 운영·업데이트 편의가 이유다. 2026-09-21의 "Button·Input·FormField·Select 중앙 CSS 전환" 기록은 다른 환경(`/Users/mia/...`)에서 미커밋 상태였고 현재 저장소에는 없다.

- [x] `reference/krds-uiux` 재클론 확인 (v1.1.0, `d6bb184`)
- [x] `packages/vue/vendor/krds-uiux/`에 `resources/`·`tokens/` 복사, `VERSION.md`로 버전·업데이트 절차 기록. 원본과 바이트 동일 확인
- [x] 기존 `src/` 전부 제거. cva·clsx·tailwind-merge·lucide 의존성 제거, `sass-embedded` 추가
- [x] SCSS 진입점 `src/styles/index.scss`: vendor `output.scss` 구성을 재현 (vendor `common.scss`의 토큰 CSS `@import` 상대경로가 Vite에서 깨지므로 직접 import). `$url !default`를 덮어써 아이콘 350개를 빌드 시 data URI로 인라인 → `dist/vue.css` 단일 파일 (gzip 101KB)
- [x] Button 재작성: `variant`(primary/secondary/tertiary/text/link, 기본 primary), `size`(xsmall~xlarge, 기본 large), `icon`/`border`/`label`(sr-only), `pure`/`basic`, `disabled`/`loading`, `href` 링크 분기. JS 동작·접근성만 Vue가 담당, 스타일은 KRDS 클래스 그대로. loading 스피너만 hanui 확장 (`src/styles/_button.scss`)
- [x] 검증: 테스트 30개 통과, `vue-tsc` 통과, `eslint` 통과, `vite build` 성공. 실제 브라우저(Chromium) 렌더링으로 계층·크기·disabled·아이콘·고대비 모드 확인
- [x] Storybook 10 (`@storybook/vue3-vite` + addon-docs + addon-a11y) 설치. `pnpm storybook` / `pnpm build-storybook`. 툴바에 KRDS Light/High Contrast 모드 스위치(`data-krds-mode`), a11y 위반 시 스토리 실패 처리
- [x] Button 스토리 9종 (Default·Hierarchy·Sizes·WithIcon·IconOnly·Disabled·Loading·AsLink·HighContrast). 빌드·브라우저 렌더링·a11y 패널(위반 0) 확인
- [ ] **스크린리더 실기기 검토 (전 컴포넌트)** — NVDA(Windows)·VoiceOver(macOS/iOS)로 21개 컴포넌트와 CMS 조립 화면 확인. 키보드는 컴포넌트별 브라우저 확인 완료
- [ ] 아이콘 data URI 인라인 vs 파일 분리 배포 결정 (현재 인라인)
- [x] Button에서 hanui 확장(loading 스피너, `src/styles/_button.scss`) 제거 → `vue.css`는 KRDS 원본 100%. 테스트 27개 통과
- [x] FormField(`.form-group` / label / `.form-conts.is-*` / `.form-hint*`, id·aria-describedby provide) + Input(`input.krds-input`, v-model, size 4종, 비밀번호 보기·내용 삭제 버튼 → KRDS `.btn-ico-wrap`) 완료. 테스트 57개(누적)·typecheck·lint·빌드 통과, Storybook 스토리 7종, 브라우저로 상태 3종·아이콘 버튼 확인
- [x] Textarea(`.textarea-wrap > textarea.krds-input + .textarea-count`, maxlength 시 글자수 카운트, FormField 연결) 완료. 테스트 69개(누적), 스토리 5종, 브라우저로 에러 상태 카운트 색 확인
- [x] Select(네이티브 `select.krds-form-select` + `sort` 변형, size 3종, `.completed`/`.is-error`, options prop 또는 슬롯, FormField 연결) 완료. 테스트 87개(누적), 스토리 5종, 브라우저 확인. 단독 사용 시 aria-label 필요(title만은 axe 경고)
- [x] Table(`.krds-table-wrap > table.tbl.col.data`, caption 필수·sr-only, columns/rows + `#cell-{key}`/`#head-{key}` 슬롯, `rowHeader` 열은 `th scope="row"`, 빈 상태 colspan, 원본 마크업 default 슬롯, `scroll`/`mob-scroll` 시 `role="region" tabindex="0"` + caption으로 이름) 완료. 테스트 109개(누적)·typecheck·lint·빌드·Storybook 빌드 통과, 스토리 6종, 브라우저로 기본·스크롤(Tab 포커스·방향키 스크롤)·고대비 확인. 기본 래퍼는 모바일에서도 가로 스크롤되지만 PC 불필요 탭 정지를 피하려 region/tabindex는 scroll·mobScroll일 때만 붙임
- [x] Pagination(`nav.krds-pagination` + `.page-navi.prev/next` · `.page-links` · `.link-dot`, 첫·마지막 고정 + siblingCount 범위, 한 칸 간격은 생략 대신 페이지 표시, `getHref` 시 `<a href>`/없으면 `<button>`+v-model, 비활성 이전·다음은 원본대로 span, 현재 페이지 sr-only "현재페이지", 끝에 닿아 이전·다음이 사라지면 현재 페이지로 초점 이동, totalPages 0·NaN·소수·범위 밖 현재 페이지 보정) 완료. 테스트 137개(누적)·typecheck·lint·빌드·Storybook 빌드 통과, 스토리 7종, 브라우저로 기본·Enter 키 이동 후 초점·고대비 확인. 현재 페이지는 aria-current 없이 KRDS 원본 텍스트만 사용 (중복 낭독 방지)
- [x] Badge(`span.krds-badge` + `outline-*`/`bg-*`/`bg-light-*` × 9색, size 3종, 숫자형 `.number`(max 초과 "999+"), 점형 `.dot`, sr-only `label`을 내용 앞에 둠 → "읽지 않은 알림 5", label 없는 dot 개발 경고) 완료. 테스트 160개(누적)·typecheck·lint·빌드·Storybook 빌드 통과, 스토리 7종, 브라우저로 27개 조합·숫자·점·고대비 확인. KRDS 원본 outline 테두리 결함 발견 → [KRDS 소스 점검](krds-source-audit.md)
- [x] Modal(`section.krds-modal.fade` + `.modal-dialog.modal-{sm|md|lg}` · header/conts/`.modal-btn.btn-wrap`/`.btn-close` · `.modal-back`, `data-type` full/bottom-sheet, v-model:open, body Teleport) 완료. KRDS 동작(shown→in 전환·350ms 뒤 shown 제거·첫 초점·배경 클릭 시 첫 요소 초점·스크롤 본문 tabindex·중첩 z-index 1010+n·중첩 시 dim 생략·열었던 요소로 초점 복귀) 재현 + 원본 결함 보완(Esc 항상 동작, Tab마다 초점 대상 재계산, 바깥 전체 inert, body 스크롤 직접 잠금, aria-modal). 개발 중 발견·수정: 먼저 열린 모달이 닫혀 있던 다른 모달을 inert로 만들어 중첩 모달에 초점이 안 들어가던 문제, 실제 브라우저에서 transition 때문에 첫 초점이 무시되던 문제(jsdom에서는 재현 안 됨). 테스트 192개(누적)·typecheck·lint·빌드·Storybook 빌드 통과, 스토리 6종, 브라우저로 키보드 열기·첫 초점·Tab/Shift+Tab 순환·Esc 복귀·중첩·긴 본문 키보드 스크롤·고대비 확인. Storybook 모드 스위치를 `<html>`에도 적용하도록 수정(Teleport 요소 고대비 반영). → [KRDS 소스 점검](krds-source-audit.md)
- [x] FileUpload(`.krds-file-upload.line` + file-head / `.file-upload(.active)` / file-list · total · upload-list · `li.is-error` · `.file-hint-invalid` · 전체 파일 삭제, v-model 항목 목록) 완료. KRDS JS가 미완성("drag 임시")이라 선택·드롭 추가, accept(확장자·MIME·와일드카드)·maxSize 오류를 목록에 KRDS 방식으로 표시, maxFiles 초과는 추가하지 않고 reject 이벤트, 상태별 표시(업로드 중 스피너 / 완료 아이콘+삭제 / 대기 삭제), 삭제 후 다음 항목→파일선택 버튼으로 초점 이동, 추가·삭제·오류를 aria-live로 알림, `#actions` 슬롯(다운로드·바로보기, `.m-column`)을 Vue가 채움. 실제 업로드는 앱이 `add` 이벤트에서 처리하고 status를 바꾼다. 원본 `<label><button>` 중첩은 HTML 규칙 위반이라 제외. 테스트 226개(누적)·typecheck·lint·빌드·Storybook 빌드 통과, 스토리 6종, 브라우저로 실제 DataTransfer 드롭·업로드 중→완료·용량 오류·키보드 삭제 초점·고대비 확인. OS 파일 선택 창은 자동화 도구 파일 접근 제한으로 미확인
- [x] Breadcrumb(`nav.krds-breadcrumb-wrap[aria-label="현재 경로"] > ol.breadcrumb > li(.home) > a.txt|span.txt`, items prop, 마지막 항목 `aria-current="page"` 보완, `#item` 슬롯으로 RouterLink 사용 가능) 완료. 테스트 233개(누적)·typecheck·lint·빌드·Storybook 빌드 통과, 스토리 3종, 브라우저로 PC·모바일 폭(홈 > … > 현재)·고대비·포커스 확인. KRDS 원본 모바일 숨김 링크 초점 문제 기록 → [KRDS 소스 점검](krds-source-audit.md)
- [x] SkipLink(`div#krds-skip-link > a`, 기본 "본문 바로가기" → `#main-content`, links로 여러 개) 완료. 원본 `href="#id"`만으로는 해시 라우터에서 라우트가 바뀌고 main 등으로 초점이 안 옮겨지는 문제 → 클릭 시 대상에 직접 초점(필요 시 tabindex="-1"), 대상 없으면 기본 동작 유지+개발 경고. KRDS CSS가 id 선택자라 레이아웃에 하나만 둔다. 테스트 240개(누적)·typecheck·lint·빌드·Storybook 빌드 통과, 스토리 2종, 브라우저로 Tab 시 상단 표시·Enter 후 main 초점·해시 불변 확인
- [x] Masthead(`#krds-masthead` 공식 누리집 표시, 순수 마크업) 완료. 테스트 3개, 스토리 2종, 브라우저 확인
- [x] Header 1단계 — DropMenu(`.krds-drop-wrap`: 토글·aria-expanded/controls·하나만 열림·Esc 닫고 버튼 초점·바깥 클릭/초점 이탈 닫기·넘침 시 drop-left/right·항목 선택 시 닫고 초점 복귀·active + sr-only "선택됨"·초점 항목 z-index 상향) + Header 뼈대(`header#krds-header > .header-in > .header-container > .inner`, utility/actions/menu/mobile 슬롯, 로고 href·기관명·이미지 교체, `#wrap`·`#container`가 있을 때 KRDS 스크롤 숨김/표시) 완료. 테스트 266개(누적)·typecheck·lint·빌드·Storybook 빌드 통과, 스토리 DropMenu 4종·Header 2종, 브라우저로 PC·모바일 폭·드롭다운 키보드(Enter 열기·Tab 이동·Esc 복귀)·포커스 링 가림 수정·스크롤 숨김/표시·고대비 로고 확인
- [x] Header 2단계 — MainMenu PC(`nav.krds-main-menu > .inner > ul.gnb-menu`, 1depth 링크형/드롭다운형·`.selected`, 2depth 목록+3depth(`data-has-submenu`)·설명형(`type-description`)·단일 목록(`single-list`)·`between`·바로가기 링크·banner 슬롯) 완료. KRDS 동작(토글·aria-expanded/controls/haspopup·`.gnb-backdrop`·body `is-gnb-web`/`hasScrollY`·2depth 첫 항목 기본 선택·활성 목록 높이로 min-height·바깥 클릭/Esc/Tab 이탈 닫기·방향키 이동) + 보완(Home/End 같은 단계, Esc 후 1depth 초점 복귀, nav에 "메인 메뉴" 이름). 테스트 287개(누적)·typecheck·lint·빌드·Storybook 빌드 통과, 스토리 2종(공공기관 메뉴 예), 브라우저로 목록형·설명형·단일 목록·키보드(Enter 열기·Tab·방향키·Enter 선택·Esc 복귀)·배경/body 복원·고대비 확인
- [x] Header 3단계 — MobileMenu(`#mobile-nav.krds-main-menu-mobile > .gnb-wrap`, 기본형 왼쪽 탭, gnb-header 슬롯(utils·login·service·search)·gnb-bottom 슬롯, 1~4depth 노드 데이터) 완료. KRDS 동작(슬라이드 열기·is-backdrop·body.is-gnb-mobile·탭 클릭 시 목록 스크롤·스크롤 위치로 탭 활성·활성 목록에서 시작·3depth 펼치기·4depth 패널·배경 클릭 시 메뉴로 초점·PC 폭이면 닫기·닫으면 여는 버튼 초점) + 보완 9건(→ KRDS 소스 점검). 공용 `composables/focusWhenReady` 추가(visibility 전환 중 초점 재시도). 브라우저 확인 중 발견·수정: 열 때 초점이 body에 남던 문제, 탭 키보드 이동 시 초점이 부드러운 스크롤을 끊던 문제. 테스트 310개(누적)·typecheck·lint·빌드·Storybook 빌드 통과, 스토리 2종, 브라우저(390px)로 열기 초점·Shift+Tab 순환·탭 Home/↓ 스크롤·3depth·4depth 초점·Esc 단계별 닫기·버튼 초점 복귀·inert/스크롤 복원·고대비·PC 폭 자동 닫기 확인
- [x] Footer + Identifier(`footer#krds-footer` — foot-quick 슬롯 · f-logo(기관 로고 교체) · f-info 주소·연락처 · f-link 바로가기(외부 새 창)·SNS 5종 · f-btm 정책 링크(.point)·저작권 · `.krds-identifier` 별도 컴포넌트) 완료. 순수 마크업, 장식 아이콘 aria-hidden·새 창 rel 보완. 테스트 323개(누적)·typecheck·lint·빌드·Storybook 빌드 통과, 스토리 Footer 2종·Identifier 2종, 브라우저로 PC·모바일·고대비 확인
- [x] SideNavigation(`nav.krds-side-navigation > h2.lnb-tit + ul.lnb-list`, 2depth 펼침 버튼/링크, 3depth 링크/팝업(`.lnb-submenu-lv2` + `.lnb-btn-tit`) + 4depth, 현재 페이지 `.selected`+aria-current, 현재 위치 2depth 펼친 채 시작) 완료. 원본 menu 역할 제거(→ KRDS 소스 점검), 팝업 초점 강제 이동 제거, Esc 닫기. 테스트 337개(누적)·typecheck·lint·빌드·Storybook 빌드 통과, 스토리 2종, 브라우저로 팝업 열기 초점·Esc 복귀·Tab 이탈 시 닫힘+초점 유지·고대비 확인
- [x] KRDS CSS 결함 보완 방식 결정(→ decisions.md 2026-09-30): `src/styles/_hanui-fixes.scss`를 KRDS 다음에 적용. ① 개인정보처리방침 `.point` 굵게+primary(고대비 토큰 포함) ② Breadcrumb 모바일 숨김 항목 `:focus-within` 시 표시. 빌드 산출물 포함 확인, 브라우저로 Footer 강조(대비 약 6:1)·Breadcrumb 390px Tab 표시/복귀 확인
- [ ] 선택: 모바일 상단 탭형(`type-header-tab`) 변형, 글자 크기 조절(`krds-resize`) — 필요 시
- [x] Spinner(`div.krds-spinner[role=status]`, label sr-only, 화면 문구 있으면 sr-only 생략, `.form-spinner` 조합 예) 완료. 테스트 341개(누적)·typecheck·lint·빌드·Storybook 빌드 통과, 스토리 4종, 브라우저로 입력창 안·고대비 확인
- [x] 최소 CMS 컴포넌트 (KRDS 원본만, 순서대로): ~~Input → FormField → Textarea → Select → Table → Pagination → Badge → Modal → FileUpload → Breadcrumb → SkipLink → Masthead → Header(주메뉴·모바일메뉴) → Footer → SideNavigation → Spinner~~ **완료 (2026-09-30)** — 추가로 DropMenu·Identifier·MainMenu·MobileMenu 포함, 총 21개 컴포넌트·테스트 341개
- [ ] Vue 문서 사이트·registry를 `@hanui/vue` 새 API 기준으로 재정리 (현재 25개 docs 페이지의 `vueCode`는 구 API). Vue CLI는 제거되었으므로 CLI 대응은 제외 — CMS 화면 조립 후 진행

## 방향 확인 후 진행할 작업

- [ ] Vue 집중 범위와 React 유지 범위 확정
- [x] Vue CMS 구성·배포 방식 결정 → decisions.md 2026-09-30 (공개 Nuxt SSR / 관리자 Vite SPA / hanui-vue-cms 모노레포)
- [ ] 게시판 목록 → 상세 → 등록·수정 흐름의 작은 검증 구현 — 진행 중
  - [x] 공개 쪽 목록·상세 (2026-10-01, hanui-vue-cms `dea637e`): Nuxt SSR 공개 앱 + 공통 레이아웃(SkipLink·Masthead·Header·MainMenu·MobileMenu·Breadcrumb·SideNavigation·Footer) + P01 홈(최근 공지)·P05 목록·검색·P06 상세·P10 오류. 데이터는 mock API. 패키지 테스트 20개·타입 검사·Nuxt 타입 검사·운영 빌드 통과
  - [x] SSR 확인: 컴포넌트 라이브러리 수정 없이 서버 렌더링 동작. 서버 HTML에 문서 제목·OG 태그·목록·현재 위치(글 제목 포함) 포함, 없는 글·게시판 404, 운영 Node 서버(`.output`)에서도 동일. 브라우저(Playwright)로 하이드레이션 경고 0건, 본문 바로가기·주메뉴 키보드·모바일 전체메뉴(390px)·검색어 유지 목록 복귀 확인
  - 발견·수정: 글 상세 Breadcrumb 하이드레이션 불일치(레이아웃이 페이지 데이터보다 먼저 서버 렌더링) → 라우트 미들웨어에서 글을 먼저 조회. 링크 패키지 CSS 403(Vite fs.allow), vue-router 4/5 중복·vue-tsc 2 비호환 정리
  - [x] 관리자 앱 뼈대 (2026-10-01, hanui-vue-cms `63b0ec4`): Vite SPA `apps/admin`(포트 3400). 그누보드식 레이아웃(상단 바 + 왼쪽 관리 메뉴), M01 로그인(검증·실패 안내·redirect 복귀), M02 대시보드(최근 글), 게시판관리 목록·추가·수정(주소·이름·목록 수·분류, 서버와 같은 검증 규칙, 중복 주소 409), 역할별 메뉴·라우터 접근 제어(담당자는 게시판 설정·메뉴·환경설정·계정 불가 → 권한 없음 화면), 처리 결과 안내(role=status). 관리자 mock API(로그인·me·게시판 CRUD·최근 글, 서버 쪽 역할 검사). 테스트 37개(api 14·site-config 13·views 3·admin 7)·타입 검사·빌드 통과, 브라우저로 로그인 흐름·게시판 추가/수정/중복/권한·담당자 화면 확인
  - mock 인증은 sessionStorage 토큰 — 실제 백엔드는 HttpOnly 세션 쿠키로 대체(G04)
  - [x] 게시글관리 A1 (2026-10-01, hanui-vue-cms `0b88ff5`): M03 목록(게시판·상태·검색어 필터를 주소에 유지, 상단고정·"미게시 변경 있음" 표시), M04 작성·수정(게시판·분류·제목·상단고정·제한 편집기), M06 미리보기(공개 화면과 같은 NoticeDetailView). 상태 모델 초안/게시/게시 중단/휴지통 — 편집본과 공개본 분리, 게시 후 수정은 "변경 내용 게시" 전까지 공개본 유지, 휴지통 복원은 초안으로. `version` 낙관적 잠금(409 → "최신 내용 불러오기"). 초안은 제목만, 게시는 본문까지 필수(서버·화면 같은 규칙). 공개 목록 1쪽 맨 위에 상단고정 글 "공지" 배지
    - 편집기: Tiptap — 소제목(h2·h3)·굵게·목록·링크만 허용. `role=textbox`·`aria-multiline`·라벨 연결, 도구 모음 `role=toolbar`·roving tabindex·`aria-pressed`, 링크는 http(s)·사이트 경로·mailto·tel만(`javascript:` 차단 확인)
    - 브라우저 확인: 빈 게시 시 오류 요약 초점·본문 오류 링크 → 편집기 초점, 작성 → 초안 저장(#32) → 미리보기 → 게시 → 공개 목록 맨 위 "공지" 표시, 콘솔 오류·하이드레이션 경고 0건. 테스트 42개·타입 검사 5개 패키지·관리자 빌드 통과
    - 발견·수정: 미리보기 화면 h1 중복 → NoticeDetailView에 `titleTag`·`listLabel` 추가(미리보기는 h2). 편집 화면 번들 125KB(gzip, Tiptap) — 편집 화면 지연 로딩 청크에만 포함
  - [x] 게시글관리 A2 (2026-10-01, hanui-vue-cms `8232c66`): 첨부·본문 이미지·단순 표·게시 전 본문 검사·휴지통(M08)
    - 파일 정책(`file-policy.ts`, 화면·서버 공용): PNG/JPG/WebP, PDF/HWP/HWPX/DOCX/XLSX, 20MB, 글당 첨부 10개. 첨부는 고르는 즉시 업로드(업로드 중 저장·게시 막음), 첨부도 편집본·공개본 분리
    - 파일 공개 규칙(mock): 게시 중인 공개본이 쓰는 파일(첨부·본문 이미지)만 방문자에게 열림, 그 밖은 404. 관리자는 로그인 때 받은 HttpOnly mock 쿠키로 열람(실제 백엔드는 세션 쿠키) — 로그아웃 때 쿠키 삭제
    - 편집기: 이미지(업로드 + 대체텍스트 필수, 선택한 이미지의 대체텍스트 수정), 표(행·열 수, 제목 셀 첫 행/첫 열/둘 다, 표 편집 도구 모음: 행·열 추가·삭제, 제목 셀 켜고 끄기, 표 삭제). 표 안 Tab은 다음 셀·마지막 셀에서 편집기 밖으로(행 자동 추가 없음), Esc는 도구 모음으로(키보드 갇힘 방지)
    - 게시 전 본문 검사(`content-check.ts`, 화면·서버 공용, 편집기 JSON 기준): 고칠 항목(게시 차단) — 대체텍스트 없음·파일 이름·"사진" 같은 일반어, 외부 이미지, 제목 셀 없는 표·빈 제목 셀, 빈 제목, 본문 제목 없이 먼저 나온 소제목, "여기·클릭" 같은 링크 문구 / 권고 — 150자 넘는 대체텍스트, 주소 그대로인 링크 문구. 오류 요약·검사 패널 항목을 누르면 편집기에서 해당 위치로 이동. 서버도 게시 때 다시 검사(400 + issues)
    - 공개 화면: 표 제목 셀에 scope(첫 행 col, 그 밖 row), 편집기 너비 지정 제거, 앞뒤 빈 문단 제거, 본문 이미지·번호 목록·링크 스타일
    - M08 휴지통(`/trash`, 사이트맵대로 왼쪽 메뉴 최상위): 게시판·제목 검색, 초안으로 복원(복원 후 다음 복원 버튼 또는 제목으로 초점). 게시글 목록의 상태 필터에서 휴지통 제외. 영구 삭제 UI는 범위 제외(sitemap §3)
    - 브라우저 확인(Playwright MCP, 담당자 계정): 이미지 대체텍스트 없음·파일 이름·"사진" 차단, 업로드한 비공개 이미지가 관리자 화면에 표시, 표 삽입(첫 행·첫 열)·Tab 셀 이동·Esc → 도구 모음, exe 첨부 거부·PDF 업로드 완료, 검사 패널, 빈 제목 셀 있는 표로 게시 시 저장하지 않고 오류 요약 → 항목 링크로 표 안 커서 이동, 고친 뒤 게시 → 공개 HTML(scope·대체텍스트·첨부 다운로드)·쿠키 없이 이미지 200, 게시 중단 후 이미지·상세 404, 휴지통 이동 → M08 복원 → 초안·공개 404. curl로 업로드 형식 거부·모르는 첨부 id 거부·서버 게시 검사 확인. 테스트 55개·타입 검사 5개 패키지·관리자 빌드 통과
    - 발견·수정: 이미지 대화상자를 다시 열면 이전에 고른 파일이 input에 남아 보이지만 상태는 비어 "파일을 선택하세요"가 뜨고, 같은 파일을 다시 골라도 change가 일어나지 않던 문제 → 열 때 input 비움
    - 남은 것: 표 제목(caption) 입력 미지원 — 표 앞 문단으로 설명하도록 안내 필요, 검토. 파일 형식은 확장자만 확인(실제 백엔드는 파일 시그니처 확인). 파일 관리 화면(사용처 조회·미사용 파일 제거)은 별도 작업. 편집 화면 번들 148KB(gzip, 지연 로딩). 실제 화면낭독기 검토 전
  - [x] 내용관리(고정 페이지, M05·P02~P04·P08·P09) (2026-10-02, hanui-vue-cms `864749c`)
    - 페이지는 개발자가 납품 때 구성(주소·템플릿·보호 여부 고정), 담당자는 템플릿이 허용한 칸만 편집. 템플릿 3종(`page-templates.ts`, 화면·서버 공용): 일반(제목·본문 필수), 오시는 길(주소 필수·대표전화·지도 링크 + 교통 안내 본문, 지도 연동 없이 외부 링크 — sitemap 문서대로), 사업 목록(소개 문구 + 게시 중인 하위 사업 자동 목록)
    - 상태·리비전·충돌·게시 전 검사·첨부 규칙은 게시글과 같음. 보호 페이지는 게시 중단·휴지통 버튼 없이 이유 안내, 서버도 409로 거부. 템플릿에 없는 칸은 서버가 버림
    - mock 구성: 기관 소개·오시는 길·사업 목록·개인정보처리방침·저작권 정책(보호), 창업 지원·주민 교육(게시)·지난 사업 안내(초안). 공개 API `/api/public/pages?path=`
    - 공개 앱: 고정 페이지 catch-all + 라우트 미들웨어(page.global)에서 게시본 선조회(없거나 비공개 404), 현재 위치는 메뉴 경로 + 메뉴에 없는 페이지·하위 사업은 제목 덧붙임. P09 사이트맵(메뉴 + 이용 안내). 공용 `PageView`(관리자 미리보기 공유), 첨부 목록 `AttachmentList`로 분리
    - 관리자: M05 페이지 목록(구성 순서·들여쓰기·보호 표시), 페이지 편집, 미리보기. 휴지통에 종류(게시글·페이지) 선택 추가. 게시글 편집의 첨부·검사 패널을 공용 부품(`useAttachments`, `AttachmentField`, `ContentCheckPanel`)으로 분리하고 편집 화면 공통 스타일을 admin.css로 이동
    - 확인: curl로 공개 8개 주소(200·404·현재 위치·문서 제목) 서버 HTML, 보호 페이지 휴지통 거부·템플릿 칸 형식 검증. 브라우저(Playwright MCP, 담당자): 페이지 목록, 오시는 길 주소 비움·전화 형식 오류 → 오류 요약·초점, 수정 게시 → 공개 화면 반영(tel 링크·새 창 지도 링크), 하위 사업 휴지통 → 공개 404·사업 목록에서 빠짐 → 휴지통(페이지)에서 복원 → 초안(비공개), 미리보기, 게시글 편집 회귀. 스크린샷(오시는 길·사이트맵), 하이드레이션 경고 0건. 테스트 61개·타입 검사 5개 패키지·관리자 빌드 통과
    - 발견·수정: mock 서버가 규칙 파일 간 확장자 없는 값 import를 못 풀어 기동 실패 → 규칙 파일끼리 값 import 금지, 게시글과 같은 기준인지 테스트로 고정. 받침에 맞춘 조사("주소를", "본문을")
    - 남은 것: 푸터 주소·대표전화는 아직 사이트 설정(sample) 값 — 오시는 길과 연결은 환경설정에서. 새 페이지를 메뉴에 노출하는 것은 메뉴설정. 홈(P01) 관리 콘텐츠 미구현
  - [x] 메뉴설정(M10, 기관 관리자) (2026-10-02, hanui-vue-cms `8a4598e`)
    - 범위: 분류(1단계)는 납품 구성 고정(추가·삭제는 서버도 거부), 분류·항목 이름·순서·표시 변경, 이미 있는 게시판·페이지를 항목으로 연결/빼기(새 게시판을 공개 메뉴에 노출). 외부 링크·분류 추가는 개발 작업
    - 공개 메뉴 API(`/api/public/menu`): 숨긴 분류·항목, 게시 중이 아닌 페이지·없는 게시판을 가리키는 항목, 빈 분류를 뺀다(F10 "미게시 페이지 메뉴는 방문자에게 숨김"). 공개 앱은 미들웨어(00.site.global)에서 렌더링 전에 받고 실패하면 기본 메뉴로 그린다 — 주메뉴·전체메뉴·사이드 메뉴·현재 위치·사이트맵이 모두 따라 바뀜
    - 관리자 화면: 순서는 위로·아래로 버튼(키보드), 옮긴 뒤 같은 버튼(끝에 닿으면 반대 버튼)으로 초점·결과 알림, 빼기 후 다음 항목 초점, 추가 후 새 항목 이름 칸 초점. 항목마다 연결 대상과 숨겨지는 이유(초안·게시 중단·휴지통·없음)를 도움말로 연결. "방문자에게 보이는 메뉴" 저장 전 미리보기. 검증(`menu-validation.ts`, 이름 필수·20자, 서버는 대상 존재·중복도 확인), 낙관적 잠금 409, 이탈 확인
    - 확인: curl로 공개 메뉴·담당자 403. 브라우저(Playwright MCP, 관리자): 초안 페이지 추가(숨겨짐 안내·미리보기에서 빠짐), 게시 페이지 추가, 자료실 위로(초점·알림), 분류 이름 변경, 오시는 길 숨김, 빈 이름 저장 → 오류 요약·초점, 저장 → 공개 주메뉴·모바일 메뉴·사이트맵·현재 위치 반영, 하이드레이션 경고 0건. 테스트 65개·타입 검사 5개 패키지·관리자 빌드 통과
    - 발견·수정: 상위 페이지(/business)와 하위 페이지(/business/startup)가 같은 단계 메뉴에 나란히 있으면 앞 항목이 선택되어 현재 위치·사이드 메뉴가 "사업 목록"을 가리킴 → findTrail이 같은 깊이에서 더 구체적인 경로를 고르도록 수정(테스트 추가)
    - 남은 것: 메뉴 순서 변경을 끌어 놓기로도 할지는 사용 확인 뒤 판단. 메뉴는 공개 앱이 요청마다 받는다(캐시 없음) — 실제 백엔드에서 캐시·무효화 정책 필요
  - [ ] 환경설정·계정관리·변경 기록 (현재 "준비 중" 화면)
  - [x] 공개 쪽 게시판을 관리자가 만든 게시판 목록 기반으로 전환 (2026-10-01, hanui-vue-cms `24a58cd`): 공개 API 게시판 목록·글 분류, 라우트 미들웨어(board.global)에서 게시판 존재 확인(없으면 404)·메뉴에 없는 게시판의 현재 위치("홈 > 게시판"), 게시판별 목록 수 적용, **분류 필터·분류 열**(GET 폼, 목록·상세 복귀 시 분류·검색어 유지), 상세에 분류 표시. 관리자에서 만든 게시판이 공개 사이트에서 바로 열리는 것 확인
  - [x] 라이브러리 수정(hanui `cab27de`): Select가 SSR HTML에 선택 option의 `selected`를 출력하지 않아 JS 실행 전 "전체"로 보이던 문제 → option에 selected 바인딩, SSR 테스트 2개 추가(라이브러리 테스트 343개)
  - [ ] 새 게시판을 공개 메뉴에 노출하는 것은 메뉴설정(1차) 작업에서 연결
  - [ ] 남은 확인: 상세 화면에서 주메뉴·사이드메뉴가 목록 링크에 `aria-current="page"`를 붙임(정확히는 상위 위치 표시) — 라이브러리에서 `location` 값 지원 검토
- [ ] 검증 결과를 기준으로 CMS 이식 범위와 일정 정리
- [ ] Checker의 실제 검사 항목을 KRDS·접근성·수동 확인 항목으로 정리

위 항목은 작업 목록이며 일괄 실행이나 프레임워크 전환 완료를 뜻하지 않는다. 다음 작업의 완료 근거와 새로 발견한 문제를 이 문서에 이어서 기록한다.

## Vue 패키지 배포 (2026-10-01)

- [x] `@hanui/vue@0.2.0` npm 게시 (Release 워크플로 run 36794245811, Trusted Publishing, provenance 확인). `latest` = 0.2.0
- [x] `packages/vue-cli` 제거, React 패키지 private 처리, 저장소 시크릿 전부 삭제(NPM_TOKEN, 토큰값이 이름으로 들어간 시크릿)
- [x] npm 기존 버전 deprecate: `@hanui/vue@<0.2.0`, `@hanui/vue-components` (2026-10-01 npm 조회로 확인)
- [x] 발급한 npm 2FA 우회 토큰 폐기 (사용자 처리)
- [x] 태그 트리거 `publish.yml` 제거 (게시는 release.yml로 일원화)
- [ ] hanui-vue-cms: Docker/CI 빌드 전 `link:` → `^0.2.0` 전환
