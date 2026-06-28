# 全项目 CSS 书写规范（基于现有 SCSS 事实约定，排除 `src/multi_sign`）

## 适用范围

- 适用对象：`src/**` 下的样式书写，明确排除 `src/multi_sign/**`
- 规范目标：把现有项目已经稳定存在的 SCSS 习惯整理成一份可直接执行的 CSS 书写规范
- 口径说明：本规范优先复用项目现有的字号、圆角、边距、颜色、弹窗断点和第三方覆盖方式，不做新的设计体系扩展

## 1. 总体原则


- 默认使用局部样式作用域，页面和组件样式优先采用 CSS Modules 风格的 `.m.scss`
- 全局样式只承担 reset、字体、根容器尺寸、滚动条、公用辅助类和少量 Ant Design 全局覆盖，不承载具体业务页面样式
- 新增样式应优先复用项目已存在的高频数值，不随意发明新的字号、圆角、边框颜色和断点
- 第三方组件覆盖统一通过 `:global(.ant-...)` 处理，且应放在当前组件根类名下面，避免无边界污染
- 页面样式默认围绕浏览器插件弹窗尺寸设计，核心设计空间是 `360 x 600`
- 行内元素尽量都使用 block 或者 inline-block 加上 `justify-content: center` 来做居中

依据文件：`docs/link-ai-prompt/roleflow/explorations/2026-04-07-scss-style-conventions.md`、`src/popup/common/styles/global.scss`、`src/secondary_popup/common/styles/global.scss`、`src/passkey/common/styles/global.scss`、`src/ledger_import/common/styles/global.scss`

### 1.1 名词定义
- 视觉源：一般是 figma 或者 2x、3x、4x的高清晰图片文件
- 块级元素：一般认为，本项目中，宽度超过300px，且同一行中没有这个元素以外的元素，都可以认为是块级元素。
- 行内元素：一般是存在于块级元素内的元素。文字、icon等都天然是行内元素。


## 2. 文件组织规范

| 场景 | 规范 |
|------|------|
| 页面/组件局部样式 | 优先使用 `ComponentName.m.scss`，与页面或组件同目录放置 |
| 全局基线 | 仅放在各入口的 `common/styles/global.scss` |
| 第三方组件覆盖 | 跟随业务组件文件，放在该组件自己的 `.m.scss` 中，通过 `:global(.ant-...)` 精确覆盖 |
| 通用布局辅助类 | 只保留少量稳定辅助类，如 `.row`、`.col`、`.flex`、`.scroll`、`.paddingLR16` |

补充要求：

- 新页面或新组件应新建普通 `.m.scss` 文件
- 业务样式尽量跟随组件落地，不把单页专用样式塞进 `global.scss`
- 当前项目几乎没有统一的 `$变量`、`@mixin` 基建，新增样式默认直接复用既有数值；不要为了单一页面单独引入一套局部 token 体系

依据文件：`src/popup/common/styles/global.scss`、`src/components/Button/Button.m.scss`、`src/components/Input/Input.m.scss`、`src/components/PrepareConnectLedgerModal/PrepareConnectLedgerModal.m.scss`

## 3. 选择器与命名规范

- 每个样式文件通常以一个根类名作为入口，如 `.container`、`.pageContainer`、`.transferDetail`、`.versionUpdateModal`
- 子元素选择器写在根类名内部，使用嵌套表达结构关系，减少无前缀平铺选择器
- 类名以语义化英文为主，项目现状以 camelCase 为主，如 `.leftBox`、`.btnGroupWrap`、`.accountConnectionState`
- 状态类优先使用 `&.stateName`，如 `&.primary`、`&.secondary`、`&.checked`、`&.green`
- 交互态使用 `&:hover`、`&:focus`、`&:last-child` 等伪类，不单独拆散到全局
- `:global` 只用于第三方类名或少量项目共享全局类名，不要把业务块级结构写成全局选择器
- 标签选择器只在局部容器内做轻量 reset 时使用，如 `p`、`h1`、`h2` 的 margin 清理；不要在业务样式文件里直接写裸 `body`、`div`、`span`

