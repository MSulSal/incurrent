#!/usr/bin/env bash
set -euo pipefail

PROJECT_TITLE="Incurrent - Distributed Counter Delivery"
MILESTONE="MVP"
LABELS_FILE="scripts/github/labels.json"
ISSUES_FILE="scripts/github/issues.json"
SKIP_PROJECT=0
DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: scripts/github/bootstrap-project.sh [options]

Options:
  --project-title <title>  Project board title
  --milestone <name>       Milestone name
  --labels-file <path>     Path to labels JSON file
  --issues-file <path>     Path to issues JSON file
  --skip-project           Skip project board create/find + item add
  --dry-run                Print actions without mutating GitHub state
  -h, --help               Show this help text
EOF
}

resolve_cmd() {
  local base="$1"
  if command -v "$base" >/dev/null 2>&1; then
    command -v "$base"
    return 0
  fi
  if command -v "${base}.exe" >/dev/null 2>&1; then
    command -v "${base}.exe"
    return 0
  fi
  return 1
}

to_python_path() {
  local path_value="$1"
  if command -v cygpath >/dev/null 2>&1; then
    cygpath -w "$path_value"
    return 0
  fi

  if [[ "$path_value" =~ ^/mnt/([A-Za-z])/(.*)$ ]]; then
    local drive="${BASH_REMATCH[1]}"
    local rest="${BASH_REMATCH[2]}"
    printf '%s:/%s\n' "${drive^^}" "$rest"
    return 0
  fi

  if [[ "$path_value" =~ ^/([A-Za-z])/(.*)$ ]]; then
    local drive="${BASH_REMATCH[1]}"
    local rest="${BASH_REMATCH[2]}"
    printf '%s:/%s\n' "${drive^^}" "$rest"
    return 0
  fi

  printf '%s\n' "$path_value"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project-title)
      PROJECT_TITLE="$2"
      shift 2
      ;;
    --milestone)
      MILESTONE="$2"
      shift 2
      ;;
    --labels-file)
      LABELS_FILE="$2"
      shift 2
      ;;
    --issues-file)
      ISSUES_FILE="$2"
      shift 2
      ;;
    --skip-project)
      SKIP_PROJECT=1
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
done

GH_BIN="$(resolve_cmd gh || true)"
PYTHON_BIN="$(resolve_cmd python || true)"
if [[ -z "$GH_BIN" ]]; then
  echo "Required command not found: gh (or gh.exe)" >&2
  exit 1
fi
if [[ -z "$PYTHON_BIN" ]]; then
  echo "Required command not found: python (or python.exe)" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd "$REPO_ROOT"

