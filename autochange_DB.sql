DROP DATABASE IF EXISTS mercedes_db;
CREATE DATABASE mercedes_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE mercedes_db;

-- ============================================================
-- TABLE: cars
-- ============================================================

CREATE TABLE cars (
    id INT AUTO_INCREMENT PRIMARY KEY,
    series VARCHAR(10) NOT NULL,           -- A, B, C, E, S, CLA
    model VARCHAR(50) NOT NULL,            -- E220, C200, S500...
    chassis_code VARCHAR(50) NOT NULL,     -- W211, W213, W205...
    generation INT NOT NULL,               -- номер поколения
    year_start INT,
    year_end INT,
    price_usd INT NOT NULL,
    image_url VARCHAR(500)                 -- картинка (локальная или URL)
);

CREATE UNIQUE INDEX uq_model_chassis ON cars(model, chassis_code);
CREATE INDEX idx_series_model ON cars(series, model);
CREATE INDEX idx_generation ON cars(generation);

-- ============================================================
-- TABLE: trade_in_values
-- ============================================================

CREATE TABLE trade_in_values (
    id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    value_usd INT NOT NULL,
    FOREIGN KEY (car_id) REFERENCES cars(id) ON DELETE CASCADE
);

CREATE INDEX idx_tradein_car ON trade_in_values(car_id);

-- ============================================================
-- INSERT OLD CARS (user selects these as "Current vehicle")
-- ============================================================

INSERT INTO cars (series, model, chassis_code, generation, year_start, year_end, price_usd, image_url) VALUES
('E',  'E220', 'W211', 2, 2002, 2009, 28000, '/assets/e220-w211.jpg'),
('C',  'C200', 'W203', 2, 2000, 2007, 22000, '/assets/c200-w203.jpg'),
('S',  'S500', 'W220', 2, 1998, 2005, 35000, '/assets/s500-w220.jpg');

-- TRADE-IN VALUES
INSERT INTO trade_in_values (car_id, value_usd) VALUES
(1, 6000),     -- E220 W211
(2, 5000),     -- C200 W203
(3, 10000);    -- S500 W220

-- ============================================================
-- INSERT NEW UPGRADE MODELS
-- ============================================================

INSERT INTO cars (series, model, chassis_code, generation, year_start, year_end, price_usd, image_url) VALUES
('E', 'E220', 'W213', 4, 2016, 2020, 50000,
 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Mercedes-Benz_E_Class_W213_%28original_and_facelift%29.jpg/500px-Mercedes-Benz_E_Class_W213_%28original_and_facelift%29.jpg'),

('C', 'C200', 'W205', 4, 2014, 2020, 40000,
 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/11/2018_Mercedes-Benz_C200_SE_facelift_2.0.jpg/500px-2018_Mercedes-Benz_C200_SE_facelift_2.0.jpg'),

('S', 'S500', 'W222', 6, 2013, 2020, 90000,
 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/2019_Mercedes-Benz_S350d_L_AMG_Line_Executive_3.0_Front.jpg/500px-Mercedes-Benz_S350d_L_AMG_Line_Executive_3.0_Front.jpg');

-- ============================================================
-- INSERT BUDGET ALTERNATIVES
-- ============================================================

INSERT INTO cars (series, model, chassis_code, generation, year_start, year_end, price_usd, image_url) VALUES
('A',  'A180',  'W177', 4, 2018, NULL, 18000,
 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Mercedes-Benz_A_180_d_Progressive_Line_%28W_177%29_%E2%80%93_f_10032021.jpg/500px-Mercedes-Benz_A_180_d_Progressive_Line_%28W_177%29_%E2%80%93_f_10032021.jpg'),

('B',  'B200',  'W247', 3, 2019, NULL, 22000,
 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e4/2019_Mercedes-Benz_B200_AMG_Line_Premium_Automatic_1.3_Front.jpg/500px-2019_Mercedes-Benz_B200_AMG_Line_Premium_Automatic_1.3_Front.jpg'),

('CLA', 'CLA250', 'C118', 2, 2019, NULL, 26000,
 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/2019_Mercedes-Benz_CLA_200_AMG_Line_Premium_Automatic_1.3.jpg/500px-2019_Mercedes-Benz_CLA_200_AMG_Line_Premium_Automatic_1.3.jpg');
