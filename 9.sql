SET SEARCH_PATH = coffee_project;

-- 1
-- При изменении любимого магазина у покупателя, обновляем историю покупателя
CREATE OR REPLACE FUNCTION update_favorite_store_history()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.id_любимый_магазин <> OLD.id_любимый_магазин THEN
        INSERT INTO покупатель_история (имя, фамилия, номер_телефона, id_любимый_магазин, id_покупатель, дата_обновления)
        VALUES (NEW.имя, NEW.фамилия, NEW.номер_телефона, NEW.id_любимый_магазин, NEW.id_покупатель, DEFAULT);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER after_update_favorite_store
AFTER UPDATE OF id_любимый_магазин ON покупатель
FOR EACH ROW
EXECUTE FUNCTION update_favorite_store_history();

-- демонстрация 1
UPDATE покупатель
SET id_любимый_магазин = 7
WHERE id_покупатель = 1;

select * from покупатель_история;



-- 2
-- При поступлении заказа, проверяем, что на складе достаточно товара,
-- если нет -- отменяем заказ
CREATE OR REPLACE FUNCTION проверить_наличие()
RETURNS TRIGGER AS $$
DECLARE
   	магазин INTEGER;
    колво_в_наличии INTEGER;
BEGIN
   	магазин := (select id_магазин
   				from заказ
   				where id_заказ = NEW.id_заказ);
   	колво_в_наличии := (select количество_товара
   						from товар_в_наличии
   						where id_магазин = магазин
   						and id_упаковка_кофе = new.id_упаковка_кофе);
   
   	IF NEW.количество_товара > колво_в_наличии THEN
        UPDATE заказ
        SET статус = 'Отменен'
        WHERE id_заказ = NEW.id_заказ;
       return null;
    END IF;
   

    UPDATE товар_в_наличии
    SET количество_товара = количество_товара - NEW.количество_товара
    WHERE id_магазин = магазин 
   		AND id_упаковка_кофе = NEW.id_упаковка_кофе;
   	
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE TRIGGER проверить_заказ
BEFORE INSERT ON заказ_кофе
FOR EACH ROW
EXECUTE FUNCTION проверить_наличие();


-- демонстрация 2
INSERT INTO упаковка_кофе (название_сорта, страна, метод_обработки, уровень_обжарки, стоимость)
VALUES ('Коста-Рика Сан Хосе', 'Коста-Рика', 'Мытая', 'Темная', '3500');

INSERT INTO товар_в_наличии (id_магазин, id_упаковка_кофе, количество_товара) VALUES (1, 16, 10);

select * from товар_в_наличии where id_магазин = 1 and id_упаковка_кофе = 16;

INSERT INTO заказ (id_заказ, сумма, дата, статус, id_покупатель, id_магазин)
VALUES (35, 10000, CURRENT_TIMESTAMP, 'В обработке', 1, 1);

-- недостаток на складе
INSERT INTO заказ_кофе (id_заказ, id_упаковка_кофе, количество_товара)
VALUES (35, 16, 500);

-- хватает
INSERT INTO заказ_кофе (id_заказ, id_упаковка_кофе, количество_товара)
VALUES (35, 16, 5);


select * from заказ_кофе;
select * from заказ;
select * from товар_в_наличии where id_магазин = 1 and id_упаковка_кофе = 16;


delete from заказ where id_заказ = 35;
delete from заказ_кофе where id_заказ = 35;
