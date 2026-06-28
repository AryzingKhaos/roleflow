# roles/ 原型层索引

> 本目录存放跨项目复用的角色原型；项目特有路径、预读材料和规范补充应放在实例层。

## 公共原型

| 文件 | 说明 |
|------|------|
| [base/common.md](base/common.md) | 所有角色共享的基础协作原则 |
| [base/collab-base.md](base/collab-base.md) | 协作访谈者家族（architect / pm）共享基类：协作姿态、一次一问、边谈边写、两种运行模式 |

## 角色原型列表

| 文件 | 角色 | 职责 |
|------|------|------|
| [clarifier.md](clarifier.md) | 需求澄清师 | 把模糊需求结构化成可交给 Planner 的需求文档（0→1） |
| [pm.md](pm.md) | 协作产品经理 | 跟用户逐题打磨产品的用户 / 市场 / 体验 / 传播，产出产品 PRD |
| [prd-skeptic.md](prd-skeptic.md) | PRD 怀疑者 | 默认怀疑 PRD，联网找证据反驳，输出风险清单与反问 |
| [architect.md](architect.md) | 协作架构师 | 跟用户逐题对清技术架构（module / seam / depth），产出架构草案 |
| [explorer.md](explorer.md) | 探索者 | 探索并文档化现有代码行为 |
| [planner.md](planner.md) | 规划者 | 将需求转化为 Builder 可实现的规格说明 |
| [planner-for-style.md](planner-for-style.md) | 样式规划者 | 规划前端 CSS 样式修改计划（不碰样式无关逻辑） |
| [builder.md](builder.md) | 实现工程师 | 根据 Spec 编写实现代码，并维护任务状态 |
| [builder-for-style.md](builder-for-style.md) | 样式实现工程师 | 根据 Spec 实现视觉还原，并维护任务状态 |
| [critic.md](critic.md) | 审查者 | 识别前端问题，提供风险评估 |
| [evaluator-for-chrome-ui.md](evaluator-for-chrome-ui.md) | UI 视觉评估者 | 打开页面截图，与设计稿做静态视觉对比并出报告 |
| [evaluator-for-e2e.md](evaluator-for-e2e.md) | 端到端测试评估者 | 浏览器自动化驱动跑业务流，强 / 软断言并出报告 |
| [test-designer.md](test-designer.md) | 测试设计者 | 设计测试方案与验证清单，并管理调试打印 |
| [test-writer.md](test-writer.md) | 单测编写者 | 编写单元测试与测试辅助代码 |
| [archivist.md](archivist.md) | 档案维护者 | 维护知识库文档、索引和角色命令映射 |
| [commit-writer.md](commit-writer.md) | 提交文案撰写者 | 基于 staged 变更生成英文 commit 文案 |
| [chat.md](chat.md) | 聊天助手 | 只读交流，回答问题、解释代码、讨论方案 |
| [test-email-writer.md](test-email-writer.md) | 提测邮件撰写者 | 把开发分工文档压缩成面向测试的提测邮件 |
| [daily-reporter.md](daily-reporter.md) | 日报撰写者 | 根据当日提交记录生成日报 |
| [weekly-reporter.md](weekly-reporter.md) | 周报撰写者 | 根据提交记录生成周报 |
