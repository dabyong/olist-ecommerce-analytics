
-- Project 1: E-Commerce BI & Revenue Analytics
-- Create the project database

CREATE DATABASE IF NOT EXISTS olist_ecommerce
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

-- Select our database
USE olist_ecommerce;

-- Verify the selected database
SELECT DATABASE() AS active_database;

-- Check existing tables
SHOW TABLES;
