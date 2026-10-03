import { z } from 'zod';

const schema = z.object({
  NODE_ENV: z.enum(['development', 'test', 'production']).default('development'),
  PORT: z.coerce.number().int().min(1).max(65535).default(3000),
  DATABASE_URL: z.url().refine(value => /^postgres(?:ql)?:/.test(value)),
  REDIS_URL: z.url().refine(value => /^rediss?:/.test(value)),
  CORS_ORIGINS: z.string().default(''),
});

export function readEnv(source = process.env) {
  const result = schema.safeParse(source);
  if (!result.success) {
    const keys = [...new Set(result.error.issues.map(issue => issue.path.join('.')))];
    throw new Error(`Invalid environment variables: ${keys.join(', ')}`);
  }
  return {
    ...result.data,
    corsOrigins: result.data.CORS_ORIGINS.split(',').map(value => value.trim()).filter(Boolean),
  };
}
