import { randomUUID } from 'node:crypto';

export function requestLogger(logger = console) {
  return (req, res, next) => {
    req.id = randomUUID();
    res.setHeader('X-Request-Id', req.id);
    const started = performance.now();
    res.on('finish', () => logger.info({
      requestId: req.id,
      method: req.method,
      status: res.statusCode,
      durationMs: Math.round(performance.now() - started),
    }));
    next();
  };
}
