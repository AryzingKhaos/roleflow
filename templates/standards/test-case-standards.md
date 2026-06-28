# 测试用例编写标准

> 以案例为主，展示项目中常用测试技巧

---

## 1. 测试数据准备

### 常量对象
```typescript
const gasPriceObj = {
  low: { suggestedMaxFeePerGas: '73.855668472' },
  medium: { suggestedMaxFeePerGas: '88.75362107' },
  high: { suggestedMaxFeePerGas: '113.662874969' },
};

const transaction = {
  gas: { gasLimit: '21000' },
  txParams: { from: '0x123...', to: '0x456...' },
};
```

### Helper 函数 + Partial 覆盖
```typescript
const createTestToken = (overrides: Partial<WatchedToken> = {}): WatchedToken => ({
  userAddress: TEST_USER_ADDRESS,
  chainId: TEST_CHAIN_ID,
  tokenId: 'test-token-id',
  type: TokenType.TRC20,
  name: 'Test Token',
  precision: 6,
  ...overrides,
});

// 使用
const token = createTestToken({ name: 'Custom Token', precision: 18 });
```

---

## 2. Mock 技巧

### Mock 类
```typescript
class MockWebSocket {
  static OPEN = 1;
  url: string;
  readyState: number;
  onmessage: ((event: MessageEvent) => void) | null = null;

  constructor(url: string) {
    this.url = url;
    this.readyState = MockWebSocket.CONNECTING;
    setTimeout(() => {
      this.readyState = MockWebSocket.OPEN;
      this.dispatchEvent('open', {});
    }, 10);
  }

  send(data: string) { /* ... */ }
  close() { /* ... */ }
  simulateMessage(data: any) { /* 自定义测试方法 */ }
}

(global as any).WebSocket = MockWebSocket;
```

### Mock 模块
```typescript
jest.mock('../../service/backend_service/common', () => ({
  getOpenAPICommonHeaders: jest.fn(() => ({
    'x-api-key': 'test-key',
    timestamp: '1234567890',
  })),
}));
```

### Mock 函数
```typescript
beforeEach(() => {
  jest.clearAllMocks();

  // Mock 模块导出
  (storeModule.getStore as jest.Mock) = jest.fn().mockReturnValue(testStore);

  // Mock spy
  jest.spyOn(ga_measurement_protocol, 'sendMeasurementProtocolGaEvent');
});
```

### Mock 全局对象
```typescript
// Mock window 对象
Object.defineProperty(window, 'ga', {
  writable: true,
  value: jest.fn().mockImplementation(() => ({})),
});

// Mock navigator
Object.defineProperty(global, 'navigator', {
  value: {
    userAgent: 'Mozilla/5.0 ... Chrome/120.0.0.0 ...',
  },
  writable: true,
});
```

---

## 3. 生命周期钩子

```typescript
describe('IndexedDBManager', () => {
  let manager: IndexedDBManager;

  beforeEach(async () => {
    jest.clearAllMocks();
    manager = IndexedDBManager.getInstance();
    await manager.initDatabase();
  });

  afterEach(async () => {
    try {
      await manager.clearUserTokens();
      await manager.closeDatabase();
    } catch (error) {
      // ignore
    }

    const deleteRequest = indexedDB.deleteDatabase('indexDBName');
    await new Promise<void>((resolve) => {
      const timeout = setTimeout(() => resolve(), 500);
      deleteRequest.onsuccess = () => {
        clearTimeout(timeout);
        resolve();
      };
    });
  });
});
```

---

## 4. 断言技巧

### 基础匹配
```typescript
// 精确匹配
expect(result).toBe('1');
expect(count).toBe(42);

// 深度匹配（对象/数组）
expect(obj).toEqual({ name: 'Test', value: 100 });

// 字符串部分匹配
expect(res).toMatch('< 0.001');

// 存在性
expect(token).toBeDefined();
expect(token).toBeUndefined();

// 真值
expect(status).toBe(true);
expect(status).toBeTruthy();

// 长度
expect(tokens).toHaveLength(3);
```

### 函数调用
```typescript
// 被调用
expect(mockFn).toHaveBeenCalled();
expect(mockFn).not.toHaveBeenCalled();

// 调用参数
expect(sendSpy).toHaveBeenCalledWith('test message');
expect(sendSpy).toHaveBeenCalledWith({ type: 'ping' });

// 调用次数
expect(mockFn).toHaveBeenCalledTimes(2);
```

