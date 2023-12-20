drop schema if exists coffee_project cascade;

create schema coffee_project;

set search_path = coffee_project, public;


-- Создание таблицы с информацией о магазине
DROP TABLE IF EXISTS магазин CASCADE;
create table магазин (
    id_магазин serial primary key,
    название varchar(30) not null unique,
    город varchar(30),
    контактный_телефон text not null unique,
    часы_работы text
);


-- Создание таблицы с информацией о покупателе
DROP TABLE IF EXISTS покупатель CASCADE;
create table покупатель (
    id_покупатель serial primary key,
    имя varchar(30) check (имя != ''),
    фамилия varchar(30) check (фамилия != ''),
    номер_телефона text not null unique,
    id_любимый_магазин integer references магазин(id_магазин) on delete set null
);


-- Создание таблицы с полной информацией о заказе
DROP TABLE IF EXISTS заказ CASCADE;
create table заказ(
    id_заказ serial primary key,
    сумма money not null,
	дата timestamp not null,
	статус varchar(30) default('В обработке') check (статус in ('В обработке', 'Принят', 'Сформирован', 'Отправлен', 'Выполнен')),
    id_покупатель integer not null references покупатель(id_покупатель) on delete cascade,
	id_магазин integer references магазин(id_магазин) on delete cascade
);


-- Создание таблицы с информацией об упаковке кофе 
DROP TABLE IF EXISTS упаковка_кофе CASCADE;
create table упаковка_кофе (
    id_упаковка_кофе serial primary key,
    название_сорта varchar(30) check (название_сорта != ''),
    страна varchar(30) default('-') check (страна in ('Бразилия', 'Колумбия', 'Вьетнам', 'Эфиопия', 'Уганда', 'Гондурас', 'Коста-Рика', '-')),
    метод_обработки varchar(30) default('-'),
    уровень_обжарки varchar(30) default('-') check (уровень_обжарки in ('Светлая', 'Средняя', 'Темная', 'Высшая', '-')),
    стоимость money default 1500
);


-- Создание таблицы с информацией о заказе_кофе
DROP TABLE IF EXISTS заказ_кофе CASCADE;
create table заказ_кофе (
    id_заказ integer not null references заказ(id_заказ) on delete cascade,
    id_упаковка_кофе integer not null references упаковка_кофе(id_упаковка_кофе) on delete cascade,
    количество_товара integer not null,
    primary key (id_заказ, id_упаковка_кофе)
);


-- Создание таблицы с информацией о истории покупателя
DROP TABLE IF EXISTS покупатель_история CASCADE;
create table покупатель_история (
    id serial primary key,
    имя varchar(30) check (имя != ''),
    фамилия varchar(30) check (фамилия != ''),
    номер_телефона text not null,
    id_любимый_магазин integer references магазин(id_магазин) on delete set default,
    id_покупатель integer not null references покупатель(id_покупатель) on delete cascade,
    дата_обновления timestamp not null default(current_date)
);


-- Создание таблицы с информацией о товарах в наличии
DROP TABLE IF EXISTS товар_в_наличии CASCADE;
create table товар_в_наличии (
    id_магазин integer references магазин(id_магазин) on delete cascade,
	id_упаковка_кофе integer references упаковка_кофе(id_упаковка_кофе) on delete cascade,
    количество_товара integer default(0),
    primary key (id_магазин, id_упаковка_кофе)
);


-- Создание таблицы с информацией об обжарщиках 
DROP TABLE IF EXISTS обжарщик CASCADE;
create table обжарщик (
    id_обжарщик serial primary key,
    компания varchar(30) not null unique,
    контактное_лицо varchar(30) not null unique,
    номер_телефона text not null unique,
    страна text default('Россия')
);


-- Создание таблицы с информацией о поставках
DROP TABLE IF EXISTS поставка CASCADE;
create table поставка (
    id_поставка serial primary key,
    дата timestamp not null,
    количество_упаковок integer default(100),
    id_обжарщик integer references обжарщик(id_обжарщик) on delete cascade,
	id_упаковка_кофе integer references упаковка_кофе(id_упаковка_кофе) on delete cascade
);


-- Создание таблицы с отзывами на кофе
DROP TABLE IF EXISTS отзыв CASCADE;
create table отзыв (
    id_отзыв serial primary key,
    текст text,
	оценка integer check( оценка >= 0),
	id_покупатель integer not null references покупатель(id_покупатель) on delete cascade,
    id_упаковка_кофе integer not null references упаковка_кофе(id_упаковка_кофе) on delete cascade,
	id_магазин integer references магазин(id_магазин) on delete cascade
);





