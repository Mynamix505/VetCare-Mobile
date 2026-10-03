import { test } from 'node:test';
import assert from 'node:assert/strict';
import { createHealthService } from '../src/services/healthService.js';

test('reports both available dependencies', async () => {
  const service = createHealthService({ checkDatabase: async () => {}, checkRedis: async () => 'PONG' });
  assert.deepEqual(await service.readiness(), {
    status: 'ok', dependencies: { database: 'up', redis: 'up' },
  });
});

test('handles synchronous and asynchronous dependency failures', async () => {
  const service = createHealthService({
    checkDatabase() { throw new Error('private connection string'); },
    async checkRedis() { throw new Error('private redis URL'); },
  });
  assert.deepEqual(await service.readiness(), {
    status: 'unavailable', dependencies: { database: 'down', redis: 'down' },
  });
});

test('bounds readiness wait when a dependency hangs', async () => {
  const service = createHealthService({
    checkDatabase: async () => {},
    checkRedis: () => new Promise(() => {}),
  }, 20);
  assert.deepEqual(await service.readiness(), {
    status: 'unavailable', dependencies: { database: 'up', redis: 'down' },
  });
});
