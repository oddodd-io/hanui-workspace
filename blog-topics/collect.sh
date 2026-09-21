#!/usr/bin/env bash
# 블로그 글감 수집기 (개인용 · 비공개)
#
#   ./collect.sh            어제~오늘
#   ./collect.sh 7          최근 7일
#   ./collect.sh 2026-08-01 2026-08-07
#
# ⚠️ 중요
# 이 스크립트의 출력은 "공개 가능한 문장"이 아닙니다.
# 내부 컴포넌트명·제품명 같은 고유명사는 패턴으로 지울 수 없기 때문에,
# 출력은 어디까지나 "그날 뭘 했는지 떠올리기 위한 개인 메모"입니다.
# 글감은 이 목록을 보고 **처음부터 다시 쓴** 일반적인 문장이어야 합니다.
#
# 위험해 보이는 줄에는 ⚠ 를 붙입니다. 그 줄은 특히 그대로 옮기지 마세요.

set -uo pipefail

# ─────────────────────────────────────────────────────────────
# 설정
# ─────────────────────────────────────────────────────────────
REPOS=(
  "/Users/odada/github/hanwha/healthpro-frontend|업무A"
  "/Users/odada/github/hanwha/hv-ui-components|업무B"
)

AUTHOR="${BLOG_TOPICS_AUTHOR:-}"   # BLOG_TOPICS_AUTHOR="odada" ./collect.sh

# ─────────────────────────────────────────────────────────────
# 기간
# ─────────────────────────────────────────────────────────────
if [ $# -eq 2 ]; then
  SINCE="$1"; UNTIL="$2"
elif [ $# -eq 1 ]; then
  SINCE=$(date -v-"$1"d +%Y-%m-%d 2>/dev/null || date -d "$1 days ago" +%Y-%m-%d)
  UNTIL=$(date +%Y-%m-%d)
else
  SINCE=$(date -v-1d +%Y-%m-%d 2>/dev/null || date -d "1 day ago" +%Y-%m-%d)
  UNTIL=$(date +%Y-%m-%d)
fi

# ─────────────────────────────────────────────────────────────
# 1차 세척: 확실히 지울 수 있는 것만
#   대소문자 무관 이슈키(PROJ-1234, cpd-7781, ap-005)
#   PR·이슈 번호, from org/branch
# ─────────────────────────────────────────────────────────────
scrub() {
  sed -E \
    -e 's/[A-Za-z][A-Za-z0-9]+-[0-9]+//g' \
    -e 's/\(#[0-9]+\)//g' \
    -e 's/#[0-9]+//g' \
    -e 's/ from [A-Za-z0-9_.-]+\/[A-Za-z0-9_./-]+//g' \
    -e 's/[[:space:]]+/ /g' \
    -e 's/^ //; s/ $//'
}

# ─────────────────────────────────────────────────────────────
# 2차 판정: 지울 수 없는 위험 신호를 "표시"만 한다
#   - CamelCase 고유명사 (내부 컴포넌트·화면명)
#   - 사람 이름 소유격 (Xxx's)
#   - 내부 코드네임처럼 보이는 하이픈 합성어
# ─────────────────────────────────────────────────────────────
risky() {
  local s="$1"
  printf '%s' "$s" | grep -qE '[A-Z][a-z]+[A-Z][A-Za-z]+' && return 0   # CamelCase
  printf '%s' "$s" | grep -qE "[A-Z][a-z]+'s"              && return 0   # 소유격 실명
  printf '%s' "$s" | grep -qiE '\b(copilot|review comment)' && return 0  # 리뷰 맥락
  return 1
}

is_noise() {
  local s="$1"
  case "$s" in
    Merge*|merge*|Revert*|revert*)      return 0 ;;
    *"update dependencies"*)            return 0 ;;
    *"version packages"*)               return 0 ;;
    *"version update"*|*"change version"*) return 0 ;;
    *bump*)                             return 0 ;;
    "")                                 return 0 ;;
  esac
  [ "${#s}" -lt 15 ] && return 0
  return 1
}

classify() {
  case "$1" in
    perf*)                              echo "성능" ;;
    *a11y*|*aria*|*focus*|*keyboard*)   echo "접근성" ;;
    refactor*)                          echo "구조" ;;
    test*)                              echo "테스트" ;;
    fix*)                               echo "버그·엣지케이스" ;;
    feat*)                              echo "기능" ;;
    docs*)                              echo "문서" ;;
    *)                                  echo "기타" ;;
  esac
}

# ─────────────────────────────────────────────────────────────
# 출력
# ─────────────────────────────────────────────────────────────
cat <<'HEADER'
# 글감 후보 (개인 메모 · 공개 금지)

> 이 파일은 **그대로 블로그에 쓰는 문장이 아닙니다.**
> 내부 고유명사는 자동으로 못 지웁니다. 아래를 보고 "무슨 문제였는지"만 기억한 뒤,
> 글감은 회사 맥락을 완전히 뺀 문장으로 **새로 쓰세요.**
>
> ⚠ 표시된 줄은 내부 이름·실명이 남아 있을 가능성이 높습니다.

HEADER
echo "기간: $SINCE ~ $UNTIL"
echo

total=0
risk=0

for entry in "${REPOS[@]}"; do
  path="${entry%%|*}"
  label="${entry##*|}"

  if [ ! -d "$path/.git" ]; then
    echo "_[$label] 저장소 없음 — 건너뜀_"; echo; continue
  fi

  args=(--no-merges --since="$SINCE" --until="$UNTIL 23:59:59" --date=short --format='%ad|%s')
  if [ -n "$AUTHOR" ]; then args+=(--author="$AUTHOR"); fi

  lines=$(git -C "$path" log "${args[@]}" 2>/dev/null || true)
  if [ -z "$lines" ]; then continue; fi

  echo "## $label"
  echo
  while IFS='|' read -r d subj; do
    if [ -z "${subj:-}" ]; then continue; fi
    clean=$(printf '%s' "$subj" | scrub)
    if is_noise "$clean"; then continue; fi
    tag=$(classify "$clean")
    if risky "$clean"; then
      printf -- '- [ ] `%s` **[%s]** ⚠ %s\n' "$d" "$tag" "$clean"
      risk=$((risk + 1))
    else
      printf -- '- [ ] `%s` **[%s]** %s\n' "$d" "$tag" "$clean"
    fi
    total=$((total + 1))
  done <<< "$lines"
  echo
done

echo "---"
if [ "$total" -eq 0 ]; then
  echo "_해당 기간엔 뽑을 게 없어요._"
else
  echo "총 ${total}건 (⚠ ${risk}건은 내부 이름 포함 가능)"
  echo
  echo "다음 단계: 쓸 만한 주제를 골라 **일반적인 문장으로 새로 써서** backlog.md 에 옮기세요."
  echo "예) 내부 모달 컴포넌트 분리 → \"거대해진 모달을 state/data/columns 훅으로 쪼갠 기준\""
fi
