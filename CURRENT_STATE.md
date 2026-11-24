# CURRENT_STATE — IsraeliHelp

## Текущее состояние (обновлено: 24.11.2026, после этапа 2)

**Что уже работает**
- Каркас Maven-проекта (WAR, Java 21+), Maven Wrapper, Jetty 12.1.15 (`./mvnw jetty:run` → http://localhost:8080).
- Проверочная страница `HomeServlet` → `home.jsp` (JSTL, UTF-8).
- Структура пакетов: `controller`, `service`, `dao`, `model`, `config`.
- GitHub: https://github.com/elgijb/IsraeliHelp (публичный).
- База MySQL `IsraeliHelp`: таблицы `users`, `events`, `applications` с PK, FK (ON DELETE CASCADE), UNIQUE(user_id, event_id), CHECK, индексами; utf8mb4.
- Тестовые данные: 4 вымышленных пользователя, 12 мероприятий в 10 городах, 8 заявок.
- Отдельный MySQL-пользователь `israelihelp` с правами только SELECT/INSERT/UPDATE/DELETE.
- `PasswordHasher` (PBKDF2-HMAC-SHA256, соль, 210 000 итераций) + 6 JUnit-тестов.

**Что пока не реализовано**
- Дизайн, страницы сайта, переключение языков (этап 3 — сначала предложение дизайна на одобрение).
- JavaScript-валидация (этап 4), подключение Java к MySQL (этап 5), CRUD, пользователи, Session/Application, XML/XSD, портфолио (этапы 6–12).
- Картинки мероприятий (`food.jpg` и т.д.) указаны в базе, но сами файлы появятся на этапе 3.

**Известные ошибки и предупреждения**
- При запуске Jetty выводит 3 предупреждения `The XML schema [...] could not be found` — внутренние сообщения компилятора JSP, на работу не влияют.
- Команда `mysql -e "source файл"` в MySQL 26.10 не работает — в README используется перенаправление `<` (и `cmd /c` для PowerShell).

**Следующая задача**
- Этап 3а: предложение дизайн-системы (без изменения файлов), ждать одобрения.

**Последние результаты тестирования (24.11.2026)**
- `./mvnw test` — 6 тестов, 0 ошибок (PasswordHasherTest).
- Загрузка `schema.sql` и `sample_data.sql` — без ошибок; 4 / 12 / 8 строк.
- Повторная заявка → ошибка 1062 (UNIQUE работает); заявка на несуществующее мероприятие → 1452 (FK работает); 0 волонтёров → 3819 (CHECK работает).
- Удаление мероприятия 1 удаляет его 2 заявки (CASCADE), проверено в транзакции с откатом.
- Пользователь `israelihelp`: SELECT работает, DROP запрещён (1142).
- После `brew services restart mysql` данные на месте (4 / 12 / 8).

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

### 24.11.2026 — Этап 1 (дополнение): GitHub

- Выполнен вход `gh auth login` (студент), создан публичный репозиторий командой
  `gh repo create IsraeliHelp --public --source=. --remote=origin --push`.
- Первый commit `7bdb435 Initial project structure` отправлен в https://github.com/elgijb/IsraeliHelp.

### 24.11.2026 — Этап 2: база данных

**Задача:** спроектировать таблицы и связи, создать `schema.sql` и `sample_data.sql`, проверить MySQL.

**Что сделано**
- `database/schema.sql`: база `IsraeliHelp` (utf8mb4), таблицы `users`, `events`, `applications`.
  PK, FK с `ON DELETE CASCADE`, `UNIQUE(user_id, event_id)`, `UNIQUE` username/email, `CHECK required_volunteers BETWEEN 1 AND 500`,
  ENUM для ролей и статусов, индексы по city/category/event_date, поле `image` для картинки мероприятия.
- `database/sample_data.sql`: 4 пользователя (example.com), 12 мероприятий (EN-тексты, коды городов и категорий), 8 заявок разных статусов.
- `database/create_user.sql`: пользователь `israelihelp` только с CRUD-правами.
- `src/main/resources/db.properties.example`: шаблон подключения (настоящий `db.properties` в `.gitignore`).
- `PasswordHasher.java` + `PasswordHasherTest.java` — нужны уже сейчас, чтобы в тестовых данных были настоящие хеши паролей.
- README (he + ru): установка MySQL на macOS/Windows, создание базы, пользователь, настройка подключения, учебные аккаунты.

**Изменённые файлы:** `database/schema.sql`, `database/sample_data.sql`, `database/create_user.sql`,
`src/main/resources/db.properties.example`, `src/main/java/il/israelihelp/service/PasswordHasher.java`,
`src/test/java/il/israelihelp/service/PasswordHasherTest.java`, `README.md`, `README.ru.md`, `CURRENT_STATE.md`, `docs/diary/*`, `docs/ai/ai_log.md`.

**Проблема и решение:** в README сначала была команда `mysql -u root -p -e "source database/schema.sql"`.
При проверке она дала ошибку 1064 в MySQL 26.10. Заменена на `mysql -u root -p < database/schema.sql`
(для PowerShell — через `cmd /c`), проверено.

**Тесты:** см. «Последние результаты тестирования» выше — все результаты реальные.

**Использование AI:** Cursor (Claude Opus 5.5) — SQL-скрипты, PasswordHasher, тесты, проверки, документация.

**Следующий этап:** 3а — предложение дизайн-системы.
