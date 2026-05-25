# Task Tracker (mywebapp)

Лабораторна робота №1: розгортання web-сервісу з автоматизацією (DevOps KPI).

## Варіант (N = 1)

- **N** — порядковий номер у списку групи: **1**
- **V2** = (N % 2) + 1 = **2** → конфігурація: файл `/etc/mywebapp/config.yaml`; БД: **PostgreSQL**
- **V3** = (N % 3) + 1 = **2** → застосунок: **Task Tracker**
- **V5** = (N % 5) + 1 = **2** → порт застосунку: **8080**

### Мережа

| Компонент | Адреса | Порт |
|-----------|--------|------|
| nginx | 0.0.0.0 | 80 |
| mywebapp | 127.0.0.1 | 8080 |
| PostgreSQL | 127.0.0.1 | 5432 |

## Веб-застосунок

Task Tracker — сервіс для відстеження задач.

- Поля задачі: `id`, `title`, `status`, `created_at`
- `GET /tasks` — список усіх задач
- `POST /tasks` (`{ "title": "..." }`) — створити задачу
- `POST /tasks/:id/done` — статус «виконано»
- `GET /health/alive` — завжди `200 OK`
- `GET /health/ready` — `200 OK`, якщо БД доступна; інакше `500`
- `GET /` — лише `text/html`, список ендпоінтів бізнес-логіки

API віддає `application/json` або `text/html` за заголовком `Accept` (простий HTML без JS/CSS).

## Стек

- Node.js 24 LTS, pnpm
- PostgreSQL
- nginx, systemd (socket activation)
