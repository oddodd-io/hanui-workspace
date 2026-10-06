# 2000n 구축 테스트 — 집에서 이어 하기 (2026-10-06)

목표: 사용자의 옛 사이트 `2000n-main`(이천시동행누리센터)을 hanui CMS로 "실제 사용 가능한 수준(시연)"까지 옮기면서, 판매용 "퍼블리싱 HTML 구성 가이드"를 함께 완성한다.
원칙: **틀(헤더·주메뉴·사이드 메뉴·푸터)은 KRDS 그대로, 내용만 2000n** — 이 CMS의 강점은 KRDS + 웹접근성. 사용자가 직접 CMS를 써 보며 시험한다.

관련: [decisions.md](../decisions.md) 2026-10-06 항목들, 퍼블리싱 가이드 `repos/hanui-vue-cms/docs/publishing-guide.md`, [수동 확인 점검표](manual-checks-2026-10-02.md)

---

## ⚠️ 먼저 알아 둘 것 — mock은 메모리 저장

mock API는 데이터를 메모리에만 둔다. **집에서 mock을 새로 켜면 오늘 넣은 페이지·사이트 설정·메뉴는 모두 처음 상태로 돌아간다.** 아래 "다시 세팅" 순서대로 다시 넣으면 된다(10분 정도).

---

## 1. 켜는 순서

```bash
cd ~/github/hanui-workspace
git pull && git -C repos/hanui pull && git -C repos/hanui-vue-cms pull

# 라이브러리 빌드 (pull할 때마다)
cd repos/hanui && pnpm install && pnpm --filter @hanui/vue build

# CMS
cd ../hanui-vue-cms && pnpm install

# 터미널 3개
pnpm mock                                   # http://localhost:4010
NUXT_PUBLIC_THEME=2000n pnpm dev:public    # http://localhost:3300  (2000n 로고·푸터 링크, 틀은 KRDS)
pnpm dev:admin                              # http://localhost:3400  admin / admin1234!
```

- 3000번은 쓰지 않는다. 기본 KRDS 틀로 보려면 `pnpm dev:public`(테마 설정 없이).
- `2000n-site` 폴더(가져오기용 사본)는 `~/github/2000n-site`에 있다 — **git 저장소가 아니라 이 컴퓨터에만 있음.** 집 컴퓨터에 없으면 아래 "2000n-site 다시 만들기" 참고.

---

## 2. 다시 세팅 (mock을 새로 켰을 때)

### 2-1. 본문 CSS 넣기 — 아직 안 함, 오늘 할 차례

```bash
cd ~/github/hanui-workspace/repos/hanui-vue-cms
pnpm site-css ~/github/2000n-main/dist/css/contents.css ~/github/2000n-main/dist/css/comm.css --rem-base 15 --strip .contents
mkdir -p apps/public/public/site && cp -R ~/github/2000n-main/images apps/public/public/site/images
```

- `packages/site-config/src/site.css`의 "가져온 CSS" 구역이 채워진다(다시 실행해도 그 구역만 바뀜). 맨 아래 "직접 쓴 보정"(조직도·이용 순서·앱 설치 순서 반응형)은 그대로.
- 명령이 출력하는 이미지 목록이 `apps/public/public/site/` 아래에 있는지 확인.
- **CSS를 먼저 넣고 나서** 사이트 가져오기를 해야 원본 클래스가 남는다(클래스 정리 목록에서 site.css에 있는 클래스는 자동 "남김").

### 2-2. 사이트 설정 (관리자 > 환경설정)

| 칸 | 값 |
| --- | --- |
| 기관명 | 이천시동행누리센터 |
| 로고 | `~/github/2000n-main/images/comm/logo.png` 올리기 (없으면 테마 기본 로고) |
| 주소 | (17380) 경기도 이천시 경충대로 2603 (이천시 중리동 111-1) |
| 대표전화 | 1899-0017 |
| 운영시간 안내 | 상담 09:00~18:00 |
| 팩스 | 031-631-0461 |
| 저작권 문구 | Copyright ⓒ 2014 ICHEON CITY. All Rights Reserved. |
| 외부 이미지 가져오기 도메인 | (필요 없음 — 이미지는 폴더째 올림) |

### 2-3. 사이트 가져오기 (관리자 > 내용관리 > 사이트 가져오기)

1. **[폴더 고르기]** → `~/github/2000n-site`
2. 묶음 3개 확인: **센터소개(4) · 이용안내(4) · 기타(4)**, 주소 앞 경로 `center` · `guide` · `policy` 자동
3. **기타 묶음은 "메뉴 분류로 연결" 끄기**(정책 페이지는 푸터 링크)
4. "원본 디자인 클래스" — 2-1을 했다면 대부분 "남김"으로 체크돼 있음. 그대로 두면 2000n 본문 모양, 지우면 KRDS 기본 모양
5. **가져오기** → 결과에서 **검사 통과 N개 한 번에 게시**
   - `policy/privacy`·`policy/copyright`는 CMS 샘플과 주소가 같아 "업데이트"로 표시 — 그대로 진행

