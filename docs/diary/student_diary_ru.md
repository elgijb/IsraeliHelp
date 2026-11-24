# Дневник проекта IsraeliHelp (для студента)

Здесь подробно, по шагам, записано всё, что делалось в проекте: какие команды выполнялись и зачем,
какие файлы созданы и что означает каждая важная строка. Цель — чтобы ты мог объяснить любую часть проекта на защите
и сам внести изменение.

---

## Этап 1 — Создание проекта (24.11.2026)

### 1.1. Что было на компьютере в начале

| Что проверяли | Команда | Результат |
|---|---|---|
| Java | `java -version` | Ошибка «Unable to locate a Java Runtime» — команда `java` не найдена в PATH |
| Maven | `mvn -v` | Maven 3.10.1, сам нашёл Homebrew OpenJDK 27 |
| MySQL | `mysql --version` | MySQL 26.10.0 установлен |
| Git | `git --version` | 2.50.1, репозиторий уже создан, коммитов нет |
| GitHub CLI | `gh --version` | не установлен |

**Почему `java` не находилась:** Homebrew ставит OpenJDK как «keg-only» — то есть не добавляет его в системный PATH,
чтобы не конфликтовать с другими Java. Нужно добавить путь вручную.

### 1.2. Настройка окружения — команды и объяснения

```bash
cat >> ~/.zshrc <<'EOF'
export JAVA_HOME="/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"
EOF
```
- `~/.zshrc` — файл настроек терминала zsh, он выполняется при каждом открытии нового терминала.
- `cat >> файл <<'EOF' ... EOF` — дописать текст в конец файла (не стирая старое).
- `JAVA_HOME` — переменная, по которой программы (Maven, IDE) находят Java.
- `PATH` — список папок, где терминал ищет команды. Мы добавили папку `bin` из Java в начало списка.

```bash
brew services start mysql
```
- Запускает MySQL как фоновую службу (будет запускаться и после перезагрузки Mac).
- Ответ был «already started» — служба уже работала.

```bash
mysql -u root -e "SELECT VERSION(), CURRENT_USER();"
```
- `-u root` — войти пользователем root (главный администратор MySQL).
- `-e "..."` — выполнить SQL-запрос и выйти.
- Результат: `26.10.0 root@localhost` — вход без пароля работает (так Homebrew настраивает MySQL по умолчанию).

```bash
brew install gh
```
- Устанавливает GitHub CLI — программу для работы с GitHub из терминала (создать репозиторий, войти в аккаунт).

**Интересный факт:** на компьютере есть ещё Oracle JDK 25. Когда переменная `JAVA_HOME` не задана, `mvnw` находит Java
через системную утилиту macOS и берёт JDK 25. Поэтому на проверочной странице написано `Java version 25.0.1`.
Это нормально: проект компилируется под Java 21, а работает на любой Java от 21 и новее.

### 1.3. `pom.xml` — главный файл проекта

Maven — это инструмент сборки. Он читает `pom.xml`, скачивает нужные библиотеки, компилирует Java-код
и запускает сервер.

Разбор по блокам:

```xml
<groupId>il.israelihelp</groupId>
<artifactId>israelihelp</artifactId>
<version>1.0-SNAPSHOT</version>
<packaging>war</packaging>
```
- `groupId` — «фамилия» проекта, обычно перевёрнутый домен (`israelihelp.il` → `il.israelihelp`).
- `artifactId` — имя проекта.
- `version` — версия; `SNAPSHOT` значит «в разработке».
- `packaging war` — результат сборки будет WAR (Web ARchive): архив веб-приложения для сервера.

```xml
<maven.compiler.release>21</maven.compiler.release>
<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
```
- Компилировать код под Java 21 → проект запустится у учителя на любой Java начиная с 21.
- Исходники в UTF-8 → русские комментарии и иврит не превратятся в «кракозябры».

**Зависимости (`<dependencies>`)** — библиотеки, которые Maven скачает сам:

| Библиотека | Зачем | scope |
|---|---|---|
| `jakarta.servlet-api` 6.0.0 | классы `HttpServlet`, `HttpServletRequest`, `HttpSession` | `provided` — даёт сервер Jetty |
| `jakarta.servlet.jsp.jstl` 3.0.1 (Glassfish) | теги `<c:forEach>`, `<c:if>`, `<c:out>`, `<fmt:message>` в JSP | `provided` — уже есть внутри плагина Jetty |
| `mysql-connector-j` 26.10.0 | JDBC-драйвер: через него Java общается с MySQL | обычный (попадёт в WAR) |
| `junit-jupiter` 6.1.3 | автоматические тесты | `test` — только для тестов |

