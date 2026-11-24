<div dir="rtl">

# יומן פיתוח IsraeliHelp (בקצרה, עבור המורה)

> הטקסט תורגם בעזרת AI ודורש בדיקה של דובר עברית.

## שלב 1 — יצירת הפרויקט (24.11.2026)

**מה מומש**
- פרויקט Maven (קובץ WAR, ‏Java 21 ומעלה) עם Maven Wrapper — להרצה נדרשת רק Java.
- שרת ווב Jetty 12.1.15 (`./mvnw jetty:run` ← http://localhost:8080).
- מבנה MVC: החבילות `controller`, `service`, `dao`, `model`, `config`.
- Servlet ראשון `HomeServlet` (GET `/`) ← דף JSP ‏`WEB-INF/views/home.jsp` עם JSTL וקידוד UTF-8.
- `web.xml`: תוקף Session של 30 דקות, Cookie מסוג HttpOnly, מעקב Session רק דרך Cookie.
- `.gitignore` (לא נשמרים קבצי בנייה וקובץ סיסמת מסד הנתונים), README בעברית וברוסית, ‏CURRENT_STATE.md.

**פקודות עיקריות:** `./mvnw clean package`, `./mvnw jetty:run`, `brew services start mysql`.

**בדיקות:** הבנייה הצליחה; `GET /` ← 200; עברית ורוסית מוצגות נכון; דף JSP בתוך WEB-INF אינו נגיש ישירות (404).

**בעיה שנפתרה:** ספריית JSTL נטענה פעמיים (התוסף של Jetty כבר מכיל אותה) ← `scope=provided`.

**AI:** ‏Cursor ‏(Claude Opus 5.5) — תכנון ויצירת קבצי השלב; פירוט ב-`docs/ai/ai_log.md`.

**GitHub:** ‏https://github.com/elgijb/IsraeliHelp

## שלב 2 — מסד נתונים (24.11.2026)

**מה מומש**
- `database/schema.sql`: מסד הנתונים `IsraeliHelp` ‏(utf8mb4), הטבלאות `users`, `events`, `applications`; מפתחות ראשיים, מפתחות זרים (ON DELETE CASCADE), ‏UNIQUE(user_id, event_id), ‏CHECK (1–500 מתנדבים), סטטוסים מסוג ENUM, אינדקסים.
- `database/sample_data.sql`: ‏4 משתמשים בדויים, 12 אירועים ב-10 ערים, 8 בקשות.
- `database/create_user.sql`: משתמש MySQL לאתר עם הרשאות SELECT/INSERT/UPDATE/DELETE בלבד.
- `db.properties.example` (הקובץ האמיתי עם הסיסמה אינו נשמר ב-Git).
- `PasswordHasher` ‏(PBKDF2-HMAC-SHA256 עם Salt) + ‏6 בדיקות JUnit; הגיבובים (hashes) בנתוני הדוגמה נוצרו באמצעותו.
- README: התקנת MySQL ‏(macOS/Windows), יצירת מסד הנתונים, הגדרת החיבור, חשבונות לימוד.

**פקודות עיקריות:** `mysql -u root -p < database/schema.sql`, `mysql -u root -p < database/sample_data.sql`, `./mvnw test`.

**בדיקות:** ‏6/6 בדיקות עברו; בקשה כפולה ← שגיאה 1062; מפתח זר ← 1452; ‏CHECK ← 3819; מחיקה מדורגת (CASCADE) עובדת; משתמש האתר אינו יכול לבצע DROP; הנתונים נשמרים לאחר הפעלה מחדש של MySQL.

**בעיה שנפתרה:** הפקודה `mysql -e "source ..."` אינה עובדת ב-MySQL 26.10 ← ב-README משתמשים ב-`<` (וב-`cmd /c` עבור PowerShell).

</div>

## שלב 3 — עיצוב ו-frontend (24.11.2026)

**מה מומש**
- מערכת עיצוב ל-4 תרחישים (דף בית עם הבעיה, קטלוג, דף אירוע, טבלת ניהול) — `docs/design/design-system.md`.
- טוקני CSS, Inter + Heebo (מקומי), Lucide SVG, תמונות Pexels.
- ממשק EN / HE (RTL) / RU: ‏`LocaleFilter`, ‏`LangServlet`, ‏`i18n/messages*.properties`.
- JSP + Servlets: `/`, `/events`, `/events/view`, `/about`, `/login`, `/register`, `/admin/events`.
- `DemoCatalog` — נתונים זמניים (כמו ב-`sample_data.sql`) עד JDBC בשלב 5.

**פקודה:** `./mvnw jetty:run` ← http://localhost:8080

**בדיקות:** כתובות ← 200; החלפת שפה עובדת; סינון לפי עיר עובד.

**הגבלות:** ללא JDBC; CRUD ולוגין — שלבים 6–7; תרגום עברית נוצר ב-AI.