### 2-4. 메뉴 정리 (관리자 > 메뉴설정)

오늘 최종 상태: **센터소개(4) · 이용안내(4) · 열린광장(공지사항)**

- 샘플 분류 **기관안내·사업안내는 "분류 빼기"**(페이지는 남음)
- **알림마당 → 이름을 "열린광장"으로**, 항목은 공지사항만(자료실 빼기)
- 사이트 가져오기에서 메뉴 연결을 켰다면 센터소개·이용안내 분류가 이미 생겨 있음
- 저장 후 오른쪽 "방문자에게 보이는 메뉴"로 확인

### 2-5. 확인할 화면

- http://localhost:3300/center/intro · /center/history(표·조직도) · /guide/app(앱 설치 카드) · /policy/privacy
- 관리자 미리보기도 공개 화면과 같은 본문 모양인지(관리자도 site.css를 불러옴)

---

## 3. 오늘까지 한 것 (CMS 쪽)

- 사이트 가져오기: 폴더째(HTML·이미지 자동 구분), 묶음 인식(왼쪽 메뉴), **폴더·파일 앞 번호 = 순서**(`01-center/02-history.html`, 주소에서 번호 빠짐), 같은 주소는 본문 업데이트, 미리보기, 자동 고치기(제목 단계 맞추기 포함), 페이지 사이 링크를 새 주소로, 묶음별 나눠 가져오기, 실패한 것만 다시, 원본 클래스 정리(site.css 클래스 자동 남김, blind → sr-only), 한 번에 게시
- 테마 세 단계: `krds` / `2000n`(KRDS 그대로 + 로고·푸터 링크) / `2000n-custom`(완전 2000n 디자인, KRDS 미준수 — 영업용 예시)
- 본문 CSS 한 곳 `packages/site-config/src/site.css` + `pnpm site-css` 변환 명령

## 4. 다음 할 일

- [ ] 2-1 본문 CSS 넣고 다시 가져와서 2000n 본문 모양 확인 (사용자)
- [ ] 푸터 링크를 사이트 설정으로 옮기기 → 테마 설정(`themes/index.ts`)에서 2000n 이름 없애기 (Claude)
- [ ] ④ 게시판: 열린광장 — 공지사항(있음)·보도자료·분실물 / 묻고답하기·친절불친절 신고(방문자 글쓰기·답변 — 기능 없음)·팝업존(기능 없음) 처리 방식 결정
- [ ] ⑥ 첫 화면 관리: 메인 비주얼(슬라이드, 접근성 맞춤)·배너·최근 글·바로가기
- [ ] 예약·회원(s3xx·s5xx): 1차 범위 밖 — 전화·외부 링크 안내 페이지로 대신
- [ ] 판매용 "퍼블리싱 HTML 구성 가이드" 마무리 (퍼블리싱 가이드를 2000n 경험으로 보완)

---

## 부록: 2000n-site 다시 만들기 (집 컴퓨터에 없을 때)

`2000n-main`에서 아래처럼 복사·이름 변경 (원본은 그대로 둠). 앞 번호는 순서, 주소에서는 빠짐.

```bash
cd ~/github && mkdir -p 2000n-site/{01-center,02-guide,09-policy} && cp -R 2000n-main/images 2000n-site/images
M=2000n-main; S=2000n-site
cp $M/s101.html $S/01-center/01-intro.html;    cp $M/s102.html $S/01-center/02-history.html
cp $M/s103.html $S/01-center/03-sites.html;    cp $M/s104.html $S/01-center/04-location.html
cp $M/s201.html $S/02-guide/01-usage.html;     cp $M/s202.html $S/02-guide/02-vehicles.html
cp $M/s203.html $S/02-guide/03-online-booking.html; cp $M/s204.html $S/02-guide/04-app.html
cp $M/s602.html $S/09-policy/01-terms.html;    cp $M/s603.html $S/09-policy/02-privacy.html
cp $M/s604.html $S/09-policy/03-copyright.html; cp $M/s605.html $S/09-policy/04-no-email.html
# s201은 왼쪽 메뉴 글자가 "고객앱이용안내"로 잘못돼 있어 제목 표시를 붙임 (92번째 줄 페이지 제목)
sed -i '' '92s|<h2>이용안내</h2>|<h2 data-cms-title>이용안내</h2>|' $S/02-guide/01-usage.html
```

넣지 않는 것: index(첫 화면), s301·s302(예약), s401~s406(게시판), s501~s504(회원), s601(사이트맵 — CMS 자동), !list, s503_test.
