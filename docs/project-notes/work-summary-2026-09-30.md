# 작업 정리 — Vue 컴포넌트 완성과 CMS 착수 (2026-09-29 ~ 09-30)

작성일: 2026-09-30
대상: 작업을 이어받을 사람 (다음 세션 포함)
상세 근거: [할 일](tasks.md), [기술 선택](decisions.md), [KRDS 소스 점검](krds-source-audit.md)

## 1. 한 줄 요약

KRDS 원본 CSS를 그대로 쓰는 Vue 컴포넌트 라이브러리(`repos/hanui/packages/vue`)의 **최소 CMS 컴포넌트 목록을 모두 완성**했다. 그다음 CMS 저장소(`repos/hanui-vue-cms`)의 구성을 확정하고 **모노레포 뼈대를 만드는 중**이다(미커밋·미설치·미검증).

## 2. Vue 컴포넌트 라이브러리 — 완료

### 원칙 (9/22 재구축 때 정한 것, 유지)

- 스타일은 `vendor/krds-uiux`(KRDS v1.1.0)의 SCSS를 그대로 빌드한다. vendor는 수정하지 않는다.
- 마크업·클래스는 `reference/krds-uiux/html/code/*.html` 샘플을 따른다. Vue는 동작과 접근성만 담당한다.
- 샘플과 다르게 한 곳은 모두 접근성 결함 보완이나 HTML 규칙 준수 때문이며, 컴포넌트 주석과 [KRDS 소스 점검](krds-source-audit.md)에 적었다.

### 컴포넌트 21개

| 구분 | 컴포넌트 |
| --- | --- |
| 폼 | Button, FormField, Input, Textarea, Select, FileUpload |
| 데이터·표시 | Table, Pagination, Badge, Spinner |
| 오버레이 | Modal, DropMenu |
| 레이아웃 | SkipLink, Masthead, Header, MainMenu(PC), MobileMenu, SideNavigation, Breadcrumb, Footer, Identifier |

이번 기간에 추가한 것: Table부터 Spinner까지 16개(Button·FormField·Input·Textarea·Select는 9/22 완료).

### 검증 상태

- 테스트 341개 통과, `vue-tsc`·eslint(경고 0)·Vite 빌드·Storybook 빌드 통과.
- 컴포넌트마다 Storybook을 실제 브라우저(Chromium)로 열어 모양, 키보드 조작, 고대비 모드를 확인했다. 필요한 경우 모바일 폭(390px)도 확인했다.
- **미확인**: 스크린리더(NVDA·VoiceOver) 실기기 검토는 한 번도 하지 않았다. 입찰 검수 전에 필요하다.

### KRDS 원본에서 찾은 결함과 처리

JS 동작 결함은 Vue에서 바로잡았다. 대표적인 것:

- **Modal**: Esc가 한 번만 동작함, 초점 가두기 대상 고정, `#wrap`에만 inert, 스크롤 잠금 CSS 없음, `aria-modal` 누락
- **MobileMenu**: Esc 없음, 푸터 id 오류로 inert 누락, 탭 역할만 있고 방향키 없음 등 9건
- **FileUpload**: 드롭해도 파일이 추가되지 않는 "임시" 구현, `<label><button>` 중첩(HTML 위반)
- **SideNavigation**: 방향키 없이 menu 역할 사용, 팝업 이탈 시 초점 강제 이동
- **주메뉴·DropMenu·Breadcrumb·Spinner·SkipLink**: 초점 복귀, `aria-current`, 링크의 `aria-selected` 오용, 중복 낭독 등

CSS 결함은 **hanui 보완 CSS 한 파일**로 덮어쓰기로 결정했다(→ [기술 선택](decisions.md) 2026-09-30).

- 위치: `packages/vue/src/styles/_hanui-fixes.scss`, KRDS 다음에 불러온다.
- 적용 2건: ① Footer 개인정보처리방침 `.point` 강조(원본 CSS 정의 없음) ② Breadcrumb 모바일 숨김 항목에 초점이 들어오면 표시(WCAG 2.4.7)
- 보완하지 않은 것: Badge outline 테두리 변수 오류(화면 차이 작음), Spinner `prefers-reduced-motion`(AAA)

### 작업 중 발견해 고친 버그 (jsdom 테스트로는 안 잡힌 것 포함)

- Modal·MobileMenu: KRDS CSS의 visibility 전환 때문에 열린 직후 `focus()`가 무시됨 → 공용 `composables/focusWhenReady.ts`로 초점이 실제로 들어갈 때까지 재시도
- Modal: 먼저 열린 모달이 닫혀 있던 다른 모달까지 inert로 만들어 중첩 모달에 초점이 안 들어감
- DropMenu: 포커스 링이 다음 항목에 가려짐
- MobileMenu: 탭 키보드 이동 시 초점이 부드러운 스크롤을 끊음
- Storybook: 고대비 모드가 Docs 페이지 전체에 번짐(Docs에서는 `<html>`에 모드를 붙이지 않도록 수정)

### 커밋 (repos/hanui, main, 푸시 안 함)

`496d7e5` Table → `b49e5ba` Pagination → `b888c69` Badge → `153b834` Modal → `efb334c` FileUpload → `d9f360d` Breadcrumb → `21d4c44` SkipLink → `af1afe9` Masthead → `d4f7968` DropMenu·Header → `0a61d90` MainMenu → `777b822` MobileMenu → `ed1f570` Footer·Identifier → `ea80db2` SideNavigation → `4cdcbee` Spinner → `5c66c23` Storybook Docs 모드 수정 → `3592785` 보완 CSS

이 작업과 별도로 main에 배포 관련 커밋 `1e3cb63`·`19afc9e`·`971309b`·`2bd1186`이 추가되었다. **패키지명이 `@hanui/vue`로 바뀌었고 0.2.0이 npm에 게시되었다**(`@hanui/vue-components`는 deprecate). → [할 일](tasks.md) "Vue 패키지 배포 (2026-10-01)"

## 3. CMS — 진행 중

### 확정한 구성 (→ [기술 선택](decisions.md) 2026-09-30)

| 위치 | 역할 | 기술 |
| --- | --- | --- |
| `repos/hanui-vue-cms/apps/public` | 방문자 사이트 (P01~P10) | **Nuxt SSR** — 네이버·다음 검색 수집, 카카오톡 링크 미리보기(OG) 때문 |
| `apps/admin` | 관리자 CMS (M01~M13) | Vite SPA — 검색 노출 불필요, 내부망 분리 배포 가능 |
| `packages/views` | 공개 화면 본문 — 공개 앱과 관리자 미리보기(M06)가 함께 사용 | Vue |
| `packages/api` | API 계약 타입·클라이언트, 개발용 mock 서버 | TypeScript |
| `packages/site-config` | 기관 정보·메뉴 구조 → 주메뉴·모바일메뉴·사이드메뉴·현재 위치 변환 | TypeScript |

- 백엔드(전자정부 v5)가 붙기 전까지 데이터는 API 계약 형태의 mock으로 채운다. **mock 상태의 화면은 납품 완료나 A01~A02 통과로 기록하지 않는다.**
- 컴포넌트 라이브러리는 개발 중 `link:../../../hanui/packages/vue`로 연결한다.

### 지금까지 만든 파일 (hanui-vue-cms, 모두 미커밋)

- 루트: `package.json`, `pnpm-workspace.yaml`, `tsconfig.base.json`, `.gitignore`, `README.md`(구성·실행 방법)
- `packages/site-config`: 메뉴·기관 정보 타입, 메뉴 트리 → 컴포넌트 데이터 변환 함수(`toMainMenu`·`toMobileMenu`·`toSideNav`·`toBreadcrumb`), 가상 기관 샘플 설정
- `packages/api`: 공개 API 계약 타입(목록·상세·첨부·페이지), fetch 클라이언트, Node 내장 http mock 서버(공지 24건·자료실 6건, 포트 4010)
- `packages/views`: `NoticeListView`(P05 — 검색 폼·총 건수·Table·링크형 Pagination), `NoticeDetailView`(P06 — 본문·첨부 파일명/형식/용량·목록 복귀), 날짜·파일형식·본문 표 KRDS 변환 함수, 페이지 배치 CSS(KRDS 토큰만 사용)

### 아직 하지 않은 것 (이어서 할 순서)

1. `pnpm install` — 아직 한 번도 설치·타입 검사·테스트를 돌리지 않았다. 위 파일은 **검증 전 초안**이다.
2. `apps/public` Nuxt 앱: 기본 레이아웃(SkipLink·Masthead·Header·MainMenu·MobileMenu·Breadcrumb·Footer), P05·P06 페이지, mock API 연결
3. **SSR 호환 확인**: 컴포넌트 라이브러리를 서버 렌더링에서 처음 돌린다. `useId`·`document`/`window` 접근·Teleport가 SSR과 하이드레이션에서 문제없는지 확인하고 필요하면 라이브러리를 고친다.
4. 조립하면서 빠진 컴포넌트 목록 작성(Tab·Accordion·검색 등 예상)
5. `apps/admin`: M01 로그인·M03 목록·M04 편집·M06 미리보기
6. 첫 커밋

### 2026-10-01 진행

- 설치·검증 후 `apps/public`(Nuxt 4.5 SSR)을 만들어 공통 레이아웃과 P01·P05·P06·P10을 조립했다. hanui-vue-cms 첫 커밋 `dea637e`.
- **SSR 호환 확인 완료** — 컴포넌트 라이브러리를 고치지 않고 서버 렌더링·하이드레이션이 동작했다(경고 0건). 운영 빌드(`.output`, Node 서버)도 확인.
- 남은 것: 관리자 앱(M01·M03·M04·M06), 그다음 백엔드 API 계약. 자세한 내용은 [할 일](tasks.md).

## 4. 남은 일 (tasks.md "다음에 할 일")

| 순서 | 일 | 상태 |
| --- | --- | --- |
| 1 | 검수 대응 보완 CSS 방식 결정 | 완료 |
| 4 | CMS 화면 조립 (위 3장) | 진행 중 — 사용자가 2번보다 먼저 하기로 정함 |
| 2 | Vue 문서 사이트·CLI·registry 새 API 기준 정리 (docs의 `vueCode` 25페이지가 구 API) | 대기 — CMS 조립 후 |
| 3 | 스크린리더 실기기 검토 | 대기 |

## 5. 알아둘 점

- 문서에는 CMS 저장소가 `hanui-cms`(Next.js)로 적혀 있지만 이 작업 공간에는 없다. 실제 저장소는 빈 상태에서 시작한 `hanui-vue-cms`다.
- 초기에 A01~A02를 "화면"이라고 잘못 부른 적이 있다. A01·A02는 [첫 납품 범위](first-delivery.md)의 **업무 시나리오**다.
- Storybook 개발 서버(`pnpm storybook`, http://localhost:6006)가 백그라운드에서 실행 중일 수 있다.
