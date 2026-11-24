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

</div>