**Что значит scope:**
- без scope (compile) — библиотека нужна и для компиляции, и для работы, кладётся в WAR;
- `provided` — нужна для компиляции, но во время работы её даёт сервер;
- `test` — нужна только при запуске тестов.

**Плагины (`<build><plugins>`)**:
- `maven-compiler-plugin` — компилирует `.java` в `.class`.
- `maven-surefire-plugin` — запускает тесты (`./mvnw test`).
- `maven-war-plugin` — собирает WAR-файл.
- `jetty-ee10-maven-plugin` — веб-сервер Jetty. `ee10` означает поддержку Jakarta EE 10 (Servlet 6.0).
  - `<contextPath>/</contextPath>` — сайт открывается в корне: `http://localhost:8080/`, а не `http://localhost:8080/israelihelp/`.
  - `<port>8080</port>` — порт сервера.

### 1.4. Maven Wrapper (`mvnw`, `mvnw.cmd`, `.mvn/wrapper/maven-wrapper.properties`)

Команда: `mvn -N wrapper:wrapper`
- `-N` — «non-recursive», только для этого проекта.
- `wrapper:wrapper` — создать обёртку.

Зачем: у учителя может не быть Maven. `mvnw` (macOS/Linux) и `mvnw.cmd` (Windows) — маленькие скрипты,
которые при первом запуске сами скачают нужную версию Maven (3.10.1 — записано в `maven-wrapper.properties`).
Учителю нужно установить только Java.

### 1.5. `src/main/webapp/WEB-INF/web.xml` — настройки веб-приложения

- `WEB-INF` — особая папка: файлы внутри неё браузер **не может** открыть напрямую. Поэтому там лежат настройки и JSP.
- `<session-timeout>30</session-timeout>` — сессия пользователя заканчивается через 30 минут бездействия.
- `<http-only>true</http-only>` — cookie сессии (`JSESSIONID`) недоступна JavaScript → вредный скрипт не сможет её украсть.
- `<tracking-mode>COOKIE</tracking-mode>` — номер сессии передаётся только в cookie, а не в адресной строке (иначе его можно случайно переслать кому-то вместе со ссылкой).
- `<page-encoding>UTF-8</page-encoding>` для `*.jsp` — все JSP в UTF-8.

### 1.6. `HomeServlet.java` — первый сервлет

```java
@WebServlet("")
public class HomeServlet extends HttpServlet {
```
- **Сервлет** — Java-класс, который обрабатывает HTTP-запросы. Наследуется от `HttpServlet`.
- `@WebServlet("")` — аннотация: «этот сервлет отвечает за адрес `""`», то есть корень сайта `/`.
  Можно было бы прописать то же самое в `web.xml`, но аннотация короче и видна прямо в классе.

```java
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
```
- `doGet` вызывается, когда браузер делает **GET**-запрос (открыть страницу, перейти по ссылке).
- Для отправки форм позже будем использовать `doPost` (**POST**-запрос).
- `request` — всё, что прислал браузер (адрес, параметры, cookie, сессия).
- `response` — то, что мы отправим обратно.

```java
request.setAttribute("serverTime", LocalDateTime.now().format(TIME_FORMAT));
request.setAttribute("javaVersion", System.getProperty("java.version"));
request.setAttribute("serverInfo", getServletContext().getServerInfo());
```
- `setAttribute(имя, значение)` — положить данные в запрос, чтобы JSP могла их показать.
- `getServletContext()` — объект **Application** (общий для всего приложения). Здесь мы только спросили у него имя сервера; на этапе 7 будем хранить в нём общие счётчики.

```java
request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
```
- `forward` — передать запрос JSP-странице на сервере. Браузер этого не видит: адрес в строке остаётся `/`.
- Это схема **MVC**: сервлет (Controller) готовит данные, JSP (View) их показывает.

### 1.7. `home.jsp` — проверочная страница

```jsp
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
```
- Первая строка: страница отдаёт HTML в UTF-8.
- Вторая: подключить библиотеку тегов JSTL core под префиксом `c`.

```jsp
<c:out value="${serverTime}"/>
```
- `${serverTime}` — **EL-выражение** (Expression Language): берёт атрибут `serverTime`, который положил сервлет.
- `<c:out>` выводит значение и **экранирует** HTML-символы (`<` → `&lt;`). Это защита от XSS: если в данных окажется `<script>`, он покажется как текст, а не выполнится.

Строка `English · עברית · Русский` проверяет, что кодировка настроена правильно для всех трёх языков сайта.