### 异常
```typescript
// 同步异常
expect(() => {
  wsManager.send('test');
}).toThrow(WebSocketNotConnectedError);

// 异步成功
await expect(manager.addToken(token)).resolves.not.toThrow();

// 异步异常
await expect(manager.addToken(null)).rejects.toThrow();
```

### 属性检查
```typescript
expect(status).toHaveProperty('status');
expect(status).toHaveProperty('config.autoReconnect');
```

---

## 5. 异步测试

### async/await
```typescript
test('should add token successfully', async () => {
  const token = createTestToken();

  await manager.addToken(token);

  const retrieved = await manager.getToken(
    token.userAddress,
    token.chainId,
    token.tokenId,
    token.type,
  );

  expect(retrieved).toBeDefined();
  expect(retrieved?.name).toBe(token.name);
});
```

### 延时测试
```typescript
test('should send heartbeat', async () => {
  await manager.connect(testUrl);

  const sendSpy = jest.spyOn(manager, 'send');

  await new Promise((resolve) => setTimeout(resolve, 150));

  expect(sendSpy).toHaveBeenCalledWith({ type: 'ping' });
});
```

### 时间序列
```typescript
test('should update timestamp on data update', async () => {
  await manager.setUserData(address, chainId, category, { value: 'initial' });
  const record1 = await manager.getUserDataWithMetadata(address, chainId, category);

  await new Promise((resolve) => setTimeout(resolve, 10));

  await manager.setUserData(address, chainId, category, { value: 'updated' });
  const record2 = await manager.getUserDataWithMetadata(address, chainId, category);

  expect(record2?.updatedAt).toBeGreaterThan(record1?.updatedAt || 0);
});
```

---

## 6. 测试组织

### describe 嵌套
```typescript
describe('WebSocketManager', () => {
  describe('constructor', () => {
    test('should initialize with default config', () => { /* ... */ });
    test('should initialize with custom config', () => { /* ... */ });
  });

  describe('connect', () => {
    test('should connect successfully', async () => { /* ... */ });
    test('should not reconnect if already connected', async () => { /* ... */ });
  });

  describe('error handling', () => {
    test('should emit error event', async () => { /* ... */ });
  });
});
```

### 共享测试数据
```typescript
describe('Query Token', () => {
  const TEST_USER_ADDRESS = 'TMVQGm1qAQYVdetCeGRRkTWYYrLXuHK2HC';
  const TEST_CHAIN_ID = 'mainnet';

  beforeEach(async () => {
    const tokens = [
      createTestToken({ tokenId: 'token1', chainId: TEST_CHAIN_ID }),
      createTestToken({ tokenId: 'token2', chainId: TEST_CHAIN_ID }),
    ];
    await manager.batchAddTokens(tokens);
  });

  test('should get tokens by user and chain', async () => { /* ... */ });
  test('should get specific token', async () => { /* ... */ });
});
```

---

## 7. 事件测试

### 事件监听
```typescript
test('should emit open event', async () => {
  const openSpy = jest.fn();
  wsManager.on('open', openSpy);

  await wsManager.connect(testUrl);

  expect(openSpy).toHaveBeenCalledWith(testUrl, wsManager);
});
```

### 事件序列
```typescript
test('should update status during connection', async () => {
  const statusChangeSpy = jest.fn();
  wsManager.on('statusChange', statusChangeSpy);

  const connectPromise = wsManager.connect(testUrl);

  expect(statusChangeSpy).toHaveBeenCalledWith('connecting', 'disconnected');

  await connectPromise;

  expect(statusChangeSpy).toHaveBeenCalledWith('connected', 'connecting');
});
```

---

## 8. 边界与异常测试

### 边界情况
```typescript
describe('test formatNumber', () => {
  it('input number is NaN', () => {
    const res = formatNumber('--', {});
    expect(res).toMatch('--');
  });

  it('input number less than 0 and keepPositive is true', () => {
    const res = formatNumber(-1, { keepPositive: true });
    expect(res).toMatch('--');
  });

  it('miniText has value, input number less than miniText', () => {
    const res = formatNumber(0.000001, { miniText: 0.001, miniTextNoZero: true });
    expect(res).toMatch('< 0.001');
  });
});
```

### 空值处理
```typescript
test('should handle empty array in batch add', async () => {
  await expect(manager.batchAddTokens([])).resolves.not.toThrow();
});

test('should return undefined for non-existent token', async () => {
  const token = await manager.getToken(address, chainId, 'nonexistent', TokenType.TRC20);
  expect(token).toBeUndefined();
});
```

