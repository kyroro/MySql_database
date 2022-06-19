--БД составлена на основе магазина Куулклевер


DROP DATABASE IF EXISTS coolclever;
CREATE DATABASE coolclever;
USE coolclever;





CREATE TABLE users(
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
	browser VARCHAR(50),
	session VARCHAR(50)

);

CREATE TABLE registration_users(
	registration_users_id BIGINT UNSIGNED NOT NULL, 
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    email VARCHAR(120) UNIQUE,
 	password_hash VARCHAR(100), 
	phone BIGINT UNSIGNED UNIQUE, 
	birthday DATE,

	FOREIGN KEY (registration_users_id) REFERENCES users(id)

);

CREATE TABLE products_mysnov(
	products_id_mysnov BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name_product_mysnov VARCHAR(100),
	price_product_mysnov BIGINT UNSIGNED

);

CREATE TABLE products_otdohni(
	products_id_otdohni BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name_product_otdohni VARCHAR(100),
	price_product_otdohni BIGINT UNSIGNED
	
);

CREATE TABLE favorites(
	id_favorites_mysnov BIGINT UNSIGNED NOT NULL,
	id_favorites_otdohni BIGINT UNSIGNED NOT NULL,
	id_user_favorites BIGINT UNSIGNED NOT NULL,

	FOREIGN KEY (id_favorites_mysnov) REFERENCES products_mysnov(products_id_mysnov),
	FOREIGN KEY (id_favorites_otdohni) REFERENCES products_otdohni(products_id_otdohni),
	FOREIGN KEY (id_user_favorites) REFERENCES users(id)

);

CREATE TABLE stock(
	discount BIGINT,
	products_id_mysnov BIGINT UNSIGNED NOT NULL,
	products_id_otdohni BIGINT UNSIGNED NOT NULL,

	FOREIGN KEY (products_id_mysnov) REFERENCES products_mysnov(products_id_mysnov),
	FOREIGN KEY (products_id_otdohni) REFERENCES products_otdohni(products_id_otdohni)
	
);

CREATE TABLE basket(
	basket_products_id_mysnov BIGINT UNSIGNED NOT NULL,
	basket_products_id_otdohni BIGINT UNSIGNED NOT NULL,
	basket_user_id BIGINT UNSIGNED NOT NULL,
	basket_discount BIGINT,
	
	FOREIGN KEY (basket_products_id_mysnov) REFERENCES products_mysnov(products_id_mysnov),
	FOREIGN KEY (basket_products_id_otdohni) REFERENCES products_otdohni(products_id_otdohni),
	FOREIGN KEY (basket_user_id) REFERENCES users(id)

);

CREATE TABLE luch(
	luch_user_id BIGINT UNSIGNED NOT NULL,
	luch_products_id_mysnov BIGINT UNSIGNED NOT NULL,
	luch_products_id_otdohni BIGINT UNSIGNED NOT NULL,

	FOREIGN KEY (luch_products_id_mysnov) REFERENCES products_mysnov(products_id_mysnov),
	FOREIGN KEY (luch_products_id_otdohni) REFERENCES products_otdohni(products_id_otdohni),
	FOREIGN KEY (luch_user_id) REFERENCES users(id)

);

CREATE TABLE skittles(
	skittles_user_id BIGINT UNSIGNED NOT NULL,
	addition_skittles BIGINT,
	write_off_skittles BIGINT,
	balance__skittles BIGINT,

	FOREIGN KEY (skittles_user_id) REFERENCES users(id)

);

CREATE TABLE purchase(
	purchase_products_id_mysnov BIGINT UNSIGNED NOT NULL,
	purchase_products_id_otdohni BIGINT UNSIGNED NOT NULL,
	purchase_user_id BIGINT UNSIGNED NOT NULL,
	purchase_discount BIGINT,
	purchase_total BIGINT,

	FOREIGN KEY (purchase_user_id) REFERENCES users(id),
	FOREIGN KEY (purchase_products_id_mysnov) REFERENCES products_mysnov(products_id_mysnov),
	FOREIGN KEY (purchase_products_id_otdohni) REFERENCES products_otdohni(products_id_otdohni)

);




-- 1.Представление скрипты характерных выборок (SELECT, включающие группировки, JOIN'ы, вложенные запросы)
-- 2.представления (минимум 2)

CREATE VIEW top_discount_users
AS SELECT u.id, 
b.basket_products_id_mysnov,
b.basket_discount
FROM users AS u
JOIN basket AS b ON b.basket_user_id = u.id
ORDER BY b.basket_discount DESC


CREATE VIEW adult_user
AS SELECT id
FROM users
WHERE id = 
(
SELECT registration_users_id
FROM  registration_users  
WHERE (YEAR(CURRENT_DATE()) - YEAR(BIRTHDAY)) < 18
)


-- 1. Хранимая процедура
DROP PROCEDURE  IF EXISTS discount_draw;

DELIMITER //

CREATE PROCEDURE discount_draw()
BEGIN
    SELECT p.name_product_mysnov, s.discount 
    FROM products_mysnov AS p
    JOIN stock AS s 
    ON s.products_id_mysnov = p.products_id_mysnov 
    ORDER BY RAND()
    LIMIT 1;

END//

DELIMITER ;

CALL discount_draw()
