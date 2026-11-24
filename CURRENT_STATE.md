# CURRENT_STATE — IsraeliHelp

## Текущее состояние (обновлено: 24.11.2026)

**Что уже работает**
- Каркас Maven-проекта (`pom.xml`, упаковка WAR, Java 21+).
- Maven Wrapper (`mvnw`, `mvnw.cmd`): на другом компьютере достаточно установить только Java.
- Веб-сервер Jetty 12.1.15 запускается командой `./mvnw jetty:run`, сайт открывается на http://localhost:8080.
- Проверочная страница: сервлет `HomeServlet` передаёт данные в JSP `home.jsp`, JSTL `<c:out>` работает, UTF-8 (иврит и русский) отображается правильно.
- Структура пакетов: `controller`, `service`, `dao`, `model`, `config`.

**Что пока не реализовано**
- База данных MySQL (этап 2).
- Дизайн, страницы сайта, переключение языков (этап 3).
- JavaScript-валидация, CRUD, пользователи, Session/Application, XML/XSD, тесты, портфолио (этапы 4–12).
- Удалённый репозиторий на GitHub: нужен вход пользователя через `gh auth login`.

**Известные ошибки и предупреждения**
- При запуске Jetty выводит 3 предупреждения `The XML schema [...] could not be found` — это внутренние сообщения компилятора JSP (Jasper), на работу сайта не влияют.

**Следующая задача**
- Этап 2: `database/schema.sql`, `database/sample_data.sql`, MySQL-пользователь проекта, `db.properties.example`.

**Последние результаты тестирования (24.11.2026)**
- `./mvnw clean package` — BUILD SUCCESS, создан `target/israelihelp.war`.
- `./mvnw jetty:run` — сервер запущен, `GET /` → 200, страница показывает время сервера, версию Java и строку `English · עברית · Русский`.
- `GET /WEB-INF/views/home.jsp` → 404 (JSP недоступна напрямую — так и задумано).
- `GET /nope` → 404.

---

## История работы

### 24.11.2026 — Этап 1: создание проекта

**Задача:** создать каркас проекта, настроить Java-среду, README, CURRENT_STATE, .gitignore, первый commit.

**Что сделано**
- Проверено окружение: Maven 3.10.1, OpenJDK 27 (Homebrew), Oracle JDK 25, MySQL 26.10, Git 2.50.
- В `~/.zshrc` добавлены `JAVA_HOME` и `PATH` для Homebrew OpenJDK (раньше команда `java` не находилась).
- Запущена служба MySQL (`brew services start mysql`), проверен вход `mysql -u root`.
- Установлен GitHub CLI (`brew install gh`).
- Создан `pom.xml` (Servlet API 6.0, JSTL 3.0, mysql-connector-j, JUnit 6, плагин Jetty 12.1.15).
- Сгенерирован Maven Wrapper (`mvn -N wrapper:wrapper`).
- Созданы `web.xml`, `HomeServlet`, `home.jsp`, `package-info.java` для пяти пакетов, `.gitignore`.
- README на иврите и русском, два дневника, журнал AI.

**Изменённые файлы:** `pom.xml`, `mvnw`, `mvnw.cmd`, `.mvn/wrapper/maven-wrapper.properties`, `.gitignore`, `src/main/webapp/WEB-INF/web.xml`, `src/main/webapp/WEB-INF/views/home.jsp`, `src/main/java/il/israelihelp/controller/HomeServlet.java`, `src/main/java/il/israelihelp/*/package-info.java`, `README.md`, `README.ru.md`, `CURRENT_STATE.md`, `docs/diary/*`, `docs/ai/ai_log.md`.

**Проблема и решение:** при первом запуске Jetty выводил около 1700 предупреждений `scanned from multiple locations`. Причина: библиотека JSTL попадала в приложение второй раз (её уже содержит плагин Jetty). Решение: в `pom.xml` у JSTL поставлен `scope=provided`. После этого предупреждений 0.

**Тесты:** см. «Последние результаты тестирования» выше.

**Использование AI:** Cursor (агент, модель Claude Opus 5.5) — план проекта, генерация файлов этапа 1, запуск команд. Подробно: `docs/ai/ai_log.md`.

**Следующий этап:** этап 2 — база данных.
