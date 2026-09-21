# 여기서 이어서 작업하세요

인계일: 2026-09-21

## 사용자 요청

> 정부·공공기관 입찰에 참여해서 KRDS와 웹접근성을 충족하는 CMS를 만들어 판매하고 싶다. 첫 대상은 소규모 공공기관 대표 홈페이지다. 기존 Vue 컴포넌트가 제대로 만들어졌는지 먼저 확인하고, 확인한 결함을 고친 뒤 CMS 작업을 이어가자. 매 단계마다 물어보지 말고 가능한 작업은 계속 진행해 달라.

일상적인 구현 선택·점검·수정은 자율 진행한다. 사업 범위나 큰 전환 방향이 미확정인 부분은 문서에서 구분하고, 기존 작업을 지우거나 임의로 완료 처리하지 않는다.

## 작업 위치 — 중요

**지금부터 사용할 경로는 `/Users/mia/github/hanui`다.**

이 폴더는 독립 저장소 여러 개를 묶은 작업 공간이다. 상위 자체는 Git 저장소가 아니다.

| 하위 폴더 | 역할 |
| --- | --- |
| `hanui` | KRDS 기반 React·Vue 컴포넌트, CLI, 문서 사이트 |
| `hanui-cms` | 기관 공개 홈페이지·관리자·Java 백엔드. 현재 프론트 구현은 Next.js·React |
| `krds-checker` | KRDS 검수 대응용 점검 도구. **이름 그대로 유지하기로 사용자 결정** |
| `project-notes` | 사업 의도·기술 결정·설계·체크리스트·진행 기록 |
| `claude-settings` | 개발 커맨드·훅·에이전트 설정 저장소 |
| `edudata-contest`, `blog-topics` | 별도 기획·로컬 블로그 자료 |

기존 iCloud 경로는 `/Users/mia/Library/Mobile Documents/com~apple~CloudDocs/odada/00-github/hanui`다. 안전을 위해 원본을 남겼으며 이후 자동 동기화하지 않는다. 기존 로컬 `hanui-이건뭐지?` 폴더도 별개다. 두 폴더를 혼동하거나 삭제하지 않는다.

소스·Git 이력·미커밋 변경 등 5,189개 파일을 복사하고 해시/링크 대상 불일치 0건을 확인했다. `node_modules`, `.next`, `.turbo`는 원본 복사에서 제외했다. 자세한 기록은 [로컬 이전](project-notes/local-migration.md)을 참고한다.

## 제품 의도와 결정

- HANUI 컴포넌트로 표준에 맞게 구축 → CMS로 담당자가 운영 → Checker로 실제 결과물을 점검하는 사업 흐름이다.
- **백엔드는 전자정부 표준프레임워크 v5 사용 확정.** 공식 출처는 https://github.com/orgs/eGovFramework/repositories 이며 구체적인 릴리스·JDK·Spring Boot 호환 버전은 아직 검증 전이다.
- **Vue 중심 개발을 선호한다.** 프로젝트마다 참여자가 달라지고 학습 시간이 부족하므로 협업자의 친숙도와 일관된 개발 패턴을 중시한다. React·Vue 동시 유지로 완성도가 떨어질 것을 우려한다.
- Vue 전체 전환 범위, 앱 구성·배포 방식은 아직 미확정이다. 기존 React CMS를 이미 이식했다고 판단하지 않는다.
- 첫 제품 범위·검수 기준·사이트맵·권한·공지 화면은 초안이 있다. 문서 작성과 실제 기능 완료는 구분한다.
- KRDS 자체 검사·내부 출고 기준·기관 검수·외부 웹접근성 인증은 별개다. 테스트 통과를 인증·전체 준수로 표현하지 않는다.

## 먼저 읽을 문서

