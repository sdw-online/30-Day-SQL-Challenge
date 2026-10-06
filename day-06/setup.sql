-- Day 06: PRIMARY KEY, FOREIGN KEY & Constraints - Setup Script
-- 30 Day SQL Challenge | Stephen | Data
-- Run this in pgAdmin to create today's tables.
--
-- These are the tables used in the video: trainers, members, classes, bookings.
-- Run exercise.sql separately for the NovaPay exercise tables.

-- Drop previous tables if they exist (safe to re-run, reverse dependency order)
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS trainers;

-- ============================================
-- DAY 6 SETUP: FitBase Gym Schema
-- ============================================
-- Multi-table schema with constraints for learning
-- PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL, CHECK, DEFAULT

-- Clean up any existing tables (reverse dependency order)
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS trainers;

-- Also clean up exercise tables from previous runs
DROP TABLE IF EXISTS novapay_transactions;
DROP TABLE IF EXISTS novapay_merchants;
DROP TABLE IF EXISTS novapay_employees;

-- ============================================
-- TABLE 1: trainers
-- ============================================
-- Demonstrates: PRIMARY KEY, NOT NULL, SERIAL

CREATE TABLE trainers (
    trainer_id   SERIAL       PRIMARY KEY,
    name         VARCHAR(100) NOT NULL,
    speciality   VARCHAR(30)  NOT NULL
);

INSERT INTO trainers (name, speciality)
VALUES
    ('Ryan Cooper',   'Strength'),
    ('Priya Sharma',  'Yoga'),
    ('Kofi Mensah',   'HIIT');

-- ============================================
-- TABLE 2: members
-- ============================================
-- Demonstrates: PRIMARY KEY, NOT NULL, UNIQUE, CHECK, DEFAULT, nullable column (phone)

CREATE TABLE members (
    member_id       SERIAL       PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    email           VARCHAR(150) NOT NULL UNIQUE,
    phone           VARCHAR(20),
    membership_type VARCHAR(20)  NOT NULL DEFAULT 'standard'
                    CHECK (membership_type IN ('student', 'standard', 'premium'))
);

INSERT INTO members (name, email, membership_type)
VALUES
    ('Sophie Ward',   'sophie@mail.com',  'premium'),
    ('Mei Lin',       'mei@mail.com',     'standard'),
    ('Dan Foster',    'dan@mail.com',     'standard'),
    ('Aisha Obi',     'aisha@mail.com',   'premium'),
    ('Liam Brooks',   'liam@mail.com',    'student');

-- ============================================
-- TABLE 3: classes
-- ============================================
-- Demonstrates: PRIMARY KEY, FOREIGN KEY, NOT NULL, CHECK (BETWEEN and IN)

CREATE TABLE classes (
    class_id    SERIAL       PRIMARY KEY,
    class_name  VARCHAR(100) NOT NULL,
    trainer_id  INTEGER      NOT NULL
                REFERENCES trainers(trainer_id),
    capacity    INTEGER      NOT NULL CHECK (capacity BETWEEN 5 AND 30),
    difficulty  VARCHAR(20)  NOT NULL
                CHECK (difficulty IN ('beginner', 'intermediate', 'advanced'))
);

INSERT INTO classes (class_name, trainer_id, capacity, difficulty)
VALUES
    ('Morning HIIT',   3, 20, 'advanced'),
    ('Power Yoga',     2, 15, 'intermediate'),
    ('Barbell Basics', 1, 12, 'beginner'),
    ('Evening Spin',   3, 25, 'intermediate');

-- ============================================
-- TABLE 4: bookings (composite primary key)
-- ============================================
-- Demonstrates: Composite PRIMARY KEY, FOREIGN KEY, DEFAULT (timestamp)
-- NOTE: This table is created WITHOUT CASCADE initially.
-- The teleprompter drops and recreates it WITH CASCADE later in section 8.

CREATE TABLE bookings (
    member_id   INTEGER   NOT NULL
                REFERENCES members(member_id),
    class_id    INTEGER   NOT NULL
                REFERENCES classes(class_id),
    booked_at   TIMESTAMP NOT NULL DEFAULT NOW(),
    PRIMARY KEY (member_id, class_id)
);

INSERT INTO bookings (member_id, class_id)
VALUES
    (1, 1),
    (1, 3),
    (2, 2),
    (4, 1),
    (3, 4);