### 错误处理
```typescript
test('should throw error when not connected', () => {
  expect(() => {
    wsManager.send('test');
  }).toThrow(WebSocketNotConnectedError);
});

test('should not throw when deleting non-existent data', async () => {
  await expect(
    manager.deleteUserData('NonExistent', TEST_CHAIN_ID, TEST_CATEGORY),
  ).resolves.not.toThrow();
});
```

---

## 9. Spy 技巧

### 监听方法调用
```typescript
test('should send JSON message', async () => {
  await wsManager.connect(testUrl);

  const mockWs = (wsManager as any).ws;
  const sendSpy = jest.spyOn(mockWs, 'send');

  const testData = { type: 'test', data: 'value' };
  wsManager.send(testData);

  expect(sendSpy).toHaveBeenCalledWith(JSON.stringify(testData));
});
```

### 访问私有属性
```typescript
test('should access internal state', async () => {
  await wsManager.connect(testUrl);

  const mockWs = (wsManager as any).ws as MockWebSocket;
  mockWs.simulateMessage({ type: 'response' });

  expect(mockWs.readyState).toBe(MockWebSocket.OPEN);
});
```

---

## 10. 复杂场景

### 多次操作验证
```typescript
test('should filter duplicate tokens in batch add', async () => {
  const token = createTestToken();

  await manager.addToken(token);

  const tokens = [
    token,
    createTestToken({ tokenId: 'token2', name: 'Token 2' }),
  ];

  await manager.batchAddTokens(tokens);

  const retrievedTokens = await manager.getTokensByUserAndChain(
    TEST_USER_ADDRESS,
    TEST_CHAIN_ID,
  );

  expect(retrievedTokens).toHaveLength(2);
});
```

### 状态变化验证
```typescript
test('should preserve _id when updating', async () => {
  await manager.setUserData(address, chainId, category, { value: 'initial' });

  const record1 = await manager.getUserDataWithMetadata(address, chainId, category);

  await manager.batchSetUserData([
    { userAddress: address, chainId, category, data: { value: 'updated' }, updatedAt: 0 },
  ]);

  const record2 = await manager.getUserDataWithMetadata(address, chainId, category);

  expect(record1?._id).toBe(record2?._id);
  expect(record2?.data).toEqual({ value: 'updated' });
});
```

---

## 11. 条件测试

### 分支覆盖
```typescript
describe('test getEstimateGasFeeFallback', () => {
  test('for EIP1559', () => {
    const result = getEstimateGasFeeFallback(true, transactionSupport1559, gasPriceObj);
    expect(result).toEqual({
      hexMaximumTransactionFee: '1863826.04247',
      hexMinimumTransactionFee: '1495857.233976',
    });
  });

  test('for non-EIP1559', () => {
    const result = getEstimateGasFeeFallback(false, transactionNot1559, gasPriceObj);
    expect(result).toEqual({
      hexMaximumTransactionFee: '1050000',
      hexMinimumTransactionFee: '1050000',
    });
  });
});
```

### 环境差异
```typescript
it('should return true for Chrome version >= 116', () => {
  Object.defineProperty(global, 'navigator', {
    value: { userAgent: '... Chrome/120.0.0.0 ...' },
    configurable: true,
  });

  expect(isSupportWebSocket()).toBe(true);
});

it('should return false for Chrome version < 116', () => {
  Object.defineProperty(global, 'navigator', {
    value: { userAgent: '... Chrome/115.0.0.0 ...' },
    configurable: true,
  });

  expect(isSupportWebSocket()).toBe(false);
});
```

---

## 12. 数据完整性

```typescript
test('should preserve all fields of added token', async () => {
  const originalToken = createTRC721Token();

  await manager.addToken(originalToken);

  const retrievedToken = await manager.getToken(
    originalToken.userAddress,
    originalToken.chainId,
    originalToken.tokenId,
    originalToken.type,
  );

  expect(retrievedToken).toBeDefined();
  expect(retrievedToken?.userAddress).toBe(originalToken.userAddress);
  expect(retrievedToken?.chainId).toBe(originalToken.chainId);
  expect(retrievedToken?.tokenId).toBe(originalToken.tokenId);
  expect(retrievedToken?.type).toBe(originalToken.type);
  expect(retrievedToken?.name).toBe(originalToken.name);
  expect(retrievedToken?.precision).toBe(originalToken.precision);
});
```

---

**最后更新**: 2026-03-19