1. [프로젝트 기록 목차](project-notes/README.md)
2. [사업 목적](project-notes/vision.md), [기술 선택](project-notes/decisions.md)
3. [Vue 1차 점검 결과](project-notes/vue-audit.md), [할 일](project-notes/tasks.md)
4. [첫 납품 범위](project-notes/first-delivery.md), [사이트맵·권한](project-notes/sitemap-and-permissions.md)
5. [공지 화면 설계](project-notes/notice-wireframes.md), [컴포넌트 체크리스트](project-notes/component-checklist.md)

각 저장소의 지침과 실제 Git 상태도 확인한다. 기존 `CLAUDE.md` 일부 기술 스택 설명은 템플릿이므로 실제 패키지 설정과 위 결정 기록을 우선 대조한다.

## 지금까지 실제로 한 작업

Vue 기본 구현 파일 125개와 기존 테스트를 확인했다. React 기본 구현은 78개 파일이다. Vue는 하위 구성 요소가 별도 파일이므로 숫자를 기능 개수로 직접 비교하지 않는다.

`hanui/packages/vue`에서 다음을 수정했다.

- Input의 실제 입력 요소로 id/name/required/aria 속성 전달, readonly 지우기 차단, 보조 버튼 키보드 접근·비활성 상태.
- Select의 방향키·Home/End·문자 검색·선택·닫기·외부 클릭, 레이블과 활성 옵션 연결.
- Modal의 초기 open 초점 설정·스크롤 잠금·복원, 중첩 모달 처리·Tab 순환.
- Button의 비활성 링크 동작 차단, Table 속성 전달, TableHead 정렬 버튼·aria-sort.
- Pagination의 숫자 입력 오류·소수 페이지 검증·빈 목록과 로딩 중 이동 처리.
- Checkbox/Select ID를 useId로 정리. 기존 FormField도 useId를 사용하므로 Vue peer 최소 버전을 3.5로 정정.
- 타입 검사 스크립트, axe assertion 타입, 빌드 전 타입 검사, CSS/CJS 산출 경로와 선언 파일 대상 정리.
- 신규 `cms-regressions.test.ts` 회귀 테스트 16개 작성.

**검증: 테스트 37개 파일·309개 통과, 타입 검사 통과, Vite 빌드 성공.**

검증은 iCloud 의존성의 dataless 읽기 지연을 피하려고 `/tmp/hanui-vue-audit`에 소스와 설정을 복사해 수행했다. package.json 허용 범위로 새로 설치한 의존성이며 원래 pnpm 잠금 버전 그대로는 아니다. 그 node_modules를 로컬 `hanui/packages/vue/node_modules`에 복사했다. 다른 앱의 의존성은 아직 준비하지 않았다.

검증 당시 Node 26.7.0, Vue 3.5.43, Vitest 4.1.11, Vite 6.4.3. 정확한 잠금과 로그는 `project-notes/verification/vue-2026-09-21`에 있다. `/tmp`가 삭제돼도 기록은 남도록 복사했다.

로컬 Vue 폴더에서 `npm test`, `npm run typecheck`, `npm run build`로 재검증 가능하다. 현재 `dist`는 원본에 있던 생성물을 복사한 것이므로 수정 후 빌드 결과라고 가정하지 않는다. 검증한 새 빌드 출력은 임시 검증 폴더에서 생성했다.

## 꼭 보존할 기존 상태

React 패키지의 `package.json`, `src/variables.css`, `tailwind.preset.ts`, `README.md`, `LICENSE`가 처음부터 Git 삭제 상태였다. 이유 미확인이므로 자동 복원하지 않았다. 전체 워크스페이스 설치 전에 이 상태를 확인한다.

CMS에도 기존 미커밋 변경이 있다(페이지 편집 화면 포함). 해당 변경과 새 수정 내용을 구분하며 덮어쓰지 않는다. 이번 작업은 커밋·푸시·배포하지 않았다.

## 이어서 할 일 — 권장 순서

