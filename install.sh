#!/usr/bin/env bash
set -e

REPO="cacaocoffee/git-me-help"
BRANCH="main"
RAW_BASE="https://raw.githubusercontent.com/${REPO}/${BRANCH}"
PROMPTS_DIR="${HOME}/.git-me-help"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'
info()    { echo -e "${BLUE}ℹ${RESET}  $*"; }
success() { echo -e "${GREEN}✔${RESET}  $*"; }
warn()    { echo -e "${YELLOW}⚠${RESET}  $*"; }
error()   { echo -e "${RED}✖${RESET}  $*"; exit 1; }
header()  { echo -e "\n${BOLD}${CYAN}$*${RESET}"; }

command -v curl >/dev/null 2>&1 || error "curl이 필요합니다."
command -v git  >/dev/null 2>&1 || error "git이 필요합니다."

download_prompts() {
  header "📥 프롬프트 파일 다운로드 중..."
  mkdir -p "${PROMPTS_DIR}"
  for file in commit.md pr-feat.md pr-fix.md; do
    curl -fsSL "${RAW_BASE}/prompts/${file}" -o "${PROMPTS_DIR}/${file}"
    success "다운로드: ${PROMPTS_DIR}/${file}"
  done
}

setup_claude() {
  header "🤖 Claude Code 설정 중..."
  local commands_dir="${HOME}/.claude/commands"
  mkdir -p "${commands_dir}"
  cp "${PROMPTS_DIR}/commit.md"  "${commands_dir}/git-commit.md"
  cp "${PROMPTS_DIR}/pr-feat.md" "${commands_dir}/git-pr-feat.md"
  cp "${PROMPTS_DIR}/pr-fix.md"  "${commands_dir}/git-pr-fix.md"
  success "Claude slash commands 등록 완료 → /git-commit, /git-pr-feat, /git-pr-fix"
}

setup_gemini() {
  header "💎 Gemini CLI 설정 중..."
  local gemini_dir="${HOME}/.gemini"
  mkdir -p "${gemini_dir}"
  cp "${PROMPTS_DIR}/commit.md"  "${gemini_dir}/git-commit-system.md"
  cp "${PROMPTS_DIR}/pr-feat.md" "${gemini_dir}/git-pr-feat-system.md"
  cp "${PROMPTS_DIR}/pr-fix.md"  "${gemini_dir}/git-pr-fix-system.md"
  success "Gemini CLI 시스템 프롬프트 등록 완료"
}

setup_codex() {
  header "⚡ Codex CLI 설정 중..."
  local codex_dir="${HOME}/.codex"
  mkdir -p "${codex_dir}"
  cp "${PROMPTS_DIR}/commit.md"  "${codex_dir}/git-commit.md"
  cp "${PROMPTS_DIR}/pr-feat.md" "${codex_dir}/git-pr-feat.md"
  cp "${PROMPTS_DIR}/pr-fix.md"  "${codex_dir}/git-pr-fix.md"
  success "Codex CLI 프롬프트 파일 등록 완료"
}

setup_aliases() {
  header "🔧 Shell Alias 등록 중..."
  local shell_rc=""
  case "${SHELL}" in
    */zsh)  shell_rc="${HOME}/.zshrc" ;;
    */bash) shell_rc="${HOME}/.bashrc" ;;
    *)      shell_rc="${HOME}/.profile" ;;
  esac
  local marker="# git-me-help aliases"
  if grep -q "${marker}" "${shell_rc}" 2>/dev/null; then
    warn "Alias가 이미 ${shell_rc}에 등록되어 있습니다. 스킵합니다."
    return
  fi
  cat >> "${shell_rc}" << 'ALIASES'

# git-me-help aliases
_gmh_prompt() { cat "${HOME}/.git-me-help/$1"; }

alias gmh-commit='claude "$(_gmh_prompt commit.md)"'
alias gmh-pr-feat='claude "$(_gmh_prompt pr-feat.md)"'
alias gmh-pr-fix='claude "$(_gmh_prompt pr-fix.md)"'

alias gmh-gemini-commit='gemini --system "${HOME}/.gemini/git-commit-system.md"'
alias gmh-gemini-pr-feat='gemini --system "${HOME}/.gemini/git-pr-feat-system.md"'
alias gmh-gemini-pr-fix='gemini --system "${HOME}/.gemini/git-pr-fix-system.md"'

alias gmh-codex-commit='codex --full-auto "$(cat ~/.codex/git-commit.md)"'
alias gmh-codex-pr-feat='codex --full-auto "$(cat ~/.codex/git-pr-feat.md)"'
alias gmh-codex-pr-fix='codex --full-auto "$(cat ~/.codex/git-pr-fix.md)"'
ALIASES
  success "Alias 등록 완료: ${shell_rc}"
  info "반영하려면: source ${shell_rc}"
}

