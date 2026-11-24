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
