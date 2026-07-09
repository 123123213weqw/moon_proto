name = "123123213weqw/moon_proto"

version = "0.1.1"

readme = "README.md"

repository = "https://github.com/123123213weqw/moon_proto"

license = "MIT"

keywords = [ "protobuf", "schema", "verification", "codegen", "wasm" ]

preferred_target = "wasm-gc"

description = "A MoonBit protobuf ecosystem lab for dynamic schema validation, compatibility testing, and AI code verification."

options(
  exclude: [
    ".github",
    ".claude",
    ".gitignore",
    "AGENTS.md",
    "PROPOSAL.md",
    "docs",
    "examples",
    "output",
    "scripts",
    "tests",
    "golden_wbtest.mbt",
  ],
)
