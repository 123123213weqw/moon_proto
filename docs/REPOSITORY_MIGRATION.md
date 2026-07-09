# Repository Migration Note

Date: 2026-07-08

## Summary

The original GitHub account used during early development became unavailable. The full Git history was preserved and moved to the contestant's current hosting accounts:

- Gitlink canonical repository: <https://gitlink.org.cn/wangyue111/moon_proto>
- GitHub repository and CI mirror: <https://github.com/123123213weqw/moon_proto>

The applicant, Git author identity and the current GitHub/Gitlink accounts belong to the same contestant. Account names differ from the applicant's real name, but the contribution relationship did not change.

## Preserved evidence

The mirrored history includes all MoonBit source, tests, fixtures, documentation, CI files and signed-off commits. Repository-host metadata such as old GitHub Issues, Pull Requests and Actions runs is not part of Git and could not be transferred automatically. Long-term traceability therefore uses:

- Git commit history on both current repositories;
- `CHANGELOG.md`;
- `docs/ENGINEERING_RECORD.md`;
- `docs/DEVELOPMENT_REPORT.md`;
- `docs/SUBMISSION_CHECKLIST.md`;
- current GitHub Actions runs.

## Current remote policy

Gitlink is the canonical contest repository; GitHub provides the public mirror and CI. The current local setup is:

```bash
git remote -v
# origin  https://github.com/123123213weqw/moon_proto.git
# gitlink git@code.gitlink.org.cn:wangyue111/moon_proto.git
```

After every accepted change, push the same commit to both default branches:

```bash
git push origin main
git push gitlink main:master
```