依据文件：`src/components/NavBar/NavBar.m.scss`、`src/popup/pages/TransferDetailPage/TransferDetailPage.m.scss`、`src/secondary_popup/pages/ConnectWebsitePage/components/AccountLabel.m.scss`、`src/components/VersionUpdateModal/VersionUpdateModal.m.scss`

## 4. 字体与排版规范

### 4.1 字体族

- 默认字体族统一为 `HarmonyOS_Sans`, `PingFang SC`, `Microsoft Yahei`, `sans-serif`
- 全局默认字重是 `400`
- 页面如无特殊强调需求，不要替换字体族

### 4.2 字号层级

| 角色 | 推荐字号 | 常见字重 | 常见用途 |
|------|---------|---------|---------|
| 顶层标题 | `18px` | `500` / `600` | NavBar 标题、确认页主标题、重点金额 |
| 二级标题 | `16px` | `500` / `600` | 弹窗标题、区块标题、强调信息 |
| 正文默认 | `14px` | `400` / `500` | 按钮文案、表单文案、列表主信息 |
| 辅助说明 | `12px` | `400` | 提示文案、说明文案、地址、副信息 |
| 小标签 | `11px` | `400` / `500` | badge、链类型标签、微型状态标签 |

### 4.3 行高搭配

| 字号 | 常见行高 |
|------|---------|
| `18px` | `24px` / `25px` |
| `16px` | `22px` / `24px` |
| `14px` | `20px` |
| `12px` | `17px` |
| `11px` | `16px` |

补充要求：

- 项目现状大量使用固定像素行高，新增样式应继续显式声明 `line-height`
- 占位符文字通常使用 `14px`；在 `popup` 入口下，placeholder 颜色最终以 `#9ba4b6` 为准

依据文件：`docs/link-ai-prompt/roleflow/explorations/2026-04-07-scss-style-conventions.md`、`src/popup/common/styles/global.scss`、`src/components/NavBar/NavBar.m.scss`、`src/components/Button/Button.m.scss`、`src/secondary_popup/pages/ConnectWebsitePage/components/AccountLabel.m.scss`

## 5. 颜色规范

| 角色 | 推荐颜色 | 用途 |
|------|---------|------|
| 主文本 / 主按钮 / 主边框 | `#1a212b` | 页面标题、主要操作按钮、深色边界 |
| 次主文本 | `#232c41` | 标题、正文、二级强调 |
| 辅助正文 | `#6d778c` | 说明文案、次级标题 |
| 弱提示 / 地址 / 次级信息 | `#9ba4b6` | 地址、次要说明、placeholder |
| 主背景 | `#fff` / `#ffffff` | 页面底色、卡片、按钮反白 |
| 弱背景 | `#f4f4f7` / `#f7f8fa` | 卡片底、标签底、输入底 |
| 品牌强调色 | `#0d1fff` | 链接、强调态、品牌色标签 |
| 成功色 | `#0eb145` | 成功文案、成功标签、正向金额 |
| 警告色 | `#ffa928` | 风险提醒、警示标签 |
| 危险色 | `#e03b33` | 错误、危险操作、异常金额 |

补充要求：

- 状态标签通常采用“纯色文字 + 同色低透明背景”的写法，透明度多在 `0.15` 到 `0.18`
- 主按钮优先深色底，次按钮优先白底加浅灰或深色边框
- 新增颜色优先从现有颜色角色中选取，不要随意引入新的蓝、灰、红体系

依据文件：`docs/link-ai-prompt/roleflow/explorations/2026-04-07-scss-style-conventions.md`、`src/popup/pages/TransferDetailPage/TransferDetailPage.m.scss`、`src/secondary_popup/pages/ConnectWebsitePage/components/AccountLabel.m.scss`、`src/components/Button/Button.m.scss`

## 6. 边框与圆角规范

### 6.1 圆角层级

| 场景 | 推荐圆角 |
|------|---------|
| 默认交互控件 | `6px` |
| 弹层 / 浮层 / 大容器 | `10px` |
| 小标签 / 微型 badge | `2px` |
| 轻量输入 / 次级盒子 | `4px` |
| 次级卡片 / tooltip / 特殊容器 | `8px` |
| 部分 Modal 外壳 | `12px` |

### 6.2 边框层级

- 绝对主流是 `1px solid`
- 深色强调边框常用 `#1a212b`、`#232c41`
- 默认弱边框常用 `#ebedf0`、`#c0c7d6`
- 粗边框不是项目主流，除非是明确的品牌化图形或特殊交互状态

