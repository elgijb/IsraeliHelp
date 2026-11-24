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

### 2. התקנת MySQL (גרסה 8 ומעלה)

**macOS:**
```bash
brew install mysql
brew services start mysql
mysql -u root -e "SELECT VERSION();"
```
(לאחר התקנה דרך Homebrew למשתמש root אין סיסמה — במקרה זה אפשר להשמיט את `-p` בפקודות שלהלן)

**Windows:**
1. להוריד את MySQL Installer: ‏https://dev.mysql.com/downloads/installer/ ‏← להתקין «MySQL Server».
2. בזמן ההתקנה להגדיר סיסמה למשתמש root ולזכור אותה.
3. להוסיף את התיקייה `C:\Program Files\MySQL\MySQL Server <גרסה>\bin` ל-PATH (או להריץ את הפקודות מתוך «MySQL Command Line Client»).
4. לבדוק בחלון PowerShell חדש: `mysql -u root -p -e "SELECT VERSION();"`

### 3. יצירת מסד הנתונים וטעינת נתוני דוגמה

מתוך תיקיית הפרויקט:

**macOS / Windows CMD (שורת הפקודה):**
```bash
mysql -u root -p < database/schema.sql
mysql -u root -p < database/sample_data.sql
```

**Windows PowerShell** (‏PowerShell אינו תומך ב-`<`, ולכן הפקודה מועברת ל-CMD):
```powershell
cmd /c "mysql -u root -p < database\schema.sql"
cmd /c "mysql -u root -p < database\sample_data.sql"
```

- `schema.sql` — יוצר את מסד הנתונים `IsraeliHelp` ואת הטבלאות `users`, `events`, `applications`.
  **שימו לב:** אם מסד הנתונים כבר קיים, הוא נמחק ונוצר מחדש.
- `sample_data.sql` — ‏4 משתמשים בדויים, 12 אירועים, 8 בקשות.

### 4. משתמש MySQL עבור האתר והגדרת החיבור

האתר מתחבר למסד הנתונים לא כ-root, אלא כמשתמש נפרד `israelihelp` עם הרשאות SELECT/INSERT/UPDATE/DELETE בלבד על `IsraeliHelp`.

1. לפתוח את `database/create_user.sql` ולהחליף את `change_me` בסיסמה משלכם. להריץ:
   ```bash
   mysql -u root -p < database/create_user.sql                 # macOS / Windows CMD
   cmd /c "mysql -u root -p < database\create_user.sql"        # Windows PowerShell
   ```
2. ליצור קובץ הגדרות מהדוגמה:
   ```bash
   cp src/main/resources/db.properties.example src/main/resources/db.properties      # macOS
   copy src\main\resources\db.properties.example src\main\resources\db.properties    # Windows
   ```
3. ב-`db.properties` לכתוב את אותה סיסמה בשורה `db.password=`.

הקובץ `db.properties` אינו נשמר ב-Git. במקומו אפשר להגדיר משתני סביבה `DB_URL`, `DB_USER`, `DB_PASSWORD`.

**חשבונות לימוד** (מתוך `sample_data.sql`, להדגמה בלבד):

| שם משתמש | סיסמה | תפקיד |
|---|---|---|
| `admin` | `Admin123!` | ADMIN |
| `demo_user` | `Demo123!` | USER |
| `dana_volunteer` | `Demo123!` | USER |
| `yossi_volunteer` | `Demo123!` | USER |

### 5. הרצת האתר

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

### 6. פתיחת האתר

לפתוח בדפדפן: **http://localhost:8080**

לעצירת השרת: `Ctrl + C` בחלון הטרמינל.

### 7. הרצת בדיקות

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
├── database/                schema.sql, sample_data.sql, create_user.sql
├── docs/                    תיעוד, יומנים, היסטוריית AI
└── CURRENT_STATE.md         מצב הפרויקט הנוכחי
```

## מגבלות ידועות

- הפרויקט בשלב 2: קיימים שלד ומסד נתונים. האתר עדיין אינו מחובר למסד הנתונים — זה יתבצע בשלב 5.
- בהרצה הראשונה נדרש חיבור לאינטרנט להורדת הספריות.
- הפורט 8080 חייב להיות פנוי.
- הפרויקט מיועד להרצה באמצעות `./mvnw jetty:run`. ספריית JSTL מגיעה מהתוסף של Jetty, ולכן להרצת קובץ ה-WAR על שרת Tomcat נפרד יש להוסיף אותה ל-`WEB-INF/lib`.

</div>
