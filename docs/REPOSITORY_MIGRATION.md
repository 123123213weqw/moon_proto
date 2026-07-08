# Repository Migration Note

Date: 2026-07-08

## Summary

The original GitHub account/repository used during early development became
unavailable.  The project keeps Gitlink as the canonical public repository and
uses a new GitHub account as a mirror.

- Canonical Gitlink repository: <https://gitlink.org.cn/wangyue111/moon_proto>
- New GitHub mirror: <https://github.com/123123213weqw/moon_proto>

## What is preserved

The Git repository history is preserved, including all MoonBit source code, test
fixtures, documentation, CI workflow files, proposal materials and signed-off
commits up to the current submission line.

A local full-history Git bundle backup was also created before changing remotes:

```text
/Users/wangyue/Documents/moonbit_backups/moon_proto_20260708_081450_00bec76.bundle
```

## What is not automatically preserved

GitHub issues, pull requests and Actions runs are platform metadata.  They do
not move automatically when pushing the Git repository to a new GitHub account.
For that reason, the project does not rely on old GitHub issue numbers as the
long-term source of truth.  Traceability is preserved through committed files:

- `CHANGELOG.md`;
- `docs/ENGINEERING_RECORD.md`;
- `docs/DEVELOPMENT_REPORT.md`;
- `docs/SUBMISSION_CHECKLIST.md`;
- Git commit history and test/CI workflow files.

## Current remote policy

Gitlink is the canonical remote.  The new GitHub repository is a mirror for
review convenience and CI visibility when GitHub access is available.

Recommended local remotes:

```bash
git remote -v
# gitlink   git@code.gitlink.org.cn:wangyue111/moon_proto.git
# origin    git@github.com:123123213weqw/moon_proto.git
# github-old git@github.com:dsadsasdaddas/moon_proto.git
```

Recommended sync commands:

```bash
git push gitlink main:master
git push origin main
```

If the new GitHub mirror has not been created yet, create it first under account
`123123213weqw`, then push the existing local repository history.
