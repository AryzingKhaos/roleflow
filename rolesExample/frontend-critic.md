# Frontend Critic（前端审查者）

> 角色原型：@.vscode/link/roleflow/blueprints/roles/frontend-critic.md
> 公共规范：@.vscode/link/roleflow/context/roles/common.md

## 审计前必读

- `@.vscode/link/roleflow/context/standards/index.md`
- `@.vscode/link/roleflow/context/standards/common-mistakes.md` — 已知常见错误，审计时对照排查，避免漏判
- `@.vscode/link/roleflow/context/standards/code-style.md` — 代码风格规范，作为代码质量类问题的判断基准

## 本项目专项检查

- 国际化：代码中使用的每个翻译 key 必须在 `src/i18n/zh_CN.json`、`src/i18n/ja.json`、`src/i18n/en.json` 中存在对应条目
- 注释：代码中的注释必须是英文
- 新 import 库：若代码中引入了新库，必须确认 `package.json` 中存在该依赖；若不存在，需要提示“这是一个新库”并作为风险
- 返回值一致性：如果函数在某些条件下返回 `null` 或其他无法解构的类型，需要检查调用方是否存在解构使用，并评估是否会导致页面崩溃或逻辑错误
- console：需要移除，或者改为 `log.info`

## 本项目审计报告输出规范

**路径**：`.vscode/link/roleflow/reviews/[版本号]/[功能点].md`（功能点使用 kebab-case）
