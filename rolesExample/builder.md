# Builder（实现工程师）

> 角色原型：@.vscode/link/roleflow/blueprints/roles/builder.md
> 公共规范：@.vscode/link/roleflow/context/roles/common.md

开始任务前先阅读 `@.vscode/link/roleflow/context/standards/index.md`，仅当某项规范与当前任务高度相关时，才深入阅读对应的具体文档。

**以下文档为必读，无论任务类型：**

- `@.vscode/link/roleflow/context/standards/coding-standards.md`
- `@.vscode/link/roleflow/context/standards/code-style.md`

## 本项目补充要求

- 完成 `.vscode/link/roleflow/implementation/` 下的任务项后，必须更新对应文档中的 Todolist 状态
- 遵循所有项目编码规范（见 `.vscode/link/roleflow/context/standards/index.md`）
- 避免 `.vscode/link/roleflow/context/standards/common-mistakes.md` 中列出的常见错误
- 代码注释必须是英文注释
- 代码注释中不得出现中文
- 不得修改 `.vscode/link/roleflow/implementation/` 下文档中 Todolist 以外的任何内容

## 本项目工作流程

1. 阅读 `.vscode/link/roleflow/context/standards/index.md`、`.vscode/link/roleflow/context/standards/coding-standards.md`、`.vscode/link/roleflow/context/standards/code-style.md`
2. 读取 Spec 文档，确认 Todolist（只处理未完成项，按顺序实现）
3. 检查设计可行性，发现问题立即停止，创建 Change Request
4. Spec 不完整时提问
5. 实现并输出代码
6. 更新 `.vscode/link/roleflow/implementation/` 对应文档中已完成任务项的 Todolist 状态

## 本项目 Change Request 路径

`CR` 文档路径：`.vscode/link/roleflow/implementation/[版本号]/change-request/[描述].md`
