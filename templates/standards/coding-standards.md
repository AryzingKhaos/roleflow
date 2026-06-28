
> **强制性规范**: 所有代码开发必须严格遵守本文档的规范。详细说明和示例请参考 [project.md](../project.md)。

---

## 1. 语言使用规范 🌍

### 1.1 代码注释（强制英文）
- ✅ **所有代码注释必须使用英文**
- ✅ 包括：函数说明、参数说明、行内注释、TODO、FIXME 等
- 标记todo的时候，使用`todos:`，不要使用`TODO:`

### 1.2 文档编写（强制中文）
- ✅ **`docs/link-ai-prompt/roleflow/` 目录下的所有 `.md` 文档必须使用中文**
- ✅ 包括：项目文档、功能文档、实现计划等

---

## 2. TypeScript 类型规范 📝

### 2.1 强制类型声明
- ✅ **必须明确声明函数参数和返回值类型**
- ❌ **禁止使用 `any` 类型**（使用 `unknown` 或具体类型）
- ⚠️ **最小化 `@ts-ignore` 使用**（必须添加注释说明原因）

### 2.2 类型定义
```typescript
// ✅ Correct
function processData(data: DataType): ResultType { }

// ❌ Wrong
function processData(data: any): any { }
```

### 2.3 不要使用“|”，使用枚举
```typescript
// ✅ Correct
enum DeFiLoadStatus {
  IDLE = 'idle',
  LOADING = 'loading',
  SUCCESS = 'success',
  FAILED = 'failed',
};
interface DeFiState {
  status: DeFiLoadStatus;
  ...others,
}

// ❌ Wrong
type DeFiLoadStatus = 'idle' | 'loading' | 'success' | 'failed';
interface DeFiState {
  status: DeFiLoadStatus;
  ...others,
}
```

---

## 3. 命名规范 🏷️

- **变量/函数**: `camelCase`
- **类/组件**: `PascalCase`
- **常量**: `UPPER_SNAKE_CASE`
- **私有成员**: 前缀 `_`

```typescript
const userName = 'Alice';              // ✅
const MAX_RETRY_COUNT = 3;             // ✅
class UserManager { }                  // ✅
function getUserInfo() { }             // ✅
private _privateMethod() { }           // ✅
```

---

## 4. 错误处理规范 ⚠️

### 4.1 异步错误处理
- ✅ **必须使用 try-catch 处理异步错误**
- ✅ **必须记录错误日志**（`log.error()` 或 `console.error()`）
- ✅ **必须给用户友好的错误提示**
- ❌ **禁止静默失败**

```typescript
// ✅ Required pattern
try {
  await riskyOperation();
} catch (error) {
  log.error('Operation failed:', error);
  Toast.show({ icon: 'fail', content: 'Error message' });
}
```

---

## 5. 安全规范 🔒

### 5.1 私钥安全
- 🔒 **私钥必须使用 `browser-passworder` 加密存储**
- 🔒 **禁止在日志中输出私钥、助记词、密码**
- 🔒 **敏感数据仅存储在 `chrome.storage.local`**

### 5.2 XSS 防护
- ✅ **用户输入必须使用 `dompurify` 清理**
- ❌ **禁止使用 `eval()` 和 `Function()`**

### 5.3 交易安全
- ✅ **交易签名必须用户手动确认**
- ✅ **必须展示完整交易详情**

### 5.4 迁移代码安全
- **涉及到代码迁移的，代码只要有一个字符不一样，都要注释说明这里不一样！！**

---

## 6. Chrome 插件规范 🔌

### 6.1 MV3 要求
- ✅ **Service Worker 无 DOM 访问**（使用 Offscreen Document）
- ❌ **禁止 `eval()` 和动态代码执行**
- ✅ **处理 Service Worker 休眠**（使用 `chrome.alarms`）

### 6.2 消息通信规范
**每个 Service 必须包含两部分**：

```typescript
// Popup 端调用
export const call*Service = async (msgNode: MessageNode, params: Params) => {
  return await msgNode.send(new DuplexMessage(ACTION_NAME, params));
};

// Background 端注册
export const register*Service = (messageHub: MessageHub) => {
  messageHub.registerSourceActionName('popup', ACTION_NAME);
  messageHub.on(ACTION_NAME, async (data, meta) => {
    try {
      const result = await processLogic(data);
      meta.resolve(result);
    } catch (error) {
      log.error('Service failed:', error);
      meta.reject(error);
    }
  });
};
```

- ✅ **新 Service 必须在 `src/service/index.ts` 的 `registerAll` 中注册**

### 6.3 Redux 状态管理规范

**读取状态（Popup 层）**：
- ✅ **使用 `useAppSelector` 读取 Redux 状态**（定义于 `src/store/hooks.ts`）
- ❌ **禁止直接使用 `useSelector`**（无类型检查，无深度比较）
- ✅ **必须配合 selector 函数使用**，不得直接在组件内写 `state => state.xxx`

```typescript
// ✅ Correct
import { useAppSelector } from '../../../store/hooks';
import { selectCurrency } from '../../../store/slices/settings';

const currency = useAppSelector(selectCurrency);

// ❌ Wrong
import { useSelector } from 'react-redux';
const currency = useSelector(state => state.settings.currency);
```

