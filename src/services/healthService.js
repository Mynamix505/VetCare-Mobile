import { withTimeout } from '../utils/withTimeout.js';

export function createHealthService(repository, timeoutMs = 2000) {
  return {
    async readiness() {
      const results = await Promise.allSettled([
        withTimeout(() => repository.checkDatabase(), timeoutMs),
        withTimeout(() => repository.checkRedis(), timeoutMs),
      ]);
      const healthy = results.every(result => result.status === 'fulfilled');
      return {
        status: healthy ? 'ok' : 'unavailable',
        dependencies: {
          database: results[0].status === 'fulfilled' ? 'up' : 'down',
          redis: results[1].status === 'fulfilled' ? 'up' : 'down',
        },
      };
    },
  };
}
