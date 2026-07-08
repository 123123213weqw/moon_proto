# Engineering Record

This document explains how Moon Proto Lab keeps the contest-required engineering
history public and traceable.  The earliest development phase was tracked mainly
through Git commits and CI.  After the original GitHub account/repository became
unavailable, Gitlink is treated as the canonical public repository and the new
GitHub repository is maintained as a mirror.

The old GitHub issue/PR metadata cannot be assumed to survive a repository
rebuild.  Therefore long-term traceability is preserved in Git commits, this
engineering record, `CHANGELOG.md`, verification reports, and the Gitlink mirror.
Future work should use the live flow: open issue -> branch -> pull request -> CI
-> merge -> Gitlink sync.

## Public tracking locations

- Gitlink repository (canonical): <https://gitlink.org.cn/wangyue111/moon_proto>
- GitHub repository (new mirror): <https://github.com/123123213weqw/moon_proto>
- Changelog: [`CHANGELOG.md`](../CHANGELOG.md)
- Repository migration note: [`docs/REPOSITORY_MIGRATION.md`](REPOSITORY_MIGRATION.md)
- Reviewer demo: [`docs/DEMO.md`](DEMO.md)
- Development report: [`docs/DEVELOPMENT_REPORT.md`](DEVELOPMENT_REPORT.md)
- Submission checklist: [`docs/SUBMISSION_CHECKLIST.md`](SUBMISSION_CHECKLIST.md)

## Issue and pull-request continuity

The first GitHub mirror used issues and pull requests for repository hygiene and
engineering-record cleanup, but GitHub issues/PRs are platform metadata rather
than Git objects.  They are not automatically preserved when the repository is
mirrored to a new GitHub account.

For the contest submission, the authoritative engineering history is therefore:

1. the Git commit history, preserved on Gitlink and in the new GitHub mirror;
2. the work-package table below, which maps milestones to representative commits;
3. `CHANGELOG.md`, verification reports and CI workflow files committed in Git;
4. future Gitlink/GitHub issues and pull requests created after the migration.

This avoids pretending that old GitHub issue numbers still exist after the
account migration.

## Work-package traceability

| Work package | Scope | Representative commits | Evidence |
| --- | --- | --- | --- |
| WP0 project bootstrap | Repository metadata, MoonBit package layout, CI skeleton and proposal materials | `d3a149d`, `5cd4ff2`, `d6eba92`, `b78e7f2` | README, proposal PDF, Gitlink/new GitHub mirror |
| WP1 protobuf primitives | Wire types, varint, zig-zag, fixed-width and field encoders | `ddb3bbf`..`1787a1f` | `golden_wbtest.mbt`, `moon test` |
| WP2 schema parser | Proto3 descriptors, lexer/parser, decorated schema tolerance | `dd121ab`, `627cdc4`, `82a9548`..`8d78a2a` | parser tests, example `.proto` files |
| WP3 validation and doctor | Schema validator, reserved contracts, diagnostic CLI and verify reports | `6d50012`, `4e88bf3`, `d16c366` | `doctor`, `verify`, JUnit XML reports |
| WP4 runtime and JSON mapping | Dynamic message runtime, nested/map/oneof support and protobuf JSON behavior | `3a6a1ef`..`269d782`, `bb6ae7e`..`adcae4f` | `moon test`, JSON roundtrip CLI |
| WP5 code generation | MoonBit source generation, file generator and generated-code compile checks | `c7fd09d`, `980780a`, `97deb37`, `938bf33` | `tests/codegen/compile_generated.sh` |
| WP6 compatibility and conformance | Python/Go oracle, official differential, conformance-lite and coverage gates | `7be37d0`, `f0b38c7`, `9470434`..`d0f0e52` | oracle scripts, conformance reports, CI |
| WP7 descriptor registry | Descriptor-set bridge, registry release gates, policy DSL and publish/pull adapters | `7fb538a`..`28da0c1` | descriptor reports and registry tests |
| WP8 contest readiness | Ecosystem positioning, development report, checklist and reviewer demo | `6ba9cb5`, `7824fbb`, `3f7bf87`, `cd5d403` | docs and final validation logs |

## Definition of done for future work

Every future change should follow this flow:

1. Create or reference a public issue.
2. Use a branch with the `wangyue/` prefix.
3. Keep the change small and focused.
4. Add or update a regression test before changing behavior.
5. Run the relevant verification commands.
6. Update `CHANGELOG.md` and docs if user-visible behavior changes.
7. Open a pull request and complete the PR checklist.
8. Merge only after CI and manual smoke checks pass.
9. Sync Gitlink and the GitHub mirror after `main` is updated.

## Minimum verification commands

```bash
moon check
moon build
moon test
moon test --target all
tests/codegen/compile_generated.sh
python3 scripts/moon_proto_lab.py verify examples/simple/user.proto --report generated/verify_report.md --junit-out generated/verify_report.xml
python3 scripts/moon_proto_lab.py compat examples/simple/user.proto examples/simple/user_v2.proto --report generated/compat_report.md --junit-out generated/compat_report.xml
python3 scripts/moon_proto_conformance.py --report generated/conformance_lite_report.md --json-out generated/conformance_lite.json --junit-out generated/conformance_lite.xml
```

## Regression policy

A bug is considered fixed only when a test or fixture captures the failing case.
Good regression candidates include:

- reserved field/name reuse;
- duplicate field numbers or names;
- invalid map key types;
- oneof selection and duplicate JSON fields;
- lowerCamel JSON aliases;
- numeric map-key canonicalization;
- descriptor-set compatibility edges;
- generated MoonBit source compile failures.

## Contest submission status

The current submission line is frozen at the completed 0.1.0 scope.  Additional
work before review should be limited to bug fixes, documentation, test evidence,
presentation materials and repository hygiene.
