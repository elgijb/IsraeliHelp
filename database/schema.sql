-- =====================================================================
-- IsraeliHelp — создание базы данных и таблиц
--
-- Запуск (из папки проекта):
--     mysql -u root -p < database/schema.sql
--
-- ВНИМАНИЕ: скрипт удаляет базу IsraeliHelp, если она уже есть,
-- и создаёт её заново (все данные будут потеряны).
-- =====================================================================

DROP DATABASE IF EXISTS IsraeliHelp;

-- utf8mb4 — полная поддержка Unicode: иврит, русский, английский и любые символы
CREATE DATABASE IsraeliHelp
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE IsraeliHelp;

-- ---------------------------------------------------------------------
-- users — пользователи сайта
-- ---------------------------------------------------------------------
CREATE TABLE users (
    id            INT UNSIGNED    NOT NULL AUTO_INCREMENT,
    username      VARCHAR(50)     NOT NULL,
    email         VARCHAR(255)    NOT NULL,
    -- Хранится только хеш PBKDF2 (см. PasswordHasher.java), никогда не сам пароль
    password_hash VARCHAR(255)    NOT NULL,
    role          ENUM('USER', 'ADMIN') NOT NULL DEFAULT 'USER',
    created_at    TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    CONSTRAINT uq_users_username UNIQUE (username),
    CONSTRAINT uq_users_email    UNIQUE (email)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- events — волонтёрские мероприятия
--
-- category и city хранят коды (например FOOD, TEL_AVIV).
-- Список допустимых кодов проверяется на Java-сервере,
-- а названия на трёх языках берутся из файлов перевода сайта.
-- ---------------------------------------------------------------------
CREATE TABLE events (
    id                  INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    title               VARCHAR(150)  NOT NULL,
    description         TEXT          NOT NULL,
    category            VARCHAR(30)   NOT NULL,
    city                VARCHAR(30)   NOT NULL,
    address             VARCHAR(255)  NOT NULL,
    event_date          DATETIME      NOT NULL,
    required_volunteers SMALLINT UNSIGNED NOT NULL,
    status              ENUM('OPEN', 'FULL', 'CANCELLED', 'COMPLETED') NOT NULL DEFAULT 'OPEN',
    -- Имя файла картинки из папки webapp/img/events (выбирается из готового набора)
    image               VARCHAR(100)  NULL,
    created_at          TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    CONSTRAINT chk_events_volunteers CHECK (required_volunteers BETWEEN 1 AND 500),

    -- Индексы ускоряют поиск и фильтрацию в каталоге
    INDEX idx_events_city (city),
    INDEX idx_events_category (category),
    INDEX idx_events_date (event_date)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- applications — заявки пользователей на участие в мероприятиях
-- Связь "многие ко многим" между users и events.
-- ---------------------------------------------------------------------
CREATE TABLE applications (
    id         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id    INT UNSIGNED NOT NULL,
    event_id   INT UNSIGNED NOT NULL,
    status     ENUM('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id),

    -- Один пользователь может подать только одну заявку на одно мероприятие
    CONSTRAINT uq_applications_user_event UNIQUE (user_id, event_id),

    -- Внешние ключи: заявка всегда ссылается на существующего пользователя и мероприятие.
    -- ON DELETE CASCADE: при удалении мероприятия (или пользователя) его заявки удаляются автоматически.
    CONSTRAINT fk_applications_user
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT fk_applications_event
        FOREIGN KEY (event_id) REFERENCES events (id) ON DELETE CASCADE
) ENGINE = InnoDB;
