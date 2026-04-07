# Installation

## For Humans

Paste this into your Claude Code session:

```
Install and configure git-me-help by following the instructions here:
https://raw.githubusercontent.com/cacaocoffee/git-me-help/main/docs/guide/installation.md
```

## For Claude

Run the following command to install git-me-help:

```bash
curl -fsSL https://raw.githubusercontent.com/cacaocoffee/git-me-help/main/install.sh | bash
```

This will:
1. Download prompt files to `~/.git-me-help/`
2. Register Claude Code slash commands: `/git-commit`, `/git-pr-feat`, `/git-pr-fix`
3. Add git aliases: `git ai-commit`, `git ai-pr-feat`, `git ai-pr-fix`
4. Add shell aliases to `~/.zshrc`

## Update

```bash
curl -fsSL https://raw.githubusercontent.com/cacaocoffee/git-me-help/main/install.sh | bash -s -- --update
```

## Usage

In any git repository, open Claude Code and run:

| Command | Description |
| :------ | :---------- |
| `/git-commit` | staged diff 분석 → 커밋 메시지 생성 → `git commit` 자동 실행 |
| `/git-pr-feat` | 브랜치 diff 분석 → PR 본문 생성 → `gh pr create` 자동 실행 (신규 기능) |
| `/git-pr-fix` | 브랜치 diff 분석 → PR 본문 생성 → `gh pr create` 자동 실행 (버그 수정) |

> PR 생성은 [gh CLI](https://cli.github.com/) 설치 및 로그인 필요. 없으면 본문만 출력해줌.
