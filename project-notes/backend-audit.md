# CMS 백엔드 초기 점검

2026-09-21 · 기존 `hanui-cms/apps/backend` 소스의 구조와 빌드 상태를 확인했다. 구현 완료나 전자정부 표준프레임워크 v5 적용 완료로 간주하지 않는다.

## 확인된 상태

- Java 소스는 Spring MVC·Spring Security·MyBatis·Jakarta Validation·Lombok·OpenAPI 어노테이션을 사용한다.
- `Page`, `PageVersion`, `Post`, `Media`, `Menu`, `User` 등의 엔티티와 서비스·컨트롤러·일부 MyBatis mapper가 있다.
- 현재 `apps/backend` 아래에서 `pom.xml`, `build.gradle`, Spring Boot 설정 파일을 찾지 못했다. 재현 가능한 빌드·실행·DB 연결은 미확인이다.
- 전자정부 표준프레임워크 v5 의존성·릴리스·JDK 조합은 아직 적용·검증되지 않았다.

## 우선 검토가 필요한 위험

- 공개 `GET /api/pages/{id}` 및 slug 조회가 삭제된 페이지, 초안, 게시 예정 상태를 제외하는지 코드상 계약이 없다.
- 작성자 ID를 `UserDetails.getUsername()`에서 바로 `Long.parseLong`한다. 실제 인증 주체 형식과 권한 경계가 확인되지 않았다.
- 페이지 수정·복원 API는 리비전과 게시 상태 정책이 공개 사이트 조회와 연결되는지 검증되지 않았다.
- API 응답에 내부 엔티티를 직접 사용하고 있어 공개 필드와 관리자 필드를 분리할 필요가 있다.

## 다음 검토 순서

1. 기존 인증 설정과 사용자 주체 형식 확인
2. 초안·게시·삭제·복원 상태를 포함한 페이지 데이터 모델과 공개 조회 계약 확정
3. 관리자/담당자 권한별 API 행위 표 작성
4. 전자정부 표준프레임워크 v5 기반 빌드 파일과 최소 실행 환경 구성
5. DB migration·MyBatis mapper·통합 테스트로 초안→미리보기→게시→공개 조회 흐름 검증

보안·권한·게시 상태는 최종 구현 전에 더 강한 모델의 독립 검토를 거친다. 실행 검증 전에는 OK로 기록하지 않는다.
