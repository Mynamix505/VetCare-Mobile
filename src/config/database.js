import { Sequelize } from 'sequelize';

export function createDatabase(url) {
  return new Sequelize(url, {
    dialect: 'postgres',
    logging: false,
    pool: { max: 5, min: 0, acquire: 5000, idle: 10000 },
    dialectOptions: { connectionTimeoutMillis: 5000, statement_timeout: 5000 },
    retry: { max: 0 },
  });
}
