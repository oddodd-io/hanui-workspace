# KRDS 공식 소스 확인

확인일: 2026-09-21

대상: [KRDS-uiux/krds-uiux](https://github.com/KRDS-uiux/krds-uiux)

## 확인한 구성

- 저장소는 `html/code` 아래에 컴포넌트별 HTML 예제를 제공한다.
- `resources/css`, `resources/scss`, `resources/js`, `resources/fonts`, `resources/img/component`로 실제 리소스를 분리한다.
- `tokens/figma_token.json`과 `tokens/transformed_tokens.json`을 제공한다.
- `package.json`의 패키지 버전은 확인 시점에 `1.1.0`이며, 저장소 설명은 HTML Component Kit이다.
- 저장소 패키지는 Vue 컴포넌트 라이브러리가 아니라 HTML·CSS·JavaScript 기반의 원본 구현이다.
- 라이선스 필드는 ISC지만 README는 KRDS 이용약관·저작권 안내를 함께 따르도록 안내하므로, 배포 전 이용 조건을 별도로 확인한다.

## v0 CMS에 직접 관련된 원본

`button`, `text_input`, `textarea`, `select`, `checkbox`, `date_input`, `file_upload`, `table`, `pagination`, `modal`, `tab`, `breadcrumb`, `side_navigation`, `header`, `footer`, `skip_link`, `spinner`, `badge`, `tag`, `disclosure`가 우선 대상이다.

## 적용 판단

KRDS 소스를 통째로 Vue로 다시 포팅하지 않는다. 원본 HTML·CSS·JS는 구조·상태·토큰·접근성 관계를 대조하는 기준으로 사용하고, HANUI Vue의 public API, `v-model`, 슬롯, 이벤트, FormField 컨텍스트와 결합한 중앙 CSS를 별도로 만든다.

## Button 1차 대조 결과

기준 커밋 `d6bb184c823e4757f05807ea4646a23e3133b6e6`의 `html/code/button.html`과 `resources/scss/component/_button.scss`를 현재 HANUI Button과 비교했다.

- KRDS 기본 마크업은 `button.krds-btn`이다.
- KRDS 색상 계열은 primary, secondary, tertiary, text, link이며, 현재 HANUI의 success/danger/ghost/outline/black와 일치하지 않는다.
- KRDS 크기는 xsmall, small, medium, large, xlarge이고 기본은 large다. 현재 HANUI의 xs, sm, md, lg, xl, icon과 명칭·기본값이 다르다.
- KRDS 스타일은 hover, active/pressed, disabled, 고대비 모드, text/link/icon 특수 형태를 포함한다.
- 따라서 현재 Button을 KRDS CSS로 덮어쓰면 기존 API 사용처가 깨질 수 있다. 먼저 KRDS 명칭을 canonical API로 정하고 기존 명칭은 호환 별칭으로 둘지 결정해야 한다.
- CSS 복사만으로는 KRDS의 키보드·ARIA·링크 비활성 동작을 보장할 수 없으므로 Vue 동작 테스트와 함께 대조한다.

특히 `transformed_tokens.json`은 현재 HANUI가 가진 일부 색상 토큰보다 범위가 넓다. 현재 패키지의 baseline 토큰을 KRDS 원본 토큰과 대조해 누락을 채우되, 임의 이름 변경으로 기존 컴포넌트를 깨지 않도록 호환 별칭을 둔다.

## KRDS 원본 결함 기록 (vendor는 수정하지 않음)

- **Badge outline 테두리 색 (v1.1.0)**: `_badge.scss`의 `color-border` 믹스인이 primary 외 8색에서 정의되지 않은 `--krds-badge--light-color-{색}-element`를 참조한다. 그 결과 `border-color`가 무효 처리되어 글자색(currentColor)으로 대체된다. 2026-09-29 브라우저 확인: outline-secondary~disabled 테두리 = 글자색, outline-primary만 전용 테두리 색(`#256ef4`)이다. 화면 차이는 작다. KRDS 업데이트 시 수정 여부를 확인한다.
- **Modal JS (`ui-script.js` krds_modal, v1.1.0)**: ① Esc 리스너가 `{ once: true }`라 Tab 등 다른 키를 먼저 누르면 Esc로 닫히지 않음 ② 초점 가두기 대상을 열 때 한 번만 계산 ③ 배경 inert를 `#wrap` id에만 적용 ④ `body.scroll-no`를 붙이지만 CSS 정의가 없어 배경 스크롤이 잠기지 않음 ⑤ `aria-modal` 없음. Vue Modal에서 모두 보완했다(2026-09-29).
- **Modal 첫 초점 지연의 이유**: `.krds-modal`의 visibility 전환과 `.krds-btn` 자체 transition 때문에 열린 직후 몇 프레임 동안 버튼이 hidden 상태라 `focus()`가 무시된다. 원본은 350ms 고정 지연으로 처리하고, Vue는 초점이 들어갈 때까지 프레임마다 재시도한다.
- **FileUpload (v1.1.0)**: JS(`krds_fileUpload`)가 주석대로 "drag 임시" — drop 시 테두리만 바꾸고 파일을 처리하지 않으며 목록 추가·삭제·검사 동작이 없다. 마크업의 `<label for><button>`은 레이블 안에 다른 레이블 가능 요소(button)를 넣어 HTML 규칙 위반. Vue FileUpload에서 동작을 채우고 label 중첩은 쓰지 않았다(2026-09-30).
- **Breadcrumb (v1.1.0)**: ① 현재 페이지 항목에 `aria-current="page"` 없음 → Vue에서 추가 ② 모바일 폭에서 중간 항목을 `sr-only`로 숨기지만 링크는 여전히 Tab 초점을 받아, 보이지 않는 곳에 초점이 간다(WCAG 2.4.7 초점 표시 위반 소지). → 2026-09-30 `_hanui-fixes.scss`로 보완(초점이 들어온 항목만 표시).
- **Dropdown (`krds_dropEvent`, v1.1.0)**: 선택 항목 링크에 `aria-selected`를 붙이는데 link 역할에 허용되지 않는 속성이다. Vue DropMenu는 KRDS의 sr-only "선택됨" 문구만 쓴다(2026-09-30).
- **Header 스크롤 동작**: `#wrap`·`#container` id 구조에 의존한다. Vue Header는 두 요소가 있을 때만 scroll-down/up 클래스를 붙인다.
- **주메뉴 PC (`krds_mainMenuPC`, v1.1.0)**: ① Home/End가 2depth에서도 1depth 처음·끝으로 이동 ② Esc로 닫아도 초점을 1depth 버튼에 돌려주지 않음 ③ "메인 메뉴" 이름을 ul에 붙여 랜드마크(nav)로 찾을 수 없음. Vue MainMenu에서 보완(2026-09-30).
- **모바일 전체메뉴 (`krds_mainMenuMobile`, v1.1.0)**: ① 여는 버튼 aria-expanded 주석 처리 ② Esc로 닫히지 않음 ③ inert를 `#container`·`#footer` 고정 id로 걸어 KRDS 푸터(`#krds-footer`)가 빠짐 ④ 열 때마다 초점 가두기 리스너 누적·대상 고정 ⑤ tablist/tab 역할이지만 방향키 동작 없음 ⑥ 펼침 요소가 `a[href="#"]` ⑦ 4depth 본문이 `ul > h4`(HTML 위반) ⑧ 4depth "전체메뉴 닫기"가 4depth만 닫음 ⑨ 메뉴 영역에 대화상자 역할 없음. Vue MobileMenu에서 보완(2026-09-30). 펼침 요소를 button으로 바꾸면서 KRDS a와 같은 폭을 위해 인라인 `width:100%; text-align:left`만 추가했다.
- **Footer `.f-menu a.point` (v1.1.0)**: 샘플 마크업은 개인정보처리방침에 `.point`를 붙이지만 CSS 정의가 없어 다른 링크와 똑같이 보인다. 개인정보처리방침은 다른 링크와 구별되게(색·굵기) 표시하도록 요구되므로 → 2026-09-30 `_hanui-fixes.scss`로 보완(굵게 + primary).
- **Footer 관련 사이트(.foot-quick)**: 레이어를 여는 버튼만 있고 레이어 마크업·JS가 없다. Vue Footer는 quick 슬롯으로 비워 둔다.
- **SideNavigation (`krds_sideNavigation`, v1.1.0)**: ① menubar/menu/menuitem 역할을 쓰지만 방향키 동작이 없어 스크린리더 사용자가 기대한 조작이 안 됨 ② 3depth 팝업 밖으로 Tab 이동 시 transitionend 후 초점을 여는 버튼으로 강제 이동 ③ nav에 이름 없음. Vue SideNavigation은 APG 사이트 내비게이션 권고대로 목록 + aria-expanded 버튼으로 두고(menu 역할 제거), 팝업은 초점 강제 이동 없이 닫으며 Esc·제목 버튼일 때만 되돌리고, nav 이름을 제목으로 연결(2026-09-30).
- **Spinner (v1.1.0)**: 화면 문구와 sr-only "로딩 중"을 함께 넣어 두 번 읽힘 → Vue Spinner는 화면 문구가 있으면 sr-only 생략. 회전 애니메이션에 `prefers-reduced-motion` 대응 없음(WCAG 2.3.3은 AAA라 필수는 아님, 기록만).

## 다음 검증

1. [KRDS Button 기준표](krds-button-baseline.md)와 같이 v0 필수 컴포넌트의 KRDS 원본 HTML·상태 예제와 HANUI API 매핑표 작성
2. 토큰 JSON에서 색상·간격·타이포그래피·모션 토큰 추출
3. Button, Input, FormField, Select, Table, Pagination, Modal부터 중앙 CSS로 전환
4. 원본 예제와 Vue 렌더링을 실제 브라우저에서 비교
5. KRDS 원본의 HTML·CSS·JS를 그대로 배포하지 않고 필요한 부분만 재작성했는지 검토