LABELS_PATH="$LABELS_FILE"
ISSUES_PATH="$ISSUES_FILE"
[[ "$LABELS_PATH" = /* ]] || LABELS_PATH="$REPO_ROOT/$LABELS_PATH"
[[ "$ISSUES_PATH" = /* ]] || ISSUES_PATH="$REPO_ROOT/$ISSUES_PATH"

if [[ ! -f "$LABELS_PATH" ]]; then
  echo "Labels file not found: $LABELS_PATH" >&2
  exit 1
fi
if [[ ! -f "$ISSUES_PATH" ]]; then
  echo "Issues file not found: $ISSUES_PATH" >&2
  exit 1
fi

LABELS_PATH_PY="$(to_python_path "$LABELS_PATH")"
ISSUES_PATH_PY="$(to_python_path "$ISSUES_PATH")"

echo "Checking GitHub authentication..."
if [[ "$DRY_RUN" -eq 0 ]]; then
  "$GH_BIN" auth status >/dev/null
fi

if [[ "$DRY_RUN" -eq 1 ]]; then
  REPO_FULL="owner/repo"
  OWNER="owner"
else
  REPO_FULL="$("$GH_BIN" repo view --json nameWithOwner -q .nameWithOwner)"
  OWNER="${REPO_FULL%%/*}"
fi

echo "Target repository: $REPO_FULL"

echo "Syncing labels..."
labels_rows="$(
  "$PYTHON_BIN" - "$LABELS_PATH_PY" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    labels = json.load(f)

for item in labels:
    name = str(item.get("name", "")).strip()
    color = str(item.get("color", "")).strip().lstrip("#")
    description = (
        str(item.get("description", ""))
        .replace("\r", "")
        .strip()
        .replace("\t", " ")
        .replace("\n", " ")
    )
    print(f"{name}\t{color}\t{description}")
PY
)"

while IFS=$'\t' read -r name color description; do
  [[ -n "$name" ]] || continue
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "  [dry-run] gh label create \"$name\" --color \"$color\" --description \"$description\" --force"
  else
    "$GH_BIN" label create "$name" --color "$color" --description "$description" --force >/dev/null
  fi
done <<< "$labels_rows"

echo "Ensuring milestone '$MILESTONE' exists..."
if [[ "$DRY_RUN" -eq 0 ]]; then
  milestone_number="$(
    "$GH_BIN" api "repos/$REPO_FULL/milestones?state=all" \
      --jq ".[] | select(.title == \"$MILESTONE\") | .number" | head -n1 || true
  )"
  if [[ -z "$milestone_number" ]]; then
    "$GH_BIN" api "repos/$REPO_FULL/milestones" --method POST -f "title=$MILESTONE" >/dev/null
    echo "  Created milestone: $MILESTONE"
  else
    echo "  Milestone already exists: $MILESTONE"
  fi
else
  echo "  [dry-run] would query/create milestone"
fi

PROJECT_NUMBER=""
PROJECT_URL=""
if [[ "$SKIP_PROJECT" -eq 0 ]]; then
  echo "Ensuring project '$PROJECT_TITLE' exists..."
  if [[ "$DRY_RUN" -eq 1 ]]; then
    PROJECT_NUMBER="999"
    PROJECT_URL="https://github.com/users/$OWNER/projects/999"
    echo "  [dry-run] would query/create project"
  else
    PROJECT_NUMBER="$(
      "$GH_BIN" project list --owner "$OWNER" --limit 100 --format json \
        --jq ".projects[] | select(.title == \"$PROJECT_TITLE\") | .number" | head -n1 || true
    )"
    if [[ -n "$PROJECT_NUMBER" ]]; then
      PROJECT_URL="$(
        "$GH_BIN" project list --owner "$OWNER" --limit 100 --format json \
          --jq ".projects[] | select(.title == \"$PROJECT_TITLE\") | .url" | head -n1
      )"
      echo "  Found existing project: $PROJECT_URL"
    else
      created_project="$("$GH_BIN" project create --owner "$OWNER" --title "$PROJECT_TITLE" --format json)"
      PROJECT_NUMBER="$(
        "$PYTHON_BIN" - <<'PY' "$created_project"
import json
import sys
print(json.loads(sys.argv[1])["number"])
PY
      )"
      PROJECT_URL="$(
        "$PYTHON_BIN" - <<'PY' "$created_project"
import json
import sys
print(json.loads(sys.argv[1])["url"])
PY
      )"
      echo "  Created project: $PROJECT_URL"
    fi
  fi
else
  echo "Skipping project creation per flag."
fi

created_count=0
existing_count=0
issue_records_file="$(mktemp)"
trap 'rm -f "$issue_records_file"' EXIT

echo "Syncing issues..."
issue_rows="$(
  "$PYTHON_BIN" - "$ISSUES_PATH_PY" "$MILESTONE" <<'PY'
import base64
import json
import sys

path = sys.argv[1]
default_milestone = sys.argv[2]

with open(path, encoding="utf-8") as f:
    issues = json.load(f)

for item in issues:
    key = str(item["key"]).replace("\r", "").strip().replace("\t", " ")
    title = str(item["title"]).replace("\r", "").strip().replace("\t", " ")
    milestone = str(item.get("milestone", default_milestone)).replace("\r", "").strip().replace("\t", " ")
    labels_csv = ",".join(item.get("labels", [])).replace("\r", "").strip().replace("\t", " ")
    body = str(item.get("body", ""))
    body_b64 = base64.b64encode(body.encode("utf-8")).decode("ascii")
    print(f"{key}\t{title}\t{milestone}\t{labels_csv}\t{body_b64}")
PY
)"

while IFS=$'\t' read -r key title issue_milestone labels_csv body_b64; do
  [[ -n "$key" ]] || continue
  body="$(
    "$PYTHON_BIN" - "$body_b64" <<'PY'
import base64
import sys
print(base64.b64decode(sys.argv[1]).decode("utf-8"), end="")
PY
  )"

  if [[ "$DRY_RUN" -eq 1 ]]; then
    issue_url="https://github.com/$REPO_FULL/issues/0"
    echo "  [dry-run] would ensure issue: $key - $title"
    ((created_count+=1))
  else
    existing_url="$(
      "$GH_BIN" issue list --state all --search "$title in:title" --limit 100 --json title,url \
        --jq ".[] | select(.title == \"$title\") | .url" | head -n1 || true
    )"
    if [[ -n "$existing_url" ]]; then
      issue_url="$existing_url"
      echo "  Existing: $key -> $issue_url"
      ((existing_count+=1))
    else
      if [[ -n "$labels_csv" ]]; then
        issue_url="$("$GH_BIN" issue create --title "$title" --body "$body" --milestone "$issue_milestone" --label "$labels_csv")"
      else
        issue_url="$("$GH_BIN" issue create --title "$title" --body "$body" --milestone "$issue_milestone")"
      fi
      echo "  Created: $key -> $issue_url"
      ((created_count+=1))
    fi
  fi

  printf '%s\t%s\n' "$key" "$issue_url" >>"$issue_records_file"
done <<< "$issue_rows"

if [[ "$SKIP_PROJECT" -eq 0 && -n "$PROJECT_NUMBER" ]]; then
  echo "Adding issues to project #$PROJECT_NUMBER..."
  while IFS=$'\t' read -r key issue_url; do
    if [[ "$DRY_RUN" -eq 1 ]]; then
      echo "  [dry-run] gh project item-add $PROJECT_NUMBER --owner $OWNER --url $issue_url"
      continue
    fi

    if "$GH_BIN" project item-add "$PROJECT_NUMBER" --owner "$OWNER" --url "$issue_url" >/dev/null 2>&1; then
      echo "  Added: $key"
    else
      echo "  Skipped (already added or unavailable): $key"
    fi
  done <"$issue_records_file"
fi

echo
echo "Bootstrap complete."
echo "Repository: $REPO_FULL"
if [[ -n "$PROJECT_URL" ]]; then
  echo "Project: $PROJECT_URL"
fi
echo "Issues created: $created_count"
echo "Issues already existing: $existing_count"
