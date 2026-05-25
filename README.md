# Task Tracker (mywebapp)

Лабораторна робота №1: розгортання web-сервісу з автоматизацією (DevOps KPI).

## Варіант (N = 1)

- **N** — порядковий номер у списку групи: **1**
- **V2** = (N % 2) + 1 = **2** → конфігурація: файл `/etc/mywebapp/config.yaml`; БД: **PostgreSQL**
- **V3** = (N % 3) + 1 = **2** → застосунок: **Task Tracker**
- **V5** = (N % 5) + 1 = **2** → порт застосунку: **5200**

### Мережа

| Компонент | Адреса | Порт |
|-----------|--------|------|
| nginx | 0.0.0.0 | 80 |
| mywebapp | 127.0.0.1 | 5200 |
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

### Локальна розробка

```bash
pnpm install
cp deploy/config.example.yaml config.local.yaml
pnpm run migrate -- --config config.local.yaml
pnpm start -- --config config.local.yaml
```

### API

| Метод | Шлях | Опис |
|-------|------|------|
| GET | / | Список ендпоінтів (text/html) |
| GET | /tasks | Список задач |
| POST | /tasks | Створити задачу `{ "title": "..." }` |
| POST | /tasks/:id/done | Відмітити задачу виконаною |
| GET | /health/alive | Стан процесу (не публікується через nginx) |
| GET | /health/ready | Готовність (БД) (не публікується через nginx) |

## Розгортання на ВМ

### Базовий образ та ресурси

- Образ: Ubuntu 22.04 LTS — `ubuntu/jammy64`
- Ресурси: 1 CPU, 1024 MB RAM
- Конфігурація застосунку: `/etc/mywebapp/config.yaml`

### Вхід на ВМ

- `vagrant up`, потім `vagrant ssh`
- Користувачі: `student`, `teacher`, `operator` — пароль `12345678` (зміна при першому вході)
- Користувач `vagrant` після provision заблокований
- Сервіс: системний користувач `mywebapp`

### Запуск автоматизації

```bash
vagrant up
```

Provision (`scripts/provision.sh`): пакети, користувачі, PostgreSQL, копія застосунку в `/opt/mywebapp`, `config.yaml`, systemd socket activation, nginx, `/home/student/gradebook`.

Після provision: http://localhost:8080 (порт 80 гостя проброшений на 8080 хоста).

### Тестування

З хоста:

```bash
curl http://localhost:8080/
curl http://localhost:8080/tasks
curl -X POST http://localhost:8080/tasks -H "Content-Type: application/json" -d "{\"title\":\"Test\"}"
```

Health зсередини ВМ:

```bash
vagrant ssh
curl http://127.0.0.1:5200/health/alive
curl http://127.0.0.1:5200/health/ready
```

Користувач `operator`:

```bash
sudo systemctl status mywebapp
sudo systemctl restart mywebapp
sudo systemctl reload nginx
```
