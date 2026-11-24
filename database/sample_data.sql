-- =====================================================================
-- IsraeliHelp — тестовые данные
--
-- Запуск (после schema.sql):
--     mysql -u root -p < database/sample_data.sql
--
-- Все пользователи, адреса и e-mail вымышленные (домен example.com
-- зарезервирован специально для примеров). Реальных личных данных нет.
--
-- Учебные пароли (только для демонстрации!):
--     admin           -> Admin123!
--     demo_user       -> Demo123!
--     dana_volunteer  -> Demo123!
--     yossi_volunteer -> Demo123!
-- Хеши получены командой:
--     java -cp target/classes il.israelihelp.service.PasswordHasher "Demo123!"
-- У одинаковых паролей хеши разные — из-за случайной соли.
-- =====================================================================

USE IsraeliHelp;

-- ---------------------------------------------------------------------
-- Пользователи
-- ---------------------------------------------------------------------
INSERT INTO users (id, username, email, password_hash, role) VALUES
(1, 'admin',           'admin@example.com', 'pbkdf2$210000$FOgb5rqmCovxda25TxvR+g==$qaOcx6p0KIdWYmCN7lm9oCtFtH+EDmicuLgCwjhaFEc=', 'ADMIN'),
(2, 'demo_user',       'demo@example.com',  'pbkdf2$210000$M7S+YX9dMLUO6ip2IkWSNw==$wy5P/h1mTd1CGNPbWeUkHOzUBDGzU2hLDyTbn8oCQLs=', 'USER'),
(3, 'dana_volunteer',  'dana@example.com',  'pbkdf2$210000$bkgf01MCDsX+cdJkUY2e4A==$OQNq+IOFBTx/M4tlt0wjTPsMqKd6NfiM4uT5A95z3II=', 'USER'),
(4, 'yossi_volunteer', 'yossi@example.com', 'pbkdf2$210000$0Km7CgsOzQs7uQO2Ia/lwg==$HcD6Qe7BOtsOWRVqbZ+d8JOMYs3jWzPSuNwQgpxTYsY=', 'USER');

-- ---------------------------------------------------------------------
-- Мероприятия
-- Коды категорий: FOOD, ELDERLY, CHILDREN, ENVIRONMENT, SOLDIERS, ANIMALS, HEALTH, COMMUNITY
-- Коды городов:   JERUSALEM, TEL_AVIV, HAIFA, BEER_SHEVA, RISHON_LEZION, PETAH_TIKVA,
--                 NETANYA, ASHDOD, HOLON, EILAT
-- ---------------------------------------------------------------------
INSERT INTO events (id, title, description, category, city, address, event_date, required_volunteers, status, image) VALUES
(1, 'Food package sorting before Hanukkah',
    'Help sort and pack food boxes for families in need ahead of Hanukkah. No experience required; work in teams of four. Comfortable shoes recommended.',
    'FOOD', 'JERUSALEM', 'Food bank warehouse, Talpiot industrial area', '2026-12-10 09:00:00', 25, 'OPEN', 'food.jpg'),

(2, 'Weekly visits to senior citizens',
    'Spend an afternoon with elderly residents: conversation, board games and help with small everyday tasks. Basic Hebrew, Russian or English is enough.',
    'ELDERLY', 'HAIFA', 'Senior day center, Hadar neighborhood', '2026-12-14 16:00:00', 8, 'OPEN', 'elderly.jpg'),

(3, 'Beach cleanup at Gordon Beach',
    'Join a morning beach cleanup. Gloves and bags are provided. Suitable for families with children over 10.',
    'ENVIRONMENT', 'TEL_AVIV', 'Gordon Beach, near the lifeguard station', '2026-12-19 08:00:00', 40, 'OPEN', 'environment.jpg'),

(4, 'Homework help for elementary school students',
    'Help children in grades 2–6 with homework in math and English twice a week. Volunteers commit for at least one month.',
    'CHILDREN', 'BEER_SHEVA', 'Community center, Neighborhood Dalet', '2027-01-05 15:30:00', 10, 'OPEN', 'children.jpg'),

(5, 'Care packages for soldiers',
    'Prepare care packages with snacks, socks and handwritten letters for soldiers on duty.',
    'SOLDIERS', 'RISHON_LEZION', 'Municipal hall, Rothschild Street', '2026-12-22 18:00:00', 30, 'OPEN', 'soldiers.jpg'),

(6, 'Animal shelter weekend',
    'Walk dogs, clean enclosures and help with feeding at the city animal shelter. Volunteers must be 16 or older.',
    'ANIMALS', 'PETAH_TIKVA', 'Animal shelter, Kiryat Aryeh', '2027-01-09 10:00:00', 12, 'OPEN', 'animals.jpg'),

(7, 'Blood donation day — registration desk',
    'Assist the medical team at a blood donation drive: greet donors, help with registration and hand out refreshments.',
    'HEALTH', 'NETANYA', 'City sports hall, Herzl Street', '2027-01-17 11:00:00', 6, 'OPEN', 'health.jpg'),

(8, 'Community garden planting',
    'Plant herbs and vegetables in a new neighborhood community garden. Tools are provided.',
    'ENVIRONMENT', 'ASHDOD', 'Community garden, City district 7', '2027-02-02 09:30:00', 15, 'OPEN', 'environment.jpg'),

(9, 'Shabbat meals delivery',
    'Deliver warm Shabbat meals to lonely elderly residents. A car is an advantage but not required.',
    'FOOD', 'HOLON', 'Distribution point, Sokolov Street', '2026-12-25 11:00:00', 2, 'FULL', 'food.jpg'),

(10, 'Purim costume workshop for kids',
    'Help children create Purim costumes and masks from recycled materials.',
    'CHILDREN', 'JERUSALEM', 'Neighborhood library, Katamon', '2027-03-15 16:00:00', 8, 'OPEN', 'children.jpg'),

(11, 'Desert trail cleanup',
    'Clean a popular hiking trail near Eilat. Transportation from the city center is organized.',
    'ENVIRONMENT', 'EILAT', 'Meeting point: central bus station', '2027-02-20 07:30:00', 20, 'CANCELLED', 'environment.jpg'),

(12, 'Neighborhood repair day',
    'Help repaint benches and fix playground equipment together with neighbors.',
    'COMMUNITY', 'TEL_AVIV', 'Neighborhood park, Yad Eliyahu', '2026-10-30 09:00:00', 20, 'COMPLETED', 'community.jpg');

-- ---------------------------------------------------------------------
-- Заявки
-- Мероприятие 9 (нужно 2 волонтёра) имеет 2 одобренные заявки -> статус FULL.
-- ---------------------------------------------------------------------
INSERT INTO applications (user_id, event_id, status) VALUES
(2, 1,  'APPROVED'),
(2, 3,  'PENDING'),
(2, 12, 'APPROVED'),
(3, 1,  'PENDING'),
(3, 9,  'APPROVED'),
(4, 9,  'APPROVED'),
(4, 2,  'REJECTED'),
(3, 6,  'CANCELLED');
