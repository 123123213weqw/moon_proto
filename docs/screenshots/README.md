# Actual run screenshots

This directory contains reviewer-facing screenshots generated from real command
transcripts captured in the repository root.  The PNG files are for README
preview, while the matching `.txt` files contain the command, cwd, timestamp,
stdout/stderr and exit code. The complete final release-gate output is preserved in
`release_gate_full.txt`.

| Screenshot | Transcript | Command |
| --- | --- | --- |
| `release_gate_pass.png` | `release_gate_pass.txt` | `bash scripts/release_gate.sh` |
| `moon_test_all_targets.png` | `moon_test_all_targets.txt` | `moon test --target all` |
| `json_roundtrip_cli.png` | `json_roundtrip_cli.txt` | `moon run cmd/main -- json-roundtrip ...` |
| `moon_package_check.png` | `moon_package_check.txt` | `moon package --list && moon package` |
| `ai_verify_pass.png` | `ai_verify_pass.txt` | supplemental: `python3 scripts/moon_proto_lab.py verify examples/ai/good_order.proto ...` |
| `schema_doctor_bad_order.png` | `schema_doctor_bad_order.txt` | supplemental expected-fail: `python3 scripts/moon_proto_lab.py doctor examples/ai/bad_order.proto` |

The README front page intentionally uses the release-gate overview and JSON-roundtrip functionality screenshots, then links the remaining transcripts as supplemental evidence. The `schema_doctor_bad_order` command is intentionally expected to exit with code `1`, because it proves the doctor rejects a deliberately broken AI-generated schema.