**Selector 命名约定**（定义于各 slice 文件）：
- `select*`：简单取值，直接返回 state 中的字段
- `get*`：计算型，依赖多个字段或有派生逻辑

```typescript
// select* - 简单取值
export const selectCurrency = (state: RootState) => state.settings.currency;

// get* - 有计算逻辑
export const getNodeList = (state: RootState) => ({
  ...NODES,
  ...state.nodeManagement.nodeList,
});
```

**`useAppSelector` 特性**（相比 `useSelector`）：
- 基于 `TypedUseSelectorHook<RootState>`，自动类型推导
- 使用 `_.isEqual` 深度比较，避免对象引用变化导致的不必要重渲染

**写入状态（全局）**：
- 🔒 **禁止在 Popup/Content Script 中直接 dispatch Redux action**
- ✅ **所有 Redux 状态更新必须通过 Background Service 执行**
- ✅ **使用 Service 模式：Popup 调用 `call*Service()` → Background 执行 `dispatch()`**

**原因**: 架构要求全局状态必须在 Background 维护，确保状态一致性。

---

## 7. useReducer 规范（页面级 hook.ts）

页面/弹窗的本地多字段状态统一用 `useReducer` 管理，**禁止用多个 `useState` 拼装**。模板源自 `src/popup/pages/*/hook.ts`。

### 7.1 文件结构（按顺序）

1. `interface State`：本地状态形状，字段类型必须显式声明。
2. `const initialState: State = { ... }`：必须显式标注 `: State`。
3. `type Action = ...`：**必须用 discriminated union**，每个分支形如 `{ type: 'XXX'; payload?: T }`，没有 payload 的分支只写 `{ type: 'XXX' }`。
4. `const reducer = (state: State, action: Action): State => { switch (action.type) { ... default: return state; } }`：必须有 `default: return state`。
5. `export const useXxxBiz = () => { const [state, dispatch] = useReducer(reducer, initialState); ... }`。

### 7.2 命名

- Action `type`：`UPPER_SNAKE_CASE` 字符串字面量（如 `SET_PROCESSING`、`TOGGLE_CONNECTED_ADDRESSES`）。
- 单值更新前缀 `SET_*`，布尔翻转前缀 `TOGGLE_*`，整体替换前缀 `UPDATE_*`，初始化用 `INIT`。
- 业务 hook 命名 `useXxxBiz`，置于同目录 `hook.ts` 中。

### 7.3 不可变更新

reducer 中只能用展开语法返回新对象，**禁止直接修改 `state`**：

```typescript
// ✅ Correct
case 'SET_PROCESSING':
  return { ...state, isProcessing: action.payload };

// ❌ Wrong
case 'SET_PROCESSING':
  state.isProcessing = action.payload;
  return state;
```

### 7.4 Dispatch 跨组件传递

需把 `dispatch` 传给子组件/工具函数时，统一用 `Dispatch<Action>` 别名：

```typescript
import { Dispatch } from 'react';
type LocalDispatch = Dispatch<Action>;
```

### 7.5 与 Redux 的边界

- 来自 Background 的全局状态：用 `useAppSelector`（见 6.3）。
- 仅当前页面/弹窗存活的 UI/流程状态：用 `useReducer`。
- 两者**禁止互相镜像**：不要把 Redux 字段拷到本地 reducer 维护，也不要在 reducer 里持久化业务数据。

---

## 8. GA 埋点规范（setGaEventV2）

### 8.1 函数选择

- ✅ **业务/系统埋点统一使用 `setGaEventV2`**（`src/popup/utils/gaUtils.ts`）
- ❌ **禁止使用旧版 `setGaEvent`**（保留仅为兼容）

### 8.2 调用形式

仅 UA 上报：
```typescript
setGaEventV2('AddWalletPage_Click_1');
```

UA + Measurement Protocol（GA4，事件名为 `m_<eventAction>`）：
```typescript
setGaEventV2('AddWalletPage_Click_1', { referrer: 'home' });
```

- ❌ **禁止占位传 `null`**：第三、第四参数当前未在函数体使用
  ```typescript
  // ❌ Wrong
  setGaEventV2('X_Click_1', null, null, otherParams);
  // ✅ Correct
  setGaEventV2('X_Click_1');
  ```
- ❌ **禁止再包 try/catch**：函数内置错误兜底

### 8.4 propertyObject

类型严格 `Record<string, string | number>`，**boolean 必须转字符串**：

```typescript
// ✅ Correct
setGaEventV2('X', { active: isActive ? 'true' : 'false' });
// ❌ Wrong
setGaEventV2('X', { active: isActive });
```

- 🔒 **禁止上报 PII**：助记词、私钥、密码、完整地址（必要时仅传哈希）、邮箱原文、财产信息、金额信息
- ❌ 不允许嵌套对象、数组、`null`、`undefined` 作为字段值

## 9. 请求后端接口

参考文档：docs/link-ai-prompt/roleflow/context/features/backend-request.md

---

**详细说明、代码示例、最佳实践请参考**: [project.md](../project.md) 第 7、10、11、13 节
