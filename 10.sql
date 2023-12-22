-- Посчитать какое сумму всех выполненных заказов для определённого магазина в заданный временной промежуток
CREATE OR REPLACE PROCEDURE вывести_статистику(
    m_id_магазин INT,
    m_дата_начала TIMESTAMP,
    m_дата_конца TIMESTAMP)
LANGUAGE plpgsql
AS $$
DECLARE
    m_общая_сумма_заказов MONEY;
BEGIN
    SELECT SUM(coffee_project.заказ.сумма) INTO m_общая_сумма_заказов
    FROM coffee_project.заказ
    WHERE coffee_project.заказ.id_магазин = m_id_магазин
      AND coffee_project.заказ.дата BETWEEN m_дата_начала AND m_дата_конца
      AND coffee_project.заказ.статус = 'Выполнен';

    IF m_общая_сумма_заказов IS NULL THEN
        m_общая_сумма_заказов := 0;
    END IF;

    RAISE NOTICE 'Общая сумма: %', m_общая_сумма_заказов;
END;
$$;


-- Добавить заказ в статусе "В обработке" в таблицу заказов и удаляет заданное количество товара со склада
CREATE OR REPLACE PROCEDURE добавить_заказ(
    m_сумма MONEY,
    m_дата TIMESTAMP,
    m_статус VARCHAR (30),
    m_id_покупатель INTEGER,
    m_id_магазин INTEGER,
    m_id_упаковка_кофе INTEGER,
    m_количество_товара INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    m_id_заказ INTEGER;
BEGIN
    INSERT INTO coffee_project.заказ (сумма, дата, статус, id_покупатель, id_магазин)
    VALUES (m_сумма, m_дата, m_статус, m_id_покупатель, m_id_магазин)
    RETURNING id_заказ INTO m_id_заказ;

    INSERT INTO coffee_project.заказ_кофе (id_заказ, id_упаковка_кофе, количество_товара)
    VALUES (m_id_заказ, m_id_упаковка_кофе, m_количество_товара);

    UPDATE coffee_project.товар_в_наличии
    SET количество_товара = количество_товара - m_количество_товара
    WHERE id_магазин = m_id_магазин AND id_упаковка_кофе = m_id_упаковка_кофе;
END;
$$;
