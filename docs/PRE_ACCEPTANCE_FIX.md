# Pre-acceptance整改说明

本文档用于复验时快速对应预验收反馈、修复动作和可复现证据。

## 整改总览

| 预验收反馈 | 修复方式 | 证据入口 |
| --- | --- | --- |
| 最新 MoonBit 工具链不识别 `moon fmt --deny-warn` / `moon info --deny-warn` | 将格式门禁改为 `moon fmt --check`；信息检查使用 `moon info`，并用 `.mbti` 差异检查保证 public interface 文件同步 | `.github/workflows/ci.yml`、`scripts/release_gate.sh` |
| GitHub Actions 缺少格式检查和信息检查 | CI 已加入 `moon fmt --check`、`moon info`、`.mbti` diff、`moon package`、`moon check`、`moon build`、`moon test`、`moon test --target all` | GitHub Actions: `https://github.com/123123213weqw/moon_proto/actions` |
| 无法确认 mooncakes 发布 | 模块名已调整为 `123123213weqw/moon_proto`，`moon publish` 对 `0.1.0` 返回 `Server status: 200 OK` | `moon.mod`、`docs/SUBMISSION_CHECKLIST.md` |
| README/文档中的验证命令需要和 CI 保持一致 | README、测试文档、提交清单和一键 release gate 已统一使用当前 MoonBit CLI 命令 | `README.md`、`docs/TESTING.md`、`docs/SUBMISSION_CHECKLIST.md`、`scripts/release_gate.sh` |

## 当前仓库信息

- Gitlink 主仓库：`https://gitlink.org.cn/wangyue111/moon_proto`
- GitHub 镜像：`https://github.com/123123213weqw/moon_proto`
- Mooncakes 模块：`123123213weqw/moon_proto`
- 当前发布版本：`0.1.0`
- 项目定位：MoonBit protobuf 生态验证工具，不替代官方 `moonbitlang/protobuf` 和 `moonbitlang/protoc-gen-mbt`。

## 推荐复验命令

在仓库根目录执行：

```bash
bash scripts/release_gate.sh
```

该脚本会顺序执行：

1. Python/Go protobuf oracle fixture 检查；
2. `moon fmt --check`；
3. `moon info`；
4. `.mbti` public interface diff 检查；
5. `moon package`；
6. `moon check` / `moon build`；
7. `moon test` / `moon test --target all`；
8. CLI smoke 与生成代码编译检查；
9. AI schema 正例 verify、兼容性 compat、反例 doctor expected-fail。

## 与预验收反馈的直接对应

### 1. 工具链门禁

旧命令中的 `--deny-warn` 参数已不再作为验收命令使用。当前门禁为：

```bash
moon fmt --check
moon info
git diff --exit-code -- pkg.generated.mbti cmd/main/pkg.generated.mbti
```

这样既兼容新工具链，又能防止运行 `moon info` 后 public interface 文件发生未提交变更。

### 2. CI 门禁

CI 保留显式步骤，便于评审在 GitHub Actions 页面直接看到每个门禁是否通过：

- Format check；
- Public interface check；
- Package metadata check；
- Check；
- Build；
- Test；
- Test all targets；
- CLI smoke；
- Generated code compile check；
- AI schema verification smoke；
- Official differential source contract。

### 3. Mooncakes 发布

`moon.mod` 使用 mooncakes 要求的 `<author>/<module_name>` 格式：

```text
name = "123123213weqw/moon_proto"
version = "0.1.0"
repository = "https://github.com/123123213weqw/moon_proto"
```

本地已执行 `moon publish`，发布过程返回 `Server status: 200 OK`。

### 4. 文档命令同步

验收相关文档统一引用当前命令：

```bash
moon fmt --check
moon info
moon package
moon check
moon build
moon test
moon test --target all
```

避免复验时因 README、CI、测试文档命令不一致导致误判。
