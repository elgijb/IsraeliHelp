-- =====================================================================
-- IsraeliHelp — отдельный пользователь MySQL для приложения
--
-- Сайт подключается к базе не как root, а как пользователь israelihelp,
-- у которого есть права ТОЛЬКО на базу IsraeliHelp.
--
-- Перед запуском замените 'change_me' на свой пароль и укажите
-- тот же пароль в src/main/resources/db.properties.
--
-- Запуск (после schema.sql):
--     mysql -u root -p < database/create_user.sql
-- =====================================================================

CREATE USER IF NOT EXISTS 'israelihelp'@'localhost' IDENTIFIED BY 'change_me';

-- SELECT, INSERT, UPDATE, DELETE — ровно четыре CRUD-операции, больше приложению не нужно
GRANT SELECT, INSERT, UPDATE, DELETE ON IsraeliHelp.* TO 'israelihelp'@'localhost';

FLUSH PRIVILEGES;
