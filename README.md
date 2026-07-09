# Moon Proto Lab

[![CI](https://github.com/123123213weqw/moon_proto/actions/workflows/ci.yml/badge.svg)](https://github.com/123123213weqw/moon_proto/actions/workflows/ci.yml)
[![Mooncakes](https://img.shields.io/badge/mooncakes-123123213weqw%2Fmoon__proto-brightgreen)](https://mooncakes.io/docs/123123213weqw/moon_proto)
![MoonBit](https://img.shields.io/badge/MoonBit-0.1.20260703-blue)
![License](https://img.shields.io/badge/license-MIT-green)

**Moon Proto Lab 是面向 MoonBit protobuf 生态的 schema 验证、兼容性检查与 AI 代码验证工具链。**

它把 `.proto` 从“看起来正确的文本”变成可诊断、可生成、可编译、可回归、可报告的工程资产：

```text
.proto -> Schema Doctor -> compatibility check -> dynamic binary/JSON runtime
       -> MoonBit codegen -> generated-code compile -> Markdown/JUnit/CI evidence
```

本项目不替代现有的 `moonbitlang/protobuf` 或 `moonbitlang/protoc-gen-mbt`。它提供的是围绕官方 protobuf 栈的**验证与工具层**，重点解决 AI 生成 schema/代码难以确认、schema 演进容易破坏兼容性、生成代码缺少持续验证等问题。

## 30 秒快速开始

### 作为 MoonBit 库安装

```bash
moon add 123123213weqw/moon_proto
```

在使用该库的 `moon.pkg` 中导入：

```moonbit
import {
  "123123213weqw/moon_proto" @proto,
}
```

最小示例：

```moonbit
fn main {
  let encoded = @proto.encode_varint_u64(300UL)
  println(encoded.length()) // 2
}
```

### 使用完整验证工具

```bash
git clone https://github.com/123123213weqw/moon_proto.git
cd moon_proto

# 检查 AI/人工生成的 schema
python3 scripts/moon_proto_lab.py doctor examples/ai/good_order.proto

# 完成 doctor、inspect、codegen、生成代码编译并输出报告
python3 scripts/moon_proto_lab.py verify \
  examples/ai/good_order.proto \
  --report generated/verify_report.md \
  --junit-out generated/verify_report.xml

# 检查 old/new schema 是否兼容
python3 scripts/moon_proto_lab.py compat \
  examples/ai/good_order.proto \
  examples/ai/good_order_v2.proto \
  --report generated/compat_report.md
```

完整本地验收：

```bash
bash scripts/release_gate.sh
```

运行要求：MoonBit；文件版报告工具需要 Python 3；完整跨语言 oracle 还需要 Python `protobuf` 与 Go。

## Agent 反馈闭环

下图展示 AI Agent 生成 schema 后，Moon Proto Lab 如何返回稳定诊断并驱动修复。它是工作流说明图；后面的终端图来自仓库真实命令记录。

<p align="center">
  <img src="https://raw.githubusercontent.com/123123213weqw/moon_proto/main/docs/diagrams/agent_feedback_loop_demo.png" alt="Agent feedback loop demo" width="920">
</p>

## 实际运行证据

每张图都有同名 `.txt` 命令记录，可核对命令、工作目录、时间和退出码。

<p align="center">
  <img src="https://raw.githubusercontent.com/123123213weqw/moon_proto/main/docs/screenshots/release_gate_pass.png" alt="Actual release gate run ending with PASS" width="920">
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/123123213weqw/moon_proto/main/docs/screenshots/json_roundtrip_cli.png" alt="Actual schema-aware JSON roundtrip CLI run" width="920">
</p>

补充证据：[`moon test --target all`](https://github.com/123123213weqw/moon_proto/blob/main/docs/screenshots/moon_test_all_targets.txt)、[`moon package`](https://github.com/123123213weqw/moon_proto/blob/main/docs/screenshots/moon_package_check.txt)、[`Schema Doctor 负例`](https://github.com/123123213weqw/moon_proto/blob/main/docs/screenshots/schema_doctor_bad_order.txt)。

## 核心能力

| 能力 | 当前实现 |
| --- | --- |
| Wire/runtime | varint、zig-zag、fixed32/64、length-delimited、unknown-field skip |
| Schema | proto3 message、enum、optional/repeated、map、oneof、reserved、nested type、常见声明容错 |
| 动态消息 | descriptor-driven scalar、repeated、packed、enum、nested、map、oneof 二进制编解码 |
| Protobuf JSON | enum name、64-bit integer、base64、Unicode、lowerCamel、map key normalization、严格数字语法 |
| Schema Doctor | 字段号/名称冲突、enum 规则、map 约束、reserved 复用等稳定诊断 |
| 兼容性检查 | old/new `.proto` 与 FileDescriptorSet 的破坏性变更检查 |
| Codegen | MoonBit struct、enum、descriptor、动态 runtime helper，并执行真实 `moon check` |
| 工程证据 | Python/Go oracle、建模的 conformance-lite 用例、官方接口契约检查、Markdown/JSON/JUnit 报告 |
| Registry adapter | descriptor registry、release policy、文件/HTTP/profile/GitHub Contents 适配验证 |

## 一个完整场景

故意错误的 schema：

```proto
syntax = "proto3";
message Order {
  reserved 7;
  reserved "legacy_note";
  uint64 id = 1;
  string duplicate = 1;
  bytes legacy_note = 7;
  map<bytes, string> invalid_labels = 8;
}
```

运行：

```bash
python3 scripts/moon_proto_lab.py doctor examples/ai/bad_order.proto
```

输出包含稳定路径：

```text
schema invalid
issues: 6
message.Order.field.1: duplicate field number
message.Order.field.invalid_labels.key: invalid map key type
message.Order.field.legacy_note.number: field uses reserved number
message.Order.field.legacy_note.name: field uses reserved name
```

修复后再执行 `verify` 与 `compat`，生成代码必须真实编译，schema 演进也必须通过兼容性门禁。

## MoonBit API 示例

```moonbit
let desc = @proto.MessageDescriptor::{
  name: "User",
  fields: [
    @proto.FieldDescriptor::{
      name: "id",
      typ: @proto.UInt64Type,
      number: 1,
      label: @proto.Singular,
    },
    @proto.FieldDescriptor::{
      name: "name",
      typ: @proto.StringType,
      number: 2,
      label: @proto.Singular,
    },
  ],
}

let msg = @proto.message_value([
  @proto.message_field("id", @proto.UInt64Value(150UL)),
  @proto.message_field("name", @proto.StringValue("Alice")),
])

let encoded = @proto.encode_message(desc, msg)
```

## 验证与质量

当前提交线的可复现结果：

- `moon check --deny-warn`：通过；
- `moon test --deny-warn`：`60/60 passed`；
- `moon test --target all`：wasm、wasm-gc、JS、native 全通过；
- MoonBit 核心包行覆盖率：`1935/2388`，约 `81.0%`；
- generated-code compile check：通过；
- Python/Go protobuf oracle：通过；
- AI schema 正例、兼容演进与故意错误负例：通过；
- GitHub Actions：通过。

常用命令：

```bash
moon fmt --check
moon info
moon package --list
moon check --deny-warn
moon build
moon test --deny-warn
moon test --target all
moon coverage analyze -p 123123213weqw/moon_proto -- -f summary
tests/codegen/compile_generated.sh
```

## 与现有 MoonBit protobuf 项目的关系

MoonBit 生态已有：

- [`moonbitlang/protobuf`](https://mooncakes.io/docs/moonbitlang/protobuf)：生产 runtime；
- [`moonbitlang/protoc-gen-mbt`](https://github.com/moonbitlang/protoc-gen-mbt)：官方代码生成器。

Moon Proto Lab 的独立贡献是：

1. 在生成前检查 schema，并为 AI 输出提供稳定诊断；
2. 在 schema 演进时检查字段号、类型、reserved 等兼容性合同；
3. 在生成后真实编译 MoonBit 代码，而不是只做文本快照；
4. 使用 Python/Go oracle 与 MoonBit golden tests 验证 wire/JSON 行为；
5. 输出适合 CI、代码审查和 Agent 消费的 Markdown/JSON/JUnit 证据。

## 已知边界

当前版本是面向验证场景的 proto3 子集，不宣称完整 protobuf conformance：

- `service`、`rpc`、custom option 等主要做解析容错，不生成完整 RPC 实现；
- typed struct 的生产级 encode/decode 能力不替代官方生成器，核心验证路径使用动态 `MessageValue`；
- `conformance-lite` 是基于公开 protobuf 语义建模的小型 fixture 集，不是上游官方 conformance suite 的镜像；
- `official source/output-shape contract` 检查验证公开接口契约；只有显式启用 live-generator 路径时才会实际运行官方生成器；
- FileDescriptorSet、报告和 registry adapter 目前由 Python 集成层承载，MoonBit 核心实现集中在 parser/runtime/JSON/codegen/compat CLI。

## 文档

- [5 分钟评审演示](https://github.com/123123213weqw/moon_proto/blob/main/docs/DEMO.md)
- [AI 验证 walkthrough](https://github.com/123123213weqw/moon_proto/blob/main/docs/AI_VERIFICATION_WALKTHROUGH.md)
- [测试策略](https://github.com/123123213weqw/moon_proto/blob/main/docs/TESTING.md)
- [开发报告](https://github.com/123123213weqw/moon_proto/blob/main/docs/DEVELOPMENT_REPORT.md)
- [Schema Doctor](https://github.com/123123213weqw/moon_proto/blob/main/docs/SCHEMA_DOCTOR.md)
- [官方接口契约检查](https://github.com/123123213weqw/moon_proto/blob/main/docs/OFFICIAL_DIFFERENTIAL.md)
- [Descriptor set bridge](https://github.com/123123213weqw/moon_proto/blob/main/docs/DESCRIPTOR_SET.md)
- [Descriptor registry](https://github.com/123123213weqw/moon_proto/blob/main/docs/SCHEMA_REGISTRY.md)
- [第三方来源与许可证](https://github.com/123123213weqw/moon_proto/blob/main/THIRD_PARTY_NOTICES.md)

## 仓库与发布

- Mooncakes：[`123123213weqw/moon_proto`](https://mooncakes.io/docs/123123213weqw/moon_proto)
- GitHub：<https://github.com/123123213weqw/moon_proto>
- Gitlink（赛事主仓库）：<https://gitlink.org.cn/wangyue111/moon_proto>

## License

项目原创代码采用 MIT License。第三方依赖、公开规范、测试 oracle 和契约 fixture 的来源与许可证见 [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md)。
