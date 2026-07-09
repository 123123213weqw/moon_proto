# Moon Proto Lab 项目申报书（公开脱敏版）

## 基本信息
- **项目名称**：Moon Proto Lab：MoonBit protobuf schema 验证、兼容性测试与 AI 代码验证工具链
- **参赛者 / 队伍**：王越的战队（王越）
- **联系方式**：已在赛事报名系统提交；公开仓库版本脱敏
- **GitHub**：https://github.com/123123213weqw/moon_proto
- **Gitlink**：https://gitlink.org.cn/wangyue111/moon_proto
- **Mooncakes**：https://mooncakes.io/docs/123123213weqw/moon_proto
- **项目方向**：MoonBit 基础软件生态工具 / protobuf 验证与代码生成辅助设施
- **项目性质**：MoonBit parser/runtime/JSON/codegen/compat 核心为原创实现；参考 Protocol Buffers 公开规范，Python/Go 仅承担 oracle、报告和集成适配。

## 项目简介与场景
Moon Proto Lab 把 `.proto` 从“看起来正确的文本”转化为可诊断、可生成、可编译、可回归、可报告的工程资产，服务于 AI 生成 schema、云边协议、WebAssembly 服务和多语言数据交换。项目不替代 `moonbitlang/protobuf` / `protoc-gen-mbt`，而是补充 Schema Doctor、schema 演进兼容性、动态调试、生成代码编译检查和 CI 证据。

## 核心交付
- MoonBit proto3 schema/parser、validator、动态 message 二进制与 protobuf JSON runtime；
- Schema Doctor、old/new schema compatibility、MoonBit codegen 与 generated-code compile check；
- FileDescriptorSet/registry/release-policy 集成适配，以及 Markdown/JSON/JUnit 报告；
- Python/Go protobuf oracle、原创 upstream-style conformance-lite 模型和官方公开接口契约检查；
- README、示例、开发报告、第三方来源说明、GitHub Actions 与一键 release gate。

## 完成度与质量
当前约 8.5k 行 MoonBit，`60/60` MoonBit 测试通过，wasm/wasm-gc/JS/native 四目标通过；核心包覆盖率约 81%；生成代码会在临时 MoonBit 项目中真实执行 `moon check`；Mooncakes 已发布并可由外部项目通过 `moon add 123123213weqw/moon_proto` 安装。

## 差异化与边界
已有官方项目侧重生产 runtime/codegen；本项目侧重生成前诊断、生成后编译、兼容性合同和 Agent/CI 可消费证据。当前为明确边界的 proto3 子集，不宣称完整 protobuf conformance；手写 output-shape fixtures 与可选 live-generator 路径均明确标注来源。

## 许可证
原创代码采用 MIT License；外部规范、依赖、oracle 与 fixture 来源见 `THIRD_PARTY_NOTICES.md`。
