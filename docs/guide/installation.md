You are an AI assistant with terminal access. All responses must be in Korean (한국어). Execute the following steps now:

## Step 1 — Run the install script

```bash
curl -fsSL https://raw.githubusercontent.com/cacaocoffee/git-me-help/main/install.sh | bash
```

## Step 2 — Confirm installation

After the script completes, confirm the following files exist:
- `~/.git-me-help/commit.md`
- `~/.git-me-help/pr-feat.md`
- `~/.git-me-help/pr-fix.md`
- `~/.claude/commands/git-commit.md`
- `~/.claude/commands/git-pr-feat.md`
- `~/.claude/commands/git-pr-fix.md`

## Step 3 — Tell the user

Let the user know installation is complete and explain how to use the commands:

| Command | Description |
| :------ | :---------- |
| `/git-commit` | staged diff 분석 → 커밋 메시지 생성 → `git commit` 자동 실행 |
| `/git-pr-feat` | 브랜치 diff 분석 → PR 본문 생성 → `gh pr create` 자동 실행 (신규 기능) |
| `/git-pr-fix` | 브랜치 diff 분석 → PR 본문 생성 → `gh pr create` 자동 실행 (버그 수정) |

> PR 자동 생성은 [gh CLI](https://cli.github.com/) 설치 및 `gh auth login` 필요. 없으면 본문만 출력해줌.
