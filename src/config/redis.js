import { createClient } from 'redis';

export function createRedis(url, logger = console) {
  const client = createClient({
    url,
    disableOfflineQueue: true,
    socket: { connectTimeout: 5000, reconnectStrategy: false },
  });
  client.on('error', () => logger.error('Redis connection error'));
  return client;
}
