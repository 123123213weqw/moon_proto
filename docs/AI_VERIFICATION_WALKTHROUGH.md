# AI 生成 schema 验证 walkthrough

Moon Proto Lab 的核心场景之一是：AI 生成 `.proto` schema 或 MoonBit 代码后，不能只看文本是否“像是对的”，还需要做可重复的工程验证。本 walkthrough 展示一个最小闭环：

```text
AI 生成 .proto
  -> Schema Doctor 静态诊断
  -> schema inspect 可读摘要
  -> MoonBit codegen
  -> 生成代码 moon check
  -> old/new schema 兼容性检查
  -> Markdown/JUnit 报告
```

## 文件

| 文件 | 用途 |
| --- | --- |
| `examples/ai/good_order.proto` | AI 生成 schema 经人工确认后的正例，覆盖 enum、nested message、map、repeated、oneof |
| `examples/ai/good_order_v2.proto` | 兼容演进版本，只追加字段和 enum 值，不破坏旧字段合同 |
| `examples/ai/bad_order.proto` | 故意写坏的 AI schema 反例，用于证明诊断能发现问题 |

## 1. 正例：生成、编译、报告

```bash
python3 scripts/moon_proto_lab.py verify \
  examples/ai/good_order.proto \
  --report generated/ai_good_order_verify_report.md \
  --junit-out generated/ai_good_order_verify_report.xml
```

预期结果：

```text
Moon Proto Lab verify: PASS
- schema doctor: PASS
- schema inspect: PASS
- codegen: PASS
- generated-code compile: PASS
```

这一步证明：schema 不只是能解析，还能生成 MoonBit 代码，并且生成代码能够通过 `moon check`。

## 2. 兼容演进：检查 v1 -> v2

```bash
python3 scripts/moon_proto_lab.py compat \
  examples/ai/good_order.proto \
  examples/ai/good_order_v2.proto \
  --report generated/ai_good_order_compat_report.md \
  --junit-out generated/ai_good_order_compat_report.xml
```

预期结果：

```text
schema compatible
```

这一步用于约束长期维护：AI 后续生成的新版本不能随意改字段号、字段类型、字段名，也不能删除字段但不保留 reserved 合同。

## 3. 反例：Schema Doctor 拒绝坏 schema

```bash
python3 scripts/moon_proto_lab.py doctor examples/ai/bad_order.proto
```

预期结果是失败，并输出类似诊断：

```text
schema invalid
issues: 6
message.Order.field.1: duplicate field number
message.Order.field.invalid_labels.key: invalid map key type
message.Order.field.legacy_note.number: field uses reserved number
message.Order.field.legacy_note.name: field uses reserved name
enum.OrderStatus.values[0]: proto3 enum first value must be zero
enum.OrderStatus.value.1: duplicate enum value number
```

这个反例模拟 AI 常见问题：

- enum 首项不是 `0`；
- enum 值号重复；
- message 字段号重复；
- reserved 字段号/字段名被重新使用；
- map key 使用了 protobuf 不允许的 `bytes` 类型。

## 4. 一键运行

完整 release gate 已包含上述 AI 验证案例：

```bash
bash scripts/release_gate.sh
```

因此评审或维护者可以用一个命令复现“AI 生成 schema 是否能被验证”的闭环。

## 评审关注点

本项目并不声称替代官方 protobuf runtime，而是补足 MoonBit 生态里“生成前/生成后验证”的基础设施：

- 对 schema 做稳定、可读的诊断；
- 对 schema 演进做兼容性检查；
- 对生成代码做真实编译检查；
- 对报告产出 Markdown/JUnit，便于 CI 和长期维护。
