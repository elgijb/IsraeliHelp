# Журнал разработки IsraeliHelp (кратко, для учителя)

## Этап 1 — Создание проекта (24.11.2026)

**Реализовано**
- Maven-проект (WAR, Java 21+), Maven Wrapper — для запуска нужна только Java.
- Веб-сервер Jetty 12.1.15 (`./mvnw jetty:run` → http://localhost:8080).
- Структура MVC: пакеты `controller`, `service`, `dao`, `model`, `config`.
- Первый сервлет `HomeServlet` (GET `/`) → JSP `WEB-INF/views/home.jsp` с JSTL, UTF-8.
- `web.xml`: тайм-аут сессии 30 мин, HttpOnly-cookie, сессия только через cookie.
- `.gitignore` (исключены сборка и файл с паролем БД), README на иврите и русском, CURRENT_STATE.md.

**Основные команды:** `./mvnw clean package`, `./mvnw jetty:run`, `brew services start mysql`.

**Проверка:** сборка успешна; `GET /` → 200; иврит и русский отображаются; JSP в WEB-INF напрямую недоступна (404).

**Решённая проблема:** дублирование библиотеки JSTL (плагин Jetty уже содержит её) → `scope=provided`.

**AI:** Cursor (Claude Opus 5.5) — план и файлы этапа; подробно в `docs/ai/ai_log.md`.

**GitHub:** https://github.com/elgijb/IsraeliHelp

## Этап 2 — База данных (24.11.2026)

**Реализовано**
- `database/schema.sql`: база `IsraeliHelp` (utf8mb4), таблицы `users`, `events`, `applications`; PK, FK (ON DELETE CASCADE), UNIQUE(user_id, event_id), CHECK (1–500 волонтёров), ENUM-статусы, индексы.
- `database/sample_data.sql`: 4 вымышленных пользователя, 12 мероприятий в 10 городах, 8 заявок.
- `database/create_user.sql`: MySQL-пользователь приложения только с правами SELECT/INSERT/UPDATE/DELETE.
- `db.properties.example` (настоящий файл с паролем исключён из Git).
- `PasswordHasher` (PBKDF2-HMAC-SHA256 с солью) + 6 JUnit-тестов; хеши в тестовых данных созданы им.
- README: установка MySQL (macOS/Windows), создание базы, настройка подключения, учебные аккаунты.

**Основные команды:** `mysql -u root -p < database/schema.sql`, `mysql -u root -p < database/sample_data.sql`, `./mvnw test`.

**Проверка:** 6/6 тестов; повторная заявка → ошибка 1062; FK → 1452; CHECK → 3819; каскадное удаление работает; пользователь приложения не может выполнить DROP; данные сохраняются после перезапуска MySQL.

**Решённая проблема:** `mysql -e "source ..."` не работает в MySQL 26.10 → в README используется `<` (и `cmd /c` для PowerShell).

## Этап 3 — Дизайн и frontend (24.11.2026)

**Реализовано**
- Дизайн-система под 4 сценария (главная с проблемой, каталог, детальная страница, админ-таблица) — `docs/design/design-system.md`.
- CSS-токены, Inter + Heebo (локально), Lucide SVG, фото категорий (Pexels).
- i18n EN / HE (RTL) / RU: `LocaleFilter`, `LangServlet`, `i18n/messages*.properties`.
- JSP + сервлеты: `/`, `/events`, `/events/view`, `/about`, `/login`, `/register`, `/admin/events`.
- `DemoCatalog` — временные данные (совпадают с `sample_data.sql`) до JDBC на этапе 5.

**Команды:** `./mvnw jetty:run` → http://localhost:8080

**Проверка:** URL → 200; `?lang=ru` / `?lang=he` меняют интерфейс; фильтр `city=HAIFA` работает.

**Ограничения:** без JDBC; CRUD админки и обработка POST логина — этапы 6–7; ивритский UI — AI-перевод.
