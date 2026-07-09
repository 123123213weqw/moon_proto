# Changelog

## [Unreleased]

No unreleased changes.

## [0.1.1] - 2026-07-10

### Changed

- Added a concise Chinese quick start with the verified `moon add` installation path and explicit project boundaries.
- Reduced the Mooncakes artifact from a repository-wide 931 KB archive to a focused 41 KB, 23-file library package.
- Added third-party license/provenance notices and clearly labeled hand-authored output-shape fixtures and modeled conformance-lite cases.
- Added `--deny-warn`, an 80% core MoonBit coverage gate, and publish-package content checks to CI and the local release gate.
- Published final-submission metadata as version `0.1.1` and removed personal contact details from public proposal materials.
- Moved the Agent feedback loop diagram ahead of run screenshots in README so reviewers see the AI collaboration value before verification evidence.
- Deduplicated README screenshots so the front page shows release gate, multi-target tests, JSON roundtrip and package publishing instead of repeating AI verification snippets already included in the release gate.
- Added an Agent feedback loop demo diagram to explain how AI-generated schemas receive structured diagnostics, fixes and CI re-validation.
- Replaced decorative SVG review visuals with actual run screenshots rendered from real command transcripts, with matching `.txt` evidence files.
- Added a pre-acceptance fix note that maps each review comment to concrete repository evidence.
- Added `scripts/release_gate.sh` as a one-command local acceptance gate.
- Added AI-generated schema verification fixtures and walkthrough docs.
- Added a reviewer playbook and README badges/shortcuts for faster contest review.
- Published `123123213weqw/moon_proto` version `0.1.0` to mooncakes as the first public package; `0.1.1` is the cleaned final-submission release.
- Added release-gate checks for `moon fmt --check`, `moon info`, `moon package`, committed generated `.mbti` files, and changed the module name to `123123213weqw/moon_proto` for mooncakes packaging.
- Documented repository migration from the unavailable original GitHub account to Gitlink as canonical repository plus `123123213weqw/moon_proto` as the new GitHub mirror.

All notable changes to **Moon Proto Lab** are recorded here for contest review,
release tracking, and long-term maintenance.

## [0.1.0-submission] - 2026-06-30

### Added

- Protobuf wire-format primitives: varint, wire keys, zig-zag, fixed-width,
  length-delimited values and common field encoders.
- Proto3 schema model, lexer and parser for messages, enums, maps, oneof,
  reservations, options, nested types, service/rpc tolerance and edition
  tolerance.
- Schema validation diagnostics for duplicate fields, reserved contracts, enum
  invariants, map constraints and breaking schema patterns.
- Dynamic descriptor-driven encode/decode runtime for scalar, repeated, packed,
  enum, nested message, map and oneof fields.
- Protobuf JSON mapping support, including lowerCamel aliases, enum-name
  mapping, bytes base64 variants, Unicode escapes, strict number grammar,
  integer exponent notation, null-as-absent semantics and canonical map-key
  normalization.
- MoonBit code generation helpers and file-based generator wrapper.
- Schema Doctor, schema inspection, compatibility checker, schema-aware JSON
  roundtrip CLI and AI-verification report workflow.
- Python and Go protobuf oracle fixtures, deterministic golden vectors,
  conformance-lite evidence, official MoonBit protobuf contract checks and
  generated-code compile checks.
- FileDescriptorSet bridge, descriptor compatibility, descriptor registry
  release gates, policy checks, publish/pull workflows and registry adapter
  verification.
- GitHub Actions CI and submission documentation.

### Verification evidence

- `moon check`
- `moon build`
- `moon test` -> `60/60 passed`
- `moon test --target all` -> wasm / wasm-gc / js / native all passed
- `tests/codegen/compile_generated.sh` -> `Generated MoonBit source compiles`
- `python3 scripts/moon_proto_conformance.py ...` -> conformance-lite `PASS`
- `python3 scripts/moon_proto_lab.py verify ...` -> verification report `PASS`
- `python3 scripts/moon_proto_lab.py compat ...` -> compatibility report `PASS`
- Python protobuf oracle -> `PASS`
- Go protobuf oracle -> `PASS` when Go is available

### Engineering notes

This release is feature-frozen for contest submission. Future changes should be
small, issue-driven and regression-test-first.
