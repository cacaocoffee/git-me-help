# git-me-help

Claude Code용 Git 커밋/PR 자동화 슬래시 커맨드.

diff 분석 → 메시지 생성 → 커밋/PR 생성까지 한 번에.

## Install

Paste this into your Claude Code session:

```
Install and configure git-me-help by following the instructions here:
https://raw.githubusercontent.com/cacaocoffee/git-me-help/main/docs/guide/installation.md
```

## Usage

설치 후 Claude Code에서 슬래시 커맨드로 실행:

### 커밋

```
/git-commit
```

`git add`로 staged된 변경사항을 분석해서 [Conventional Commits](https://www.conventionalcommits.org/) 규격의 커밋 메시지를 생성하고 바로 커밋까지 실행.

### PR — 신규 기능

```
/git-pr-feat
```

현재 브랜치와 베이스 브랜치(main/master/develop) 간의 diff를 분석해서 기능 PR 본문을 작성하고 `gh pr create`로 바로 PR 생성.

### PR — 버그 수정

```
/git-pr-fix
```

문제점 / 원인 분석 / 해결 방법 구조로 버그 수정 PR 본문을 작성하고 `gh pr create`로 바로 PR 생성.

> PR 자동 생성은 [gh CLI](https://cli.github.com/) 설치 및 `gh auth login` 필요. 없으면 본문만 출력해줌.
