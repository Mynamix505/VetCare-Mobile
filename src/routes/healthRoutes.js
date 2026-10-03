import { Router } from 'express';
import { createHealthController } from '../controllers/healthController.js';

export function createHealthRoutes(service) {
  const router = Router();
  const controller = createHealthController(service);
  router.get('/', controller.live);
  router.get('/ready', controller.ready);
  return router;
}
