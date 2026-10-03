# 🏛️ Back-end Development Codex — VetCare Mobile
> **Проєкт:** Мобільний застосунок для ветеринарної клініки («VetCare Mobile»)  
> **Команда:** VetTech Solutions  
> **Розробник:** Яровий Михайло Сергійович (Група КН-42)  
> **Стек технологій:** Node.js (Express.js), PostgreSQL (Prisma ORM / Sequelize), Redis, JWT, Express-Validator / Zod  

---

## 📌 1. Загальні принципи та Архітектура (Layered Architecture)

Для забезпечення модульності та зручності тестування Back-end сервер розбивається на 4 чіткі рівні (Layers):

1. **Routes (Маршрутизація):** Визначення ендпоінтів API та підключення Middleware (auth, validation).
2. **Controllers (Контролери):** Обробка HTTP-запитів, витягування даних із `req.body` / `req.params`, повернення відповіді `res.status().json()`.
3. **Services (Бізнес-логіка):** Основна логіка застосунку (перевірка вільних слотів лікаря, розрахунок дати вакцинації, виклики зовнішніх API).
4. **Repositories / Models (Рівень даних):** Пряма взаємодія з базою даних через ORM.

### 📂 Структура каталогу проєкту (`/src`):
```text
src/
├── config/             # Конфігурації (БД, Redis, JWT, CORS)
├── controllers/        # Контролери (PetController, AppointmentController і т.д.)
├── middlewares/        # Auth, Validation, Error Handler, Logger
├── models/             # ORM-схеми / Моделі (Prisma / Sequelize)
├── routes/             # Маршрути API (/api/v1/pets, /api/v1/appointments)
├── services/           # Бізнес-логіка застосунку
├── utils/              # Хелпери (форматування дат, JWT-генератори)
├── app.js              # Ініціалізація Express застосунку
└── server.js           # Точка входу (запуск сервера)