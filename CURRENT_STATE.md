# CURRENT_STATE — IsraeliHelp

## Текущее состояние (обновлено: 24.11.2026, после этапа 3б)

**Что уже работает**
- Всё из этапов 1–2 (Maven/Jetty, MySQL schema, PasswordHasher, GitHub).
- Дизайн-система (одобрена): `docs/design/design-system.md`, локальные шрифты Inter/Heebo, Lucide SVG, CSS-токены.
- Четыре сценария на JSP: главная (проблема + поиск), каталог (фильтры), страница мероприятия (фото + запись), админ-таблица.
- i18n EN / HE (RTL) / RU через LocaleFilter + ResourceBundle; переключатель `/lang?code=`.
- Формы входа и регистрации (внешний вид), страница About.
- DemoCatalog с данными как в sample_data.sql (без MySQL на этапе 3).

**Что пока не реализовано**
- JavaScript-валидация форм (этап 4).
- Подключение к MySQL через JDBC (этап 5) — сейчас DemoCatalog.
- CRUD админки, пользователи/Session/заявки, XML/XSD, портфолио (этапы 6–12).

**Известные ошибки и предупреждения**
- 3 предупреждения Jasper про XML schema при старте Jetty — без влияния.
- Ивритские тексты интерфейса переведены AI — нужна проверка носителем.
- Фото с Pexels (не Unsplash): нужен был API-ключ Unsplash.
- Кнопка «New event» / удаление в админке пока неактивны (этап 6).
- POST логина/регистрации ещё не обрабатывается (этап 7).

**Следующая задача**
- Этап 4: validation.js, filter.js, confirm.js.

**Последние результаты тестирования (24.11.2026)**
- `./mvnw test` — 6/6.
- `GET /`, `/events`, `/events/view?id=3`, `/about`, `/login`, `/register`, `/admin/events` → 200.
- `/?lang=ru` — русский заголовок; `/?lang=he` — `dir=rtl` и ивритский заголовок.
- Фильтр `/events?city=HAIFA` → 200.

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

### 24.11.2026 — Этап 3а/3б: дизайн и вёрстка

**Задача:** предложение дизайн-системы (одобрено с правкой «не AI-slop, 4 сценария»), затем реализация.

**Что сделано**
- Макеты 4 экранов, одобрение; сохранено в `docs/design/`.
- CSS, локальные шрифты, иконки Lucide, фото категорий (Pexels).
- i18n en/he/ru, LocaleFilter, EncodingFilter, LangServlet.
- Модели Event/Category/City/EventStatus, DemoCatalog.
- JSP: home, events, event, about, login, register, admin/events + header/footer.

**Проблемы:** конфликт лишних файлов (DemoEventData) — удалены; EL требовал getMessageKey(); JSTL locale через Config.FMT_LOCALE.

**AI:** Cursor (Claude Opus 5.5). Следующий этап: 4 — JavaScript.
