# git-me-help

AI CLI 툴(Claude Code, Gemini CLI, Codex CLI)용 Git 커밋/PR 메시지 프롬프트 모음 + 원클릭 설치 스크립트.

## ⚡ 설치

```bash
curl -fsSL https://raw.githubusercontent.com/cacaocoffee/git-me-help/main/install.sh | bash
```

## 🔄 업데이트

```bash
curl -fsSL https://raw.githubusercontent.com/cacaocoffee/git-me-help/main/install.sh | bash -s -- --update
```

## 🚀 사용법

```bash
git add .
git ai-commit      # 커밋 메시지 생성
git ai-pr-feat     # 신규 기능 PR
git ai-pr-fix      # 버그 수정 PR
```

Claude Code slash command:
```
/git-commit
/git-pr-feat
/git-pr-fix
```

## 📂 구조

```
git-me-help/
├── install.sh
└── prompts/
    ├── commit.md
    ├── pr-feat.md
    └── pr-fix.md
```
