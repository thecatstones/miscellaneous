#!/bin/bash

# Shell function/alias for easy multi-author commits.

# Instructions
# 1. In .bashrc or .zshrc, source this file or copy and paste its contents.
#   - eg: `source PATH/TO/git-coauthor-commit-shell-function.sh`
# 2. Usage: `$ cgap {COMMIT_MESSAGE}`

function git_add_commit_push_catstones {
  git add -A
git commit -m "$1


Co-authored-by: YingCGooi <25574844+YingCGooi@users.noreply.github.com>
Co-authored-by: Julius <Julius@Juliuss-MacBook-Pro.local>
Co-authored-by: Nick Johnson <njohnson7@users.noreply.github.com>"
  git push
}
alias cgap='git_add_commit_push_catstones'