依据文件：`docs/link-ai-prompt/roleflow/explorations/2026-04-07-scss-style-conventions.md`、`src/components/Button/Button.m.scss`、`src/components/Input/Input.m.scss`、`src/components/PrepareConnectLedgerModal/PrepareConnectLedgerModal.m.scss`

## 7. 间距与布局规范

### 7.1 页面骨架

- 页面根容器优先使用 `height: 100%`
- 页面骨架优先使用 `display: flex` + `flex-direction: column`
- 中间内容区通常 `flex: 1` 或 `height: 100%`
- 滚动区和底部操作区分离，不让 footer 与主内容混在同一滚动流中
- 除了一些明显浮动的元素，原则上禁止用 `absolute` 布局

### 7.2 横向 gutter

- 页面主内容默认横向安全边距是 `16px`
- 高频写法是 `padding: 0 16px`、`padding: 20px 16px`、`padding: 24px 16px`、`margin: 0 16px`

### 7.3 导航区

- 顶栏高度默认 `64px`
- 顶栏左右边距默认 `16px`
- 标题多使用 `18px / 24px / 500`

### 7.4 卡片和列表

- 列表项、浅灰信息块、地址信息块常用 `6px` 圆角
- 单项内部 padding 多在 `10px` 到 `16px`
- 浅灰容器常用 `#f4f4f7`

### 7.5 固定底栏

- 底部按钮区常用 `position: fixed; bottom: 0`
- 内容区需要预留 `70px` 到 `80px` 的底部 padding，避免被底栏遮挡
- 底栏本身常配 `padding: 12px 16px 20px`

依据文件：`src/components/NavBar/NavBar.m.scss`、`src/popup/pages/TransferDetailPage/TransferDetailPage.m.scss`、`src/popup/common/styles/global.scss`

## 8. 按钮规范

### 8.1 尺寸

| 场景 | 推荐尺寸 |
|------|---------|
| 主按钮默认高度 | `40px` |
| Modal 双按钮高度 | `38px` |
| 单按钮宽度 | `100%` |
| 双按钮宽度 | `50%`、`calc(50% - 5px)` 或固定 `127px` |

### 8.2 视觉

- 主按钮常用深色背景 `#1a212b` 或 `#232c41`
- 次按钮常用白底、深色文字、浅灰或深色边框
- 默认圆角使用 `6px`，弹窗双按钮场景允许使用 `10px`
- hover / focus 常见做法是增加轻量阴影，而不是大幅改变颜色
- 不可用态通常直接切灰底，如 `rgba(209, 211, 213, 1)`

### 8.3 交互状态

- 状态类推荐挂在按钮根类上，如 `.primary`、`.secondary`、`.success`、`.danger`
- 加载态保留在按钮内部，不单独拆出第二套按钮结构

依据文件：`src/components/Button/Button.m.scss`、`src/components/PrepareConnectLedgerModal/PrepareConnectLedgerModal.m.scss`、`src/components/VersionUpdateModal/VersionUpdateModal.m.scss`

## 9. 输入框与表单规范

- 输入框高度以 `40px` 为主，强调型表单项可使用 `44px` 或 `46px`
- 输入文字默认使用 `14px`
- 标准输入框可使用 `4px` 或 `6px` 圆角
- 常规输入背景使用 `#fff`，密码框或 affix 场景常见 `#f7f8fa`
- Ant Input 覆盖时，默认边框可使用浅灰，focus 态切深色边框并去掉 `box-shadow`
- 输入内边距通常使用左右 `12px` 到 `16px`

依据文件：`src/components/Input/Input.m.scss`、`src/popup/pages/LedgerPathPage/LedgerPathPage.m.scss`、`src/components/PrepareConnectLedgerModal/PrepareConnectLedgerModal.m.scss`、`docs/link-ai-prompt/roleflow/explorations/2026-04-07-scss-style-conventions.md`

## 10. Modal / Drawer / Tooltip / Ant Design 覆盖规范

