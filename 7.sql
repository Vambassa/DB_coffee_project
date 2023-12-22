DROP SCHEMA IF EXISTS view_coffee_project CASCADE;
CREATE SCHEMA view_coffee_project;

SET SEARCH_PATH = view_coffee_project;


-- Представления
-- Магазин
CREATE OR REPLACE VIEW магазин_view AS
SELECT
    название,
    город,
    left(контактный_телефон, 2) || '********' || right(контактный_телефон, 2) as телефон,
    часы_работы
FROM coffee_project.магазин;


-- покупатель
CREATE OR REPLACE VIEW покупатель_view AS
SELECT
    left(имя, 1) || REPEAT('*', LENGTH(имя) - 1) as имя,
    left(фамилия, 1) || REPEAT('*', LENGTH(фамилия) - 1) as фамилия,
    left(контактный_телефон, 2) || '********' || right(контактный_телефон, 2) as телефон,
    м.название as любимый_магазин
FROM coffee_project.покупатель п
JOIN coffee_project.магазин м ON п.id_любимый_магазин = м.id_магазин;


-- заказ
CREATE OR REPLACE VIEW заказ_view AS
SELECT
    сумма,
    DATE(дата),
    статус,
    left(п.имя, 1) || REPEAT('*', LENGTH(имя) - 1) as имя,
    left(п.фамилия, 1) || REPEAT('*', LENGTH(фамилия) - 1) as фамилия,
    м.название as магазин
FROM coffee_project.заказ з
JOIN coffee_project.покупатель п ON з.id_покупатель = п.id_покупатель
JOIN coffee_project.магазин м ON з.id_магазин = м.id_магазин;


-- упаковка_кофе
CREATE OR REPLACE VIEW упаковка_кофе_view AS
SELECT
    название_сорта,
    страна,
    метод_обработки,
    уровень_обжарки,
    стоимость
FROM coffee_project.упаковка_кофе;


-- заказ_кофе
CREATE OR REPLACE VIEW заказ_кофе_view AS
SELECT
    left(п.имя, 1) || REPEAT('*', LENGTH(имя) - 1) as имя,
    left(п.фамилия, 1) || REPEAT('*', LENGTH(фамилия) - 1) as фамилия,
    ук.название_сорта,
    количество_товара
FROM coffee_project.заказ_кофе зк
JOIN coffee_project.упаковка_кофе ук ON зк.id_упаковка_кофе = ук.id_упаковка_кофе
JOIN coffee_project.заказ з ON зк.id_заказ = з.id_заказ
JOIN coffee_project.покупатель п ON з.id_покупатель = п.id_покупатель;


-- покупатель_история
CREATE OR REPLACE VIEW покупатель_история_view AS
SELECT
    left(имя, 1) || REPEAT('*', LENGTH(имя) - 1) as имя,
    left(фамилия, 1) || REPEAT('*', LENGTH(фамилия) - 1) as фамилия,
    left(номер_телефона, 2) || '********' || right(номер_телефона, 2) as телефон,
    м.название as любимый_магазин
FROM coffee_project.покупатель_история пи
JOIN coffee_project.магазин м ON пи.id_любимый_магазин = м.id_магазин;


-- товар_в_наличии
CREATE OR REPLACE VIEW товар_в_наличии_view AS
SELECT
    м.название as магазин,
    ук.название_сорта,
    твн.количество_товара
FROM coffee_project.товар_в_наличии твн
JOIN coffee_project.магазин м ON твн.id_магазин = м.id_магазин
JOIN coffee_project.упаковка_кофе ук ON твн.id_упаковка_кофе = ук.id_упаковка_кофе;


-- обжарщик
CREATE OR REPLACE VIEW обжарщик_view AS
SELECT
    компания,
    left(контактное_лицо, 1) || REPEAT('*', LENGTH(контактное_лицо) - 1) as контактное_лицо,
    left(номер_телефона, 2) || '********' || right(номер_телефона, 2) as телефон,
    страна
FROM coffee_project.обжарщик;


-- поставка
CREATE OR REPLACE VIEW поставка_view AS
SELECT
    DATE(дата),
    количество_упаковок,
    ож.компания as обжарщик,
    ук.название_сорта
FROM coffee_project.поставка пс
JOIN coffee_project.обжарщик ож ON пс.id_обжарщик = ож.id_обжарщик
JOIN coffee_project.упаковка_кофе ук ON пс.id_упаковка_кофе = ук.id_упаковка_кофе;


-- отзыв
CREATE OR REPLACE VIEW отзыв_view AS
SELECT
    о.текст,
    о.оценка,
    left(п.имя, 1) || REPEAT('*', LENGTH(имя) - 1) as имя,
    left(п.фамилия, 1) || REPEAT('*', LENGTH(фамилия) - 1) as фамилия,
    ук.название_сорта,
    м.название as название_магазина
FROM coffee_project.отзыв о
JOIN coffee_project.покупатель п ON о.id_покупатель = п.id_покупатель
JOIN coffee_project.упаковка_кофе ук ON о.id_упаковка_кофе = ук.id_упаковка_кофе
JOIN coffee_project.магазин м ON о.id_магазин = м.id_магазин;