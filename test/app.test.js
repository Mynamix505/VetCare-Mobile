import { test } from 'node:test';
import assert from 'node:assert/strict';
import { createApp } from '../src/app.js';
import { readEnv } from '../src/config/env.js';

const healthy = { checkDatabase: async () => {}, checkRedis: async () => 'PONG' };
const logger = { info() {}, error() {} };

async function start(t, repository = healthy) {
  const app = createApp({ healthRepository: repository, logger, corsOrigins: ['https://vetcare.example'] });
  const server = app.listen(0, '127.0.0.1');
  await new Promise((resolve, reject) => {
    server.once('listening', resolve);
    server.once('error', reject);
  });
  t.after(() => new Promise(resolve => {
    server.close(resolve);
    server.closeAllConnections();
  }));
  return `http://127.0.0.1:${server.address().port}`;
}

test('liveness and readiness return healthy HTTP responses', async t => {
  const url = await start(t);
  const live = await fetch(`${url}/api/v1/health`);
  assert.equal(live.status, 200);
  assert.deepEqual(await live.json(), { status: 'ok' });
  assert.ok(live.headers.get('x-request-id'));
  assert.equal(live.headers.get('x-powered-by'), null);
  const ready = await fetch(`${url}/api/v1/health/ready`);
  assert.equal(ready.status, 200);
  assert.deepEqual(await ready.json(), { status: 'ok', dependencies: { database: 'up', redis: 'up' } });
});

test('database failure returns 503 without exposing connection secrets', async t => {
  const url = await start(t, { ...healthy, checkDatabase: async () => { throw new Error('secret-password'); } });
  const response = await fetch(`${url}/api/v1/health/ready`);
  assert.equal(response.status, 503);
  assert.deepEqual(await response.json(), { status: 'unavailable', dependencies: { database: 'down', redis: 'up' } });
  assert.equal((await fetch(`${url}/api/v1/health`)).status, 200);
});

test('unknown routes and malformed or oversized bodies have JSON errors', async t => {
  const url = await start(t);
  const missing = await fetch(`${url}/missing`);
  assert.equal(missing.status, 404);
  assert.equal((await missing.json()).error.code, 'NOT_FOUND');
  const malformed = await fetch(`${url}/missing`, {
    method: 'POST', headers: { 'Content-Type': 'application/json' }, body: '{',
  });
  assert.equal(malformed.status, 400);
  assert.equal((await malformed.json()).error.code, 'INVALID_JSON');
  const oversized = await fetch(`${url}/missing`, {
    method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ value: 'a'.repeat(103000) }),
  });
  assert.equal(oversized.status, 413);
  assert.equal((await oversized.json()).error.code, 'BODY_TOO_LARGE');
});

test('CORS allows only configured browser origins', async t => {
  const url = await start(t);
  const allowed = await fetch(`${url}/api/v1/health`, { headers: { Origin: 'https://vetcare.example' } });
  assert.equal(allowed.headers.get('access-control-allow-origin'), 'https://vetcare.example');
  const denied = await fetch(`${url}/api/v1/health`, { headers: { Origin: 'https://other.example' } });
  assert.equal(denied.headers.get('access-control-allow-origin'), null);
});

test('environment validation rejects invalid ports and missing connections', () => {
  assert.throws(() => readEnv({}), /DATABASE_URL/);
  const base = { DATABASE_URL: 'postgres://localhost/vetcare', REDIS_URL: 'redis://localhost:6379' };
  assert.equal(readEnv(base).PORT, 3000);
  assert.throws(() => readEnv({ ...base, PORT: '70000' }), /PORT/);
  assert.throws(() => readEnv({ ...base, DATABASE_URL: 'https://localhost' }), /DATABASE_URL/);
});