setup_gh() {
  header "🐙 GitHub CLI (gh) 설정 중..."
  if ! command -v gh >/dev/null 2>&1; then
    if command -v brew >/dev/null 2>&1; then
      info "gh CLI 설치 중 (Homebrew)..."
      brew install gh
      success "gh CLI 설치 완료"
    else
      warn "gh CLI 없음. Homebrew도 없어 자동 설치 불가. 수동 설치: https://cli.github.com"
      return
    fi
  else
    success "gh CLI 이미 설치됨"
  fi

  if gh auth status >/dev/null 2>&1; then
    local user
    user=$(gh api user --jq '.login' 2>/dev/null || echo "알 수 없음")
    success "gh 이미 로그인됨: ${user}"
  else
    info "GitHub 로그인이 필요합니다. 브라우저가 열립니다..."
    gh auth login --git-protocol ssh --hostname github.com --web
    success "gh 로그인 완료"
  fi
}

setup_git_aliases() {
  header "🔗 Git Alias 등록 중..."
  git config --global alias.ai-commit  '!claude "$(cat ~/.git-me-help/commit.md)"'
  git config --global alias.ai-pr-feat '!claude "$(cat ~/.git-me-help/pr-feat.md)"'
  git config --global alias.ai-pr-fix  '!claude "$(cat ~/.git-me-help/pr-fix.md)"'
  success "Git alias 등록 완료 → git ai-commit / git ai-pr-feat / git ai-pr-fix"
}

update_prompts() {
  header "🔄 프롬프트 업데이트 중..."
  download_prompts
  [ -d "${HOME}/.claude/commands" ] && {
    cp "${PROMPTS_DIR}/commit.md"  "${HOME}/.claude/commands/git-commit.md"
    cp "${PROMPTS_DIR}/pr-feat.md" "${HOME}/.claude/commands/git-pr-feat.md"
    cp "${PROMPTS_DIR}/pr-fix.md"  "${HOME}/.claude/commands/git-pr-fix.md"
    success "Claude 업데이트 완료"
  }
  [ -d "${HOME}/.gemini" ] && {
    cp "${PROMPTS_DIR}/commit.md"  "${HOME}/.gemini/git-commit-system.md"
    cp "${PROMPTS_DIR}/pr-feat.md" "${HOME}/.gemini/git-pr-feat-system.md"
    cp "${PROMPTS_DIR}/pr-fix.md"  "${HOME}/.gemini/git-pr-fix-system.md"
    success "Gemini 업데이트 완료"
  }
  [ -d "${HOME}/.codex" ] && {
    cp "${PROMPTS_DIR}/commit.md"  "${HOME}/.codex/git-commit.md"
    cp "${PROMPTS_DIR}/pr-feat.md" "${HOME}/.codex/git-pr-feat.md"
    cp "${PROMPTS_DIR}/pr-fix.md"  "${HOME}/.codex/git-pr-fix.md"
    success "Codex 업데이트 완료"
  }
}

main() {
  echo -e "${BOLD}"
  echo "  ╔══════════════════════════════════╗"
  echo "  ║      git-me-help installer       ║"
  echo "  ╚══════════════════════════════════╝"
  echo -e "${RESET}"

  if [ "${1:-}" = "--update" ]; then
    update_prompts
    echo -e "\n${GREEN}${BOLD}✨ 업데이트 완료!${RESET}"
    return
  fi

  download_prompts
  command -v claude >/dev/null 2>&1 && setup_claude  || warn "Claude Code 없음. 스킵."
  command -v gemini >/dev/null 2>&1 && setup_gemini  || warn "Gemini CLI 없음. 스킵."
  command -v codex  >/dev/null 2>&1 && setup_codex   || warn "Codex CLI 없음. 스킵."
  setup_gh
  setup_aliases
  setup_git_aliases

  echo ""
  echo -e "${BOLD}${GREEN}✨ 설치 완료!${RESET}"
  echo ""
  echo -e "  ${CYAN}git ai-commit${RESET}     # 커밋 메시지 생성"
  echo -e "  ${CYAN}git ai-pr-feat${RESET}    # 신규 기능 PR 생성"
  echo -e "  ${CYAN}git ai-pr-fix${RESET}     # 버그 수정 PR 생성"
  echo ""
  echo -e "  업데이트: ${CYAN}curl -fsSL ${RAW_BASE}/install.sh | bash -s -- --update${RESET}"
  echo ""
}

main "$@"
