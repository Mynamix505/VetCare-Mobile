export function createHealthRepository(database, redis) {
  return {
    checkDatabase: () => database.authenticate(),
    checkRedis: () => redis.ping(),
  };
}