- 覆盖 Ant Design 时，必须放在当前组件根类名内，通过 `:global(.ant-...)` 写法局部生效
- Modal 常见做法是去掉默认 header / footer 边框，按业务重排 body 和 footer
- Modal 外层圆角常见 `10px` 或 `12px`，内容区圆角常见 `8px`
- Modal footer 高频 padding 是 `0 16px 24px 16px`
- 遮罩层常见深色半透明背景，如 `rgba(16, 16, 16, 0.6)` 或 `rgba(26, 33, 43, 0.6+)`
- Drawer、Tooltip、Switch、Checkbox 等三方组件也沿用相同原则：局部文件内精确覆盖，不在全局无差别改写

依据文件：`src/components/VersionUpdateModal/VersionUpdateModal.m.scss`、`src/components/PrepareConnectLedgerModal/PrepareConnectLedgerModal.m.scss`、`src/components/UpdateReminderModal/UpdateReminderModal.m.scss`、`src/popup/pages/SettingsPage/SettingsPage.m.scss`

## 11. 适配与响应式规范

- 项目适配重点不是移动端自适应，而是浏览器插件窗口和二次弹窗尺寸
- 关键断点以 `360px`、`440px`、`600px` 为主
- Modal 宽度遵循三段式：
  - 小于等于 `360px` 时使用 `320px`
  - 大于等于 `440px` 时使用 `400px`
  - 中间区间使用 `calc(100vw - 40px)`
- 页面宽度和弹窗宽度大量使用“固定 gutter + `calc(...)` 扣减”的方式，不使用复杂流式设计体系

### 响应式的具体要求
- 高度使用`600px`为基准，宽度使用`360px`为基准，但是宽高都是可变的。弹窗、按钮确定是跟着页面改变大小
- 弹窗宽度基本为`calc(100vw - 40px)`
- 按钮都是在 margin/padding 固定的情况下，按钮内的元素、文字居中、按钮高度不变、按钮宽度随响应式宽度变化，通常是 `calc(50vw - [margin]px)`
- 宽度80%vw以上的元素基本都是固定的 margin/padding 值，跟随页面宽度改变


依据文件：`src/popup/common/styles/global.scss`、`docs/link-ai-prompt/roleflow/explorations/2026-04-07-scss-style-conventions.md`

## 12. 书写约束清单

- 新增样式前先判断是否应写在局部 `.m.scss`，不要先写成全局样式
- 先复用既有字号梯度：`18 / 16 / 14 / 12 / 11`
- 先复用既有圆角梯度：`10 / 6 / 2`，必要时再用 `4 / 8 / 12`
- 先复用既有颜色角色：主文本、次文本、弱提示、弱背景、品牌蓝、成功/警告/危险
- 页面横向边距优先使用 `16px`
- 交互控件高度优先使用 `40px`，Modal 双按钮优先使用 `38px`
- Ant 覆盖只通过 `:global(.ant-...)` 并收敛在组件根类内
- 需要固定底栏时，同步补上内容区底部留白
- 不参考 `src/multi_sign/**` 下任何样式文件

## 13. 样式数值规范
- 如下样式的数值，必须严格使用 视觉源 的像素值：
  - height
  - padding
  - margin
  - font-weight
  - font-size
  - border
- 如下样式的数值，必须不能使用 视觉源 的像素值
  - width：对于块级元素，必须使用 `calc(100% - X)`, X为元素距离两侧的总值。比如视觉源中块级元素的width为320px，那么这里X就是`360px - 320px`，即40px。
  - font-family：全局设置了字体，不需要再设置任何字体覆盖全局

## 14. 主要依据文件

- `docs/link-ai-prompt/roleflow/explorations/2026-04-07-scss-style-conventions.md`
- `src/popup/common/styles/global.scss`
- `src/secondary_popup/common/styles/global.scss`
- `src/passkey/common/styles/global.scss`
- `src/ledger_import/common/styles/global.scss`
- `src/components/Button/Button.m.scss`
- `src/components/Input/Input.m.scss`
- `src/components/NavBar/NavBar.m.scss`
- `src/components/PrepareConnectLedgerModal/PrepareConnectLedgerModal.m.scss`
- `src/components/VersionUpdateModal/VersionUpdateModal.m.scss`
- `src/popup/pages/TransferDetailPage/TransferDetailPage.m.scss`
- `src/secondary_popup/pages/ConnectWebsitePage/components/AccountLabel.m.scss`
