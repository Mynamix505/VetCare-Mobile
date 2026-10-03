export function createHealthController(service) {
  return {
    live(_req, res) {
      res.json({ status: 'ok' });
    },
    async ready(_req, res) {
      const result = await service.readiness();
      res.status(result.status === 'ok' ? 200 : 503).json(result);
    },
  };
}
