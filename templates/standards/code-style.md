# 代码风格规范

## 基本原则

- TypeScript 严格模式
- ESLint + Prettier 统一代码风格
- 函数职责单一，避免过度设计
- 错误处理统一使用 try-catch + 日志记录
- 避免阻塞主线程（链上查询使用异步）
- **代码注释**：使用英文（国际化和专业性）
- **文档语言**：`docs/link-ai-prompt/roleflow/` 目录下的文档使用中文（便于团队维护）

## TypeScript 类型规范

```typescript
// ✅ 正确：明确类型
interface UserData {
  id: string;
  name: string;
  balance: number;
}

function processUser(user: UserData): string {
  return `${user.name}: ${user.balance}`;
}

// ❌ 错误：使用 any
function processUser(user: any): any {
  return user.name + ': ' + user.balance;
}
```

## 尽量使用枚举类型，而不是"|"
```typescript
// ✅ 正确：使用枚举类型，且枚举类型的命名一定要足够长
export enum VersionUpdateModelContentType {
  FULL_UPDATE = 'FULL_UPDATE',
  URGENT_UPDATE = 'URGENT_UPDATE',
}

interface State {
  isVisible: boolean;
  contentType: VersionUpdateModelContentType | null;
}

// ❌ 错误：使用 "|"
interface State {
  isVisible: boolean;
  contentType: 'FULL_UPDATE' | 'URGENT_UPDATE' | null;
}
```

## 错误处理规范

```typescript
// ✅ 正确：添加 try-catch 处理 await 异步
async function fetchUserData(userId: string): Promise<UserData | null> {
  try {
    const response = await api.getUser(userId);
    return response.data;
  } catch (error) {
    log.error('Failed to fetch user data:', error);
    Toast.show({
      icon: 'fail',
      content: formatMessage({ id: 'ERROR.FETCH_USER_FAILED' }),
    });
    return null;
  }
}

// ❌ 错误：静默失败
async function fetchUserData(userId: string): Promise<UserData> {
  const response = await api.getUser(userId);
  return response.data; // 异常未处理
}
```

## import 文件顺序
顺序如下：
[库方法]
[同项目其他的页面、组件、type、方法]
间隔一行
[svg等图片、音视频资源类文件]
间隔一行
[scss文件]

```typescript
// ✅ 正确
import react from 'react'
import { functionName } from '../../utils'

import img from '../images/image.svg'

import styles from './scssFile.m.scss';

// ❌ 错误
import { functionName } from '../../utils'

import img from '../images/image.svg'

import styles from './scssFile.m.scss';
import react from 'react'
```
