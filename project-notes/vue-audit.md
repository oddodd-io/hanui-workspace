# Vue 컴포넌트 1차 점검

2026-09-21 · 핵심 CMS 컴포넌트 코드 수정 및 임시 로컬 환경 검증 완료. 전체 KRDS·웹접근성 적합 판정은 아님.

## 환경과 검증 결과

원본 iCloud 내 `node_modules/vue/dist/vue.cjs.js`에서 `dataless` 상태를 확인했다. 의존성 로딩이 지연돼 `/tmp/hanui-vue-audit`에 소스와 설정을 복사하고 package.json 허용 범위의 의존성을 새로 설치했다. 기존 pnpm 잠금 버전 그대로의 검증은 아니며 원본 node_modules와 잠금 파일은 변경하지 않았다.

- Node 26.7.0, Vitest 4.1.11, Vite 6.4.3. 정확한 임시 의존성은 증빙 폴더의 package-lock.json 참조.
- 전체 테스트: 37개 파일, 311개 테스트 통과(Checkbox 폼 및 FormField 연결 회귀 검증 포함).
- `vue-tsc --noEmit`: 오류 없이 통과.
- Vite 빌드: 성공. 공개 CSS 경로 `dist/vue.css`와 CJS 진입점 `dist/index.cjs` 생성 확인.
- jsdom은 canvas를 지원하지 않아 axe 검사 중 관련 경고가 있다. 색상 대비·시각 검증·실제 키보드 동작·보조기기 검증을 대체하지 않는다.

## 수정 사항

| 대상 | 확인한 문제와 조치 |
| --- | --- |
| Input | id·name·required·aria 속성을 입력칸으로 전달. 읽기 전용 지우기 차단, 보조 버튼 Tab 접근·disabled 반영 |
| Select | 미등록 외부 클릭 지시자 제거. 방향키·Home/End·문자 검색·선택·Tab/Escape 닫기, 레이블·활성 옵션 연결 |
| Modal | 초기 open 상태의 초점·스크롤 잠금, 닫기·해제 시 이전 상태 복원, 중첩 모달 최상단 처리와 Tab 순환 |
| Button | disabled/loading 링크의 이동과 클릭 실행 차단 |
| Table/TableHead | 실제 table에 접근성 속성 전달. 정렬을 네이티브 버튼으로 변경하고 aria-sort 제공 |
| Pagination | 숫자 v-model 값에 trim 호출하던 오류, 소수 페이지 허용, 빈 목록 이동·로딩 중 이동 문제 수정 |
| Checkbox/Select | useId 기반 ID로 변경. 기존 FormField도 useId를 사용하므로 Vue peer 최소 버전을 3.5로 정정 |
| Checkbox (후속) | 버튼 모조 체크박스를 네이티브 `input[type=checkbox]`로 변경해 name/value/required/aria 속성, 폼 유효성·FormData 참여, label 연결을 보장 |
| 테스트 실행성 (후속) | 패키지 Vite/Vitest 설정에서 워크스페이스 루트 PostCSS 자동 탐색을 끄고, 앱의 Tailwind/PostCSS를 소비자 책임으로 분리 |
| FormField 연결 (후속) | FormField 컨텍스트의 id·helper/error 설명 ID를 Input·Select의 실제 입력/combobox에 연결하고 회귀 테스트 추가 |
| 스타일 토큰 (후속) | Vue 패키지에 기본 KRDS CSS 변수 파일을 추가하고 `styles.css` 산출물에 포함. CLI의 전체 Tailwind 프리셋을 대체하는 완성 테마는 아님 |
| 검증·패키징 | axe assertion 타입 보강, typecheck 스크립트 및 빌드 전 타입 검사, dts에서 테스트 제외, CSS·CJS 출력 경로 정정 |

## 남은 점검

- 로컬 이전 후 기존 pnpm 잠금 버전으로 의존성 복구·재검증.
- Vue 패키지 기본 KRDS 토큰·Tailwind 프리셋 제공 경로 정리. 현재 CSS 출력은 전환 효과 위주이며 전체 테마를 포함하지 않음.
- FormField와 입력 컨트롤의 자동 연결 여부, Checkbox의 native form 참여·속성 전달 확인.
- 모달 외부 콘텐츠의 inert 처리와 실제 스크린리더·중첩 화면 사용 검증.
- 전체 125개 Vue 파일의 상태·문서·CLI 대응 및 다른 대화상자/메뉴 구현 점검.
- 실제 브라우저에서 Select 옵션 탐색·스크롤·조합키·모바일 조작 확인.
- lint는 기존 TODO 상태. 실제 Vue lint 구성 필요.
- [공지 화면 와이어프레임·필드 정의](notice-wireframes.md) 초안 작성 완료. 실제 화면 구현은 다음 단계.
- Node 직접 ESM/CJS import 점검에서 Swiper CSS 로더 부재 오류 확인. 번들러 없이 Node가 직접 읽는 경로 및 SSR 사용 경로는 별도 검증·정리가 필요.

## 2026-09-21 후속 검증

- 로컬 패키지에서 `npm test`: 37개 파일, 311개 테스트 통과.
- `npm run typecheck`: 통과.
- `npm run build`: Vite 산출물(`dist/vue.css`, `dist/index.mjs`, `dist/index.cjs`) 생성 성공.
- `dist/vue.css`에 Vue 패키지 기본 CSS 변수 포함 확인. CLI의 `variables.css`·Tailwind 프리셋과 토큰 중복은 다음 점검 대상이다.
- CLI와 패키지의 역할을 분리했다. 패키지는 소비자가 바로 import할 baseline 토큰·컴포넌트 CSS를 제공하고, CLI는 Tailwind v3/v4 프로젝트 설정과 전체 토큰을 생성한다. 두 경로가 서로의 Tailwind 설정을 덮어쓰지 않는다.
- CLI 의존성 설치 후 `npm run build` 성공. 임시 프로젝트에서 `init --yes`로 `hanui.json`, `src/styles/variables.css`, `hanui.preset.js`, `src/lib/utils.ts` 생성과 Tailwind v3 설정 갱신을 확인했다. 자동 의존성 설치는 로컬 `sysmond service not found` 메시지 이후 완료 여부를 확인하지 못했다.
- jsdom의 canvas·pseudo-element 경고는 남아 있으며 시각 대비·실제 브라우저/보조기기 검증을 대신하지 않는다.

React 기존 삭제 파일은 복원하지 않았다. 제품 배포·게시·커밋은 하지 않았다.
