# 로컬 작업 공간 이전

2026-09-21 · 로컬 복사 및 무결성 검증 완료.

- 새 작업 경로: `/Users/mia/github/hanui`
- 이전 경로: `/Users/mia/Library/Mobile Documents/com~apple~CloudDocs/odada/00-github/hanui`
- 기존 `/Users/mia/github/hanui-이건뭐지?` 폴더는 변경하지 않음.
- 소스·문서·미커밋 수정·Git 이력·로컬 설정을 복사. 기존 React 삭제 상태도 그대로 보존.
- 원본 5,189개 파일의 SHA-256 또는 심볼릭 링크 대상을 대조하여 불일치 0건 확인.
- `node_modules`, `.next`, `.turbo`는 원본 복사에서 제외. 생성물 `dist`와 기타 자료는 보존.
- Vue 패키지에 한해 임시 검증 환경에서 설치한 로컬 node_modules를 복사. 다른 앱의 의존성은 아직 설치하지 않음.
- Vue 의존성은 기존 pnpm lock 그대로가 아니라 package.json 허용 범위로 설치한 검증 환경임. 정확한 버전은 `verification/vue-2026-09-21/package-lock.json`에 기록.
- iCloud 원본은 안전한 전환을 위해 보존. 이후 작업은 로컬 경로를 기준으로 하며 원본은 자동 동기화되지 않음.
- 이 기록과 공지 화면 설계·컴포넌트 목록은 해시 대조 후 로컬 복사본에 추가한 문서임.

## 재개 방법

Codex에서 `/Users/mia/github/hanui`를 프로젝트로 열고 새 작업 경로에서 이어간다. 기존 대화의 기본 작업 경로와 파일 쓰기 권한은 자동으로 바뀌지 않는다.

Vue 검증은 `hanui/packages/vue`에서 `npm test`, `npm run typecheck`, `npm run build`로 실행할 수 있다. 전체 워크스페이스 의존성을 다시 설치하기 전에 React 패키지 삭제 상태를 먼저 확인한다.

소스 무결성 결과는 [이전 검증 기록](verification/local-migration.json)에 보관한다. 기존 iCloud 폴더 삭제와 기존 다른 로컬 HANUI 폴더 정리는 수행하지 않았다.
