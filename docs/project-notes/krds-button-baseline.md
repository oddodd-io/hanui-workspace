# KRDS Button 기준표

작성일: 2026-09-21  
기준: `reference/krds-uiux`의 Button 원본 HTML·SCSS, 기준 커밋 `d6bb184c823e4757f05807ea4646a23e3133b6e6`

이 문서는 HANUI Vue Button을 중앙 CSS/API로 전환하기 전의 대조 기준이다. KRDS 원본의 클래스와 토큰을 그대로 공개 API로 복사하지 않고, Vue의 props·slot·이벤트와 호환되는 API로 매핑한다.

## 1. 구조 기준

| 항목 | KRDS 기준 | HANUI Vue 전환 기준 | 검증 방법 |
|---|---|---|---|
| 기본 요소 | `<button type="button" class="krds-btn">` | 기본은 실제 `<button>` | 렌더링 태그·`type` 확인 |
| 링크 | Button 예제에는 별도 링크 변형이 있으나 링크는 탐색 의미 | `href`가 있으면 `<a>`, 없으면 `<button>` | href 유무별 DOM 확인 |
| 기본 type | `button` | `type="button"` | 폼 안에서 submit 오작동 방지 |
| 아이콘 | `.svg-icon`와 텍스트 대체 이름 조합 | `iconLeft`·`iconRight` 슬롯, 아이콘 전용은 명시적 이름 필수 | 스크린리더 이름·장식 아이콘 확인 |
| 비활성 | `disabled` 속성과 disabled 색상 | `<button>`은 native disabled, `<a>`는 href 제거·`aria-disabled="true"`·클릭 차단 | 키보드·마우스 직접 요청 확인 |
| 포커스 | 키보드 포커스와 focus/pressed 상태 제공 | `:focus-visible` 스타일과 native 포커스 유지 | Tab 및 Enter/Space 확인 |

## 2. 계층(variant) 기준

| KRDS canonical variant | 의미 | HANUI 전환 | 기존 별칭 처리 |
|---|---|---|---|
| `primary` | 화면의 핵심 실행 | 유지 | 없음 |
| `secondary` | 보조 실행 | 유지 | 없음 |
| `tertiary` | 중립적 보조 실행 | 유지 | 없음 |
| `text` | 테두리 없는 텍스트 동작 | 추가 | `ghost` 계열과 의미를 구분 |
| `link` | 본문 링크 성격의 동작 | 추가 | `href` 링크와 시각 변형을 분리 |
| `success` | KRDS Button 계층에 없음 | 호환 별칭으로 당분간 유지 여부를 별도 결정 | 새 사용 금지 |
| `danger` | KRDS Button 계층에 없음 | 호환 별칭으로 당분간 유지 여부를 별도 결정 | 새 사용 금지 |
| `ghost`, `ghost-primary`, `outline`, `black` | KRDS canonical 이름에 없음 | 호환 별칭으로 당분간 유지 여부를 별도 결정 | 새 사용 금지 |

원칙: 새 코드에서는 KRDS canonical variant만 사용한다. 기존 별칭을 제거하는 것은 사용처 전수 확인과 migration 안내 이후로 미룬다.

## 3. 크기 기준

| KRDS size | 원본 기준 | HANUI API 매핑 | 비고 |
|---|---|---|---|
| `xsmall` | 가장 작은 일반 버튼 | canonical `xsmall` | 기존 `xs` 호환 별칭 후보 |
| `small` | 작은 일반 버튼 | canonical `small` | 기존 `sm` 호환 별칭 후보 |
| `medium` | 중간 버튼 | canonical `medium` | 기존 `md` 호환 별칭 후보 |
| `large` | 기본 버튼 크기 | canonical `large` | KRDS 기본값 |
| `xlarge` | 가장 큰 일반 버튼 | canonical `xlarge` | 기존 `xl` 호환 별칭 후보 |
| `icon` | 아이콘 전용 형태 | `icon` 변형으로 유지 | 이름 또는 sr-only 대체 텍스트 필수 |

일반 버튼의 기준 높이·간격·모서리·타이포그래피는 KRDS SCSS의 `button-size-variable()` 토큰을 사용한다. `text`와 `link`는 KRDS 원본처럼 일반 버튼과 높이·좌우 패딩·글자 크기가 다를 수 있으므로 일반 size 규칙을 기계적으로 재사용하지 않는다.

## 4. 상태·상호작용 기준

| 상태 | 시각 기준 | 동작 기준 | 필수 검증 |
|---|---|---|---|
| 기본 | variant의 기본 배경·테두리·텍스트 | 활성화 | axe 및 DOM |
| hover | `fill-hover` | 포인터 입력에만 의존하지 않음 | CSS 상태 |
| active/pressed | `fill-pressed` | 클릭·키보드 실행 시 제공 | 마우스·Enter·Space |
| focus | 포커스 표시 | 키보드 사용자가 현재 위치를 식별 가능 | Tab 이동 |
| disabled | disabled용 배경·테두리·텍스트 | 실행·탐색·제출 모두 차단 | button/link 각각 확인 |
| loading | HANUI 확장 상태 | 중복 요청 차단, `aria-busy="true"` | 클릭 재실행 및 이름 확인 |
| 고대비 | KRDS 고대비 모드 대응 | 색상만으로 상태를 전달하지 않음 | 고대비 모드·명도 검토 |

## 5. 접근성·API 계약

- 버튼 텍스트 또는 `aria-label`/sr-only 이름이 있어야 한다.
- 아이콘이 텍스트를 대체하는 경우 아이콘 자체는 `aria-hidden="true"`로 처리하고 버튼 이름은 별도로 제공한다.
- 일반 동작은 `<button>`을 사용하고, 페이지 이동은 `<a href>`를 사용한다. `role="button"`으로 의미를 흉내 내지 않는다.
- `<button>`의 `type` 기본값은 `button`으로 고정한다.
- disabled 링크는 `href`를 제거하고, `aria-disabled`를 제공하며, 클릭 이벤트도 차단한다.
- `loading`은 disabled 동작을 포함하고 `aria-busy="true"`를 제공한다. 로더만 남겨 accessible name을 잃지 않는다.
- 서버 작업 버튼은 처리 중 재요청을 막되, 오류 시 다시 시도할 수 있어야 한다.

## 6. 현재 구현과의 차이

현재 `repos/hanui/packages/vue/src/components/Button.vue`는 primary·secondary·tertiary와 기존 별칭, `xs`~`xl` 및 `icon`을 제공한다. KRDS 기준과 비교하면 다음 전환이 필요하다.

1. `xsmall`·`small`·`medium`·`large`·`xlarge`를 canonical size로 추가한다.
2. `text`·`link` variant를 추가한다.
3. 기존 `xs`·`sm`·`md`·`lg`·`xl`과 비-KRDS variant의 호환 정책을 정하고 테스트한다.
4. Tailwind 클래스 중심 스타일을 중앙 CSS 변수·Button CSS로 옮긴다.
5. icon-only 이름, 링크 disabled, loading 중복 실행, `type` 기본값을 회귀 테스트에 명시한다.

## 근거 파일

- `reference/krds-uiux/html/code/button.html`
- `reference/krds-uiux/html/code/button_hierarchy.html`
- `reference/krds-uiux/html/code/button_size.html`
- `reference/krds-uiux/html/code/button_with_icon.html`
- `reference/krds-uiux/html/code/button_icon.html`
- `reference/krds-uiux/html/code/button_text.html`
- `reference/krds-uiux/resources/scss/component/_button.scss`
