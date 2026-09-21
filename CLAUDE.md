# HANUI 연관 프로젝트 작업 공간

정부·공공기관 입찰을 위한 KRDS·웹접근성 기반 웹 구축 사업이다. HANUI(공통 컴포넌트), HANUI CMS(구축·운영), KRDS Checker(준수 점검·검수 대응)를 함께 개발한다.

사업 목적과 저장소 관계는 [README.md](README.md)를 먼저 참고한다. 이 폴더는 여러 독립 저장소를 묶은 작업 공간이며, 아래 공통 지침보다 각 저장소의 실제 설정과 해당 지침을 우선 확인한다.

## 프로젝트 기록 관리

- 작업 재개 시 [project-notes](project-notes/README.md)의 의도·기술 선택·할 일을 먼저 확인한다.
- 중요한 방향 논의는 `decisions.md`, 작업 상태와 검증 결과는 `tasks.md`에 갱신한다.
- 사용자의 현장 경험, 확인된 사실, 제안, 확정 결정을 구분하고 미실행 검사를 완료 처리하지 않는다.

## Tech Stack

- **Language**: TypeScript
- **Framework**: Next.js 15 (App Router)
- **Styling**: Tailwind CSS v4
- **Package Manager**: pnpm
- **Node Version**: 22+

## Commands

```bash
pnpm dev          # 개발 서버
pnpm build        # 프로덕션 빌드
pnpm lint         # ESLint
pnpm test         # 테스트 실행
pnpm test:watch   # 테스트 워치 모드
```

## Project Structure

```
src/
├── app/           # Next.js App Router 페이지
├── components/    # 공통 컴포넌트
│   └── ui/        # 기본 UI 컴포넌트 (Button, Input 등)
├── hooks/         # 커스텀 훅
├── lib/           # 유틸리티, API 클라이언트
├── types/         # 공통 타입 정의
└── styles/        # 글로벌 스타일
```

## Conventions

### 코드 스타일

- 함수 컴포넌트 + arrow function 사용
- Props는 명시적 interface로 정의 (`type`보다 `interface` 선호)
- 파일명: kebab-case (`user-profile.tsx`)
- 컴포넌트명: PascalCase (`UserProfile`)
- 훅: camelCase with `use` prefix (`useAuth`)

### Git

- 브랜치: `feat/`, `fix/`, `refactor/`, `chore/` 접두사
- 커밋: Conventional Commits 형식, 한 줄, 한국어 OK
- main 브랜치 직접 커밋 허용

### 테스트

- 테스트 프레임워크: Vitest
- 파일 위치: 소스 파일 옆 (`*.test.ts`)
- 테스트 설명: 한국어로 작성
- mocking 최소화, 실제 동작 테스트 우선

## Important Notes

- `.env.local`은 절대 커밋하지 않는다
- API 키, 시크릿은 환경 변수로만 관리
- 새 의존성 추가 시 번들 크기 영향 확인
