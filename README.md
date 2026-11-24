<div dir="rtl">

# IsraeliHelp — פלטפורמה להתנדבות בישראל

[Русская версия / גרסה ברוסית](README.ru.md)

**קוד פרויקט:** 899373 · **מקצוע:** Introduction to Web Programming · **שנת לימודים:** 2026–2027

> הערה: הטקסט בעברית תורגם בעזרת AI ודורש בדיקה של דובר עברית.

## מטרת הפרויקט

IsraeliHelp הוא אתר אינטרנט שמחבר בין אנשים שרוצים להתנדב לבין ארגונים ויוזמות בישראל שזקוקים למתנדבים.
המשתמשים יוכלו לחפש אירועי התנדבות לפי עיר, קטגוריה ותאריך, לצפות בפרטים ולהירשם.
מנהלי המערכת יוכלו ליצור, לערוך ולמחוק אירועים ולנהל בקשות.

## למי האתר מיועד

- תושבי ישראל שרוצים להתנדב (תלמידים, סטודנטים, מבוגרים).
- ארגונים ויוזמות קהילתיות שמחפשים מתנדבים.

## טכנולוגיות

| תחום | טכנולוגיה | גרסה |
|---|---|---|
| צד לקוח | HTML5, CSS3, JavaScript | — |
| צד שרת | Java (Jakarta Servlet 6.0 + JSP/JSTL 3.0) | Java 21 ומעלה |
| שרת ווב | Jetty (דרך Maven) | 12.1.15 |
| בניית הפרויקט | Maven (דרך Maven Wrapper — אין צורך להתקין) | 3.10.1 |
| מסד נתונים | MySQL + JDBC (mysql-connector-j) | MySQL 8 ומעלה, connector 26.10.0 |
| בדיקות | JUnit | 6.1.3 |

## התקנה והרצה

### 1. התקנת Java (גרסה 21 ומעלה)

**macOS:**
```bash
brew install openjdk
echo 'export JAVA_HOME="/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home"' >> ~/.zshrc
echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
java -version
```

**Windows:**
1. להוריד ולהתקין JDK 21 ומעלה מהאתר https://adoptium.net (בהתקנה לסמן "Set JAVA_HOME" ו-"Add to PATH").
2. לפתוח חלון PowerShell חדש ולבדוק: `java -version`

### 2. התקנת MySQL

> מסד הנתונים יתווסף בשלב 2. ההוראות המלאות (יצירת מסד הנתונים, טעינת נתוני דוגמה והגדרת החיבור) יופיעו כאן.

### 3. הרצת האתר

מתוך תיקיית הפרויקט:

**macOS / Linux:**
```bash
./mvnw jetty:run
```

**Windows (PowerShell או CMD):**
```bat
mvnw.cmd jetty:run
```

בהרצה הראשונה Maven מוריד את הספריות הנדרשות (נדרש חיבור לאינטרנט).
כשמופיעה ההודעה `Started oejs.Server` — האתר פועל.

### 4. פתיחת האתר

לפתוח בדפדפן: **http://localhost:8080**

לעצירת השרת: `Ctrl + C` בחלון הטרמינל.

### 5. הרצת בדיקות

```bash
./mvnw test        # macOS / Linux
mvnw.cmd test      # Windows
```

## מבנה הפרויקט

```
├── pom.xml                  הגדרות Maven: ספריות, בנייה, Jetty
├── mvnw, mvnw.cmd, .mvn/    Maven Wrapper
├── src/main/java/il/israelihelp/
│   ├── controller/          Servlets — קבלת בקשות HTTP
│   ├── service/             לוגיקה עסקית ובדיקת נתונים
│   ├── dao/                 עבודה עם MySQL (JDBC)
│   ├── model/               מחלקות נתונים
│   └── config/              הגדרות (חיבור למסד נתונים וכו')
├── src/main/webapp/         דפי JSP, CSS, JavaScript
├── src/test/java/           בדיקות JUnit
├── docs/                    תיעוד, יומנים, היסטוריית AI
└── CURRENT_STATE.md         מצב הפרויקט הנוכחי
```

## מגבלות ידועות

- הפרויקט בשלב 1: קיים שלד בלבד (דף בדיקה). מסד הנתונים והפונקציונליות יתווספו בשלבים הבאים.
- בהרצה הראשונה נדרש חיבור לאינטרנט להורדת הספריות.
- הפורט 8080 חייב להיות פנוי.
- הפרויקט מיועד להרצה באמצעות `./mvnw jetty:run`. ספריית JSTL מגיעה מהתוסף של Jetty, ולכן להרצת קובץ ה-WAR על שרת Tomcat נפרד יש להוסיף אותה ל-`WEB-INF/lib`.

</div>