### 1.8. `package-info.java` в каждом пакете

Git не хранит пустые папки. Чтобы структура `controller / service / dao / model / config` была в репозитории,
в каждой папке лежит `package-info.java` — специальный файл Java с описанием пакета. Заодно это документация:
открыл файл — понял, зачем пакет.

| Пакет | Роль |
|---|---|
| `controller` | сервлеты: принимают запросы, вызывают сервисы, передают данные в JSP |
| `service` | бизнес-логика и серверная проверка данных |
| `dao` | SQL-запросы к MySQL через PreparedStatement |
| `model` | классы данных: User, Event, Application |
| `config` | подключение к базе, слушатели запуска приложения и сессий |

### 1.9. `.gitignore` — что не попадает в Git

- `target/` — результат сборки, создаётся заново.
- `db.properties` — **настоящий пароль от базы**. По ТЗ секреты нельзя хранить в Git. В Git будет только пример `db.properties.example`.
- `.idea/`, `.vscode/`, `.cursor/`, `.DS_Store` — личные файлы редактора и системы.

### 1.10. Сборка и запуск — команды

```bash
./mvnw clean package
```
- `clean` — удалить старую папку `target`.
- `package` — скомпилировать, запустить тесты, собрать `target/israelihelp.war`.
- Результат: BUILD SUCCESS, WAR размером около 7.6 МБ.

```bash
./mvnw jetty:run
```
- Запускает сервер Jetty прямо из исходников. Когда в выводе появляется `Started oejs.Server` — сайт работает.
- Остановка: `Ctrl + C`.

```bash
curl -i http://localhost:8080/
```
- `curl` — программа, которая делает HTTP-запрос из терминала. `-i` — показать заголовки ответа.
- Получили `HTTP/1.1 200 OK`, заголовок `Set-Cookie: JSESSIONID=...; HttpOnly` (сервер создал сессию — HttpOnly работает).

### 1.11. Проблема, которую решили

**Симптом:** при запуске Jetty печатал около 1700 строк `WARNING ... scanned from multiple locations`.

**Как искали причину:**
1. Посмотрели, какие JAR-файлы упоминаются в предупреждениях.
2. Сначала оказалось, что JSTL API был в двух версиях (3.0.0 и 3.0.2) — убрали лишнюю.
3. Предупреждения остались, но теперь одна и та же библиотека `jakarta.servlet.jsp.jstl-3.0.1.jar` сканировалась дважды.
4. Пробовали настройку `containerIncludeJarPattern` — не помогло, откатили.
5. Поняли: плагин Jetty уже содержит эту библиотеку сам, а мы добавили её второй раз.

**Решение:** `<scope>provided</scope>` у JSTL в `pom.xml`. Результат: 0 предупреждений.

### 1.12. Результаты проверки

| Проверка | Ожидание | Факт |
|---|---|---|
| `./mvnw clean package` | BUILD SUCCESS | BUILD SUCCESS |
| `GET /` | 200, страница с данными | 200, время, Java 25.0.1, jetty/12.1.15 |
| Иврит и русский на странице | читаются правильно | `English · עברית · Русский` — правильно |
| `GET /WEB-INF/views/home.jsp` | 404 (закрыто) | 404 |
| `GET /nope` | 404 | 404 |
| Предупреждения при запуске | нет лишних | 0 «scanned from multiple»; 3 штатных от Jasper |

### 1.13. Вопросы, которые могут задать на защите

- **Что такое сервлет?** Java-класс, который обрабатывает HTTP-запросы на сервере (методы `doGet`, `doPost`).
- **Чем GET отличается от POST?** GET — получить данные, параметры видны в адресе; POST — отправить данные (форма), параметры в теле запроса.
- **Зачем JSP лежат в WEB-INF?** Чтобы их нельзя было открыть напрямую, минуя сервлет (и его проверки).
- **Что такое forward?** Передача запроса от сервлета к JSP на сервере, без нового запроса от браузера.
- **Зачем Maven Wrapper?** Чтобы проект запускался там, где не установлен Maven.
- **Что такое scope provided?** Библиотека нужна для компиляции, но во время работы её предоставляет сервер.
- **Почему пароль от базы не в Git?** Репозиторий публичный — пароль увидят все. Храним только пример файла.

### 1.14. Что попробовать самому (практика для защиты)

1. В `HomeServlet` добавь `request.setAttribute("myName", "твоё имя");`, а в `home.jsp` — `<c:out value="${myName}"/>`. Перезапусти сервер и посмотри.
2. Поменяй порт на 8081 в `pom.xml` и открой `http://localhost:8081`.
