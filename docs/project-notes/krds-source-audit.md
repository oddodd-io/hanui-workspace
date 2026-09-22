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

## 다음 검증

1. [KRDS Button 기준표](krds-button-baseline.md)와 같이 v0 필수 컴포넌트의 KRDS 원본 HTML·상태 예제와 HANUI API 매핑표 작성
2. 토큰 JSON에서 색상·간격·타이포그래피·모션 토큰 추출
3. Button, Input, FormField, Select, Table, Pagination, Modal부터 중앙 CSS로 전환
4. 원본 예제와 Vue 렌더링을 실제 브라우저에서 비교
5. KRDS 원본의 HTML·CSS·JS를 그대로 배포하지 않고 필요한 부분만 재작성했는지 검토
