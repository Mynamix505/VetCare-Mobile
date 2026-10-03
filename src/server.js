import { createApp } from './app.js';
import { readEnv } from './config/env.js';
import { createDatabase } from './config/database.js';
import { createRedis } from './config/redis.js';
import { createHealthRepository } from './models/healthRepository.js';

async function main() {
  const config = readEnv();
  const database = createDatabase(config.DATABASE_URL);
  const redis = createRedis(config.REDIS_URL);
  const closeDependencies = () => Promise.allSettled([
    database.close(),
    Promise.resolve().then(() => { if (redis.isOpen) redis.destroy(); }),
  ]);

  try {
    const connections = await Promise.allSettled([database.authenticate(), redis.connect()]);
    if (connections.some(result => result.status === 'rejected')) {
      throw new Error('Cannot connect to PostgreSQL or Redis');
    }
    const app = createApp({
      healthRepository: createHealthRepository(database, redis),
      corsOrigins: config.corsOrigins,
    });
    const server = app.listen(config.PORT);
    await new Promise((resolve, reject) => {
      server.once('listening', resolve);
      server.once('error', reject);
    });
    console.info(`VetCare API listening on port ${config.PORT}`);
    let stopping = false;
    const shutdown = () => {
      if (stopping) return;
      stopping = true;
      const deadline = setTimeout(() => process.exit(1), 10000);
      deadline.unref();
      server.close(async () => {
        await closeDependencies();
        clearTimeout(deadline);
      });
    };
    process.once('SIGINT', shutdown);
    process.once('SIGTERM', shutdown);
  } catch (error) {
    await closeDependencies();
    throw error;
  }
}

main().catch(() => {
  console.error('Startup failed. Check environment variables and PostgreSQL/Redis availability.');
  process.exitCode = 1;
});
