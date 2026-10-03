import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import { createHealthRoutes } from './routes/healthRoutes.js';
import { createHealthService } from './services/healthService.js';
import { requestLogger } from './middlewares/requestLogger.js';
import { createErrorHandler, notFound } from './middlewares/errorHandler.js';

export function createApp({ healthRepository, corsOrigins = [], logger = console }) {
  const app = express();
  app.disable('x-powered-by');
  app.use(requestLogger(logger));
  app.use(helmet());
  app.use(cors({ origin: corsOrigins }));
  app.use(express.json({ limit: '100kb' }));
  app.use('/api/v1/health', createHealthRoutes(createHealthService(healthRepository)));
  app.use(notFound);
  app.use(createErrorHandler(logger));
  return app;
}
