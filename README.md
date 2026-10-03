# VetCare Mobile — Backend

Початкова реалізація архітектури з `codex.md`: Express, PostgreSQL (Sequelize), Redis, Zod. План і стан робіт — у [PLAN.md](PLAN.md).

## Локальний запуск

Потрібні Node.js 24+ і npm. Для залежностей потрібен Docker Compose або окремі PostgreSQL та Redis.

```powershell
npm.cmd install
Copy-Item .env.example .env
docker compose up -d
npm.cmd run dev
```

Якщо PostgreSQL/Redis запущені окремо, пропустіть Docker і задайте їх адреси в `.env`. При відсутності будь-якої залежності сервер завершується з кодом 1. У PowerShell використовується `npm.cmd`, щоб не залежати від політики запуску `.ps1`. В інших оболонках можна використовувати `npm`.

`compose.yaml` призначений для локальної розробки: порти прив'язані до localhost, облікові дані тестові. `.env` не додається до Git. Таблиці автоматично не створюються; міграції будуть додані на етапі моделювання даних.

## Доступні endpoints

| Метод | Шлях | Результат |
|---|---|---|
| GET | `/api/v1/health` | 200, процес обробляє HTTP |
| GET | `/api/v1/health/ready` | 200, якщо PostgreSQL і Redis доступні; інакше 503 |

Readiness має обмеження очікування 2 секунди. При розриві Redis-з'єднання автоматичне перепідключення наразі вимкнене: readiness поверне 503, потрібен перезапуск процесу. Авторизація, питомці та прийоми ще не реалізовані.

## Перевірки

```powershell
npm.cmd test
```

Тести використовують справжній HTTP-сервер та підмінені перевірки залежностей: успішні відповіді, відмова БД, таймаут Redis, CORS, некоректний JSON, ліміт тіла та конфігурація. Це не інтеграційна перевірка PostgreSQL/Redis.

Стан перевірки у поточному середовищі: синтаксис JS перевірено; 3 тести `node --test test/healthService.test.js` пройшли. Встановлення пакетів заблоковане мережевою помилкою `EACCES`, тому HTTP-тести не запущені успішно і lock-файл ще не створений. Docker недоступний. Після першого встановлення збережіть `package-lock.json`; для подальших відтворюваних встановлень використовуйте `npm.cmd ci`.

Після запуску інфраструктури:

```powershell
Invoke-RestMethod http://localhost:3000/api/v1/health
Invoke-RestMethod http://localhost:3000/api/v1/health/ready
```

## Структура

`routes` визначають маршрути, `controllers` працюють із HTTP, `services` містять логіку, `models` — доступ до даних. `config` створює клієнти й перевіряє середовище, `middlewares` обробляють журналювання та помилки, `utils` містить допоміжні функції. Імпорт `app.js` не підключається до БД і не відкриває порт.

Використані офіційні довідники: [Express — помилки](https://expressjs.com/en/5x/guide/error-handling/), [Sequelize — підключення](https://sequelize.org/docs/v6/getting-started/), [Redis — Node.js](https://redis.io/docs/latest/clients/nodejs/).