1. 로컬 Git 상태와 Vue 실행 환경을 확인하고 재현 가능한 의존성 설치 방식을 정리한다. 기존 검증을 이유 없이 반복하기보다 환경 변경·새 수정에 필요한 검사를 수행한다.
2. **Vue 스타일 토큰·Tailwind 프리셋 경로부터 점검한다.** 현재 CSS 산출물은 전환 효과 위주이며 전체 KRDS 테마를 제공하는 상태가 아니다.
3. FormField와 Input/Select의 연결, Checkbox의 폼 참여·속성 전달, 모달 외부 inert 처리, 실제 브라우저 키보드·초점·스크린리더·대비를 검증한다.
4. Vue의 문서·CLI·export 대응과 실제 lint 설정을 정리한다. 전체 125개 파일이 검증된 것은 아니다.
5. Node 직접 ESM/CJS import에서 Swiper CSS 로더 오류가 있었다. 실제 사용할 번들러·SSR 경로를 확인하고 패키지 소비 검증을 진행한다.
6. 공지 목록·작성·상세 설계에 필요한 검증된 Vue 컴포넌트로 첫 화면을 구현한다. Vue 앱 구성은 기존 저장소·기획을 검토해 근거를 남긴다.
7. 기존 Java 소스·빌드 설정을 점검하고 전자정부프레임워크 v5 기반 인증·권한·공지 API와 DB를 연결한다. 첫 흐름은 **초안 저장 → 권한 있는 미리보기 → 게시 → 공개 목록·상세**다.

기본 권한은 기관 관리자·콘텐츠 담당자 두 가지, 담당자는 사이트 내 콘텐츠 공동 관리다. 수정 초안 저장만으로 기존 게시본을 바꾸지 않고, 휴지통 복원은 초안으로 처리한다. 상세 정책은 사이트맵 문서를 기준으로 한다.

작업이 진행될 때 `project-notes/tasks.md`와 관련 점검·결정 문서를 갱신한다. 추가 질문이 없어도 확인 가능한 점검·수정·설계는 자율적으로 이어간다.

## 작업 모델 및 검증 운영 원칙

- 작업 속도를 위해 Luna Light를 기본 모델로 사용한다.
- 각 단계마다 타입 검사·테스트·빌드·필요한 브라우저 및 접근성 검증을 실행한다.
- 검증이 통과하지 않으면 완료 또는 OK로 표시하지 않는다.
- 설계·기술 선택, 접근성·보안·권한, 대규모 구조 변경, 복합 실패 원인 추적, 최종 품질·출고 판정에서는 더 강한 모델의 독립 검토가 필요하다고 사용자에게 알린다.
- 모델 변경 자체를 품질 보증으로 간주하지 않고, 실행 가능한 검증 결과와 코드 검토 근거를 함께 확인한다.

## 추가 확정 사항 · v0 CMS와 KRDS 적용

- 첫 목표는 공공기관 대표 홈페이지 CMS v0이다.
- 전체 컴포넌트를 먼저 전환하지 않고, 로그인·관리자 레이아웃·공지 작성/수정·미리보기·게시·공개 목록/상세의 세로 흐름을 먼저 완성한다.
- 우선 검증 컴포넌트는 Button, Input, Textarea, Select, FormField, Table, Pagination, Modal, Alert/Toast, Card, Header, SideNavigation, Breadcrumb이다.
- 스타일은 중앙 CSS와 CSS 변수로 관리한다. 컴포넌트별 scoped 스타일이나 Tailwind 클래스에 핵심 스타일을 분산하지 않는다.
- KRDS 공식 저장소를 `reference/krds-uiux`에 클론했다. KRDS 원본은 구조·상태·토큰·접근성 대조 기준으로 사용하고, Vue 동작과 CMS 상태를 포함해 재작성한다.
- 현재 모델이 구현하고 자동·브라우저 검증을 수행한 뒤, 더 강한 모델이 독립 검토한다. 지적 사항 수정과 재검증 전에는 OK로 기록하지 않는다.
