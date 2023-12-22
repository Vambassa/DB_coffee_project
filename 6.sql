'''Выведите в порядке убывания общих сумм заказа за сентябрь 
2023 года имена и фамилии покупателей и суммы их заказов за сентябрь 2023 года'''

SELECT 
    п.имя, 
    п.фамилия, 
    SUM(з.сумма) OVER (PARTITION BY з.id_покупатель) AS общая_сумма
FROM 
    заказ з
JOIN 
    покупатель п ON з.id_покупатель = п.id_покупатель
WHERE 
    з.дата BETWEEN '2023-09-01' AND '2023-09-30'
ORDER BY 
    общая_сумма DESC;
'''Здесь мы объединяем таблицы заказов и 
покупателей по полю id_покупатель, выбираем только те записи, которые соответствуют 
сентябрю 2023 года, суммируем суммы заказов для каждого покупателя и выводим результаты в 
порядке убывания общей суммы заказов за месяц.'''



'''Выведите в порядке убывания количества товаров в наличии 
id_упаковка_кофе из страны Эфиопия стоимостью меньше 2000 и количество товаров в наличии'''
SELECT tn.id_упаковка_кофе, COUNT(tn.id_упаковка_кофе) AS количество_товара
FROM товар_в_наличии tn
JOIN упаковка_кофе у ON tn.id_упаковка_кофе = у.id_упаковка_кофе
WHERE у.страна = 'Эфиопия' AND у.стоимость::numeric < 2000
GROUP BY tn.id_упаковка_кофе
ORDER BY количество_товара DESC;
'''Здесь мы объединяем таблицы товаров в наличии и упаковок кофе 
по полю id_упаковка_кофе, выбираем только те записи, которые соответствуют 
условиям страны Эфиопия и стоимости меньше 2000, считаем количество товаров в 
наличии для каждой упаковки кофе и выводим результаты в порядке убывания количества товаров в наличии.'''



'''Выведите названия cтран, минимальная цена кофе которых 
меньше 2000, а уровень обжарки - светлый и минимальную цену'''
SELECT страна, MIN(стоимость) AS минимальная_цена
FROM упаковка_кофе
WHERE уровень_обжарки = 'Светлая'
GROUP BY страна
HAVING MIN(стоимость::numeric) < 2000;
'''Здесь мы выбираем только те записи из таблицы упаковок кофе, 
которые соответствуют условию светлого уровня обжарки, затем группируем записи по названию 
страны и выводим минимальную цену для каждой страны. Далее, с помощью оператора HAVING мы выбираем 
только те записи, где минимальная цена меньше 2000.'''


'''Выведите в порядке убывания количества магазинов в городе, город и общую сумму заказа из магазинов этого города'''
SELECT 
    магазин.город, 
    SUM(заказ.сумма) AS общая_сумма_заказов,
    COUNT(DISTINCT магазин.id_магазин) AS количество_магазинов
FROM 
    заказ
    JOIN магазин ON заказ.id_магазин = магазин.id_магазин
    JOIN покупатель_история ON заказ.id_покупатель = покупатель_история.id_покупатель
GROUP BY 
    магазин.город
ORDER BY 
    количество_магазинов DESC;
'''Здесь мы выбираем город из таблицы Магазин и суммируем сумму заказов из таблицы Заказ, 
используя функцию SUM(). Также мы считаем количество уникальных магазинов в каждом городе 
с помощью функции COUNT(DISTINCT). Затем мы объединяем таблицы Заказ, Магазин и Покупатель_история
 с помощью JOIN. Затем мы группируем данные по городу с помощью GROUP BY и сортируем результаты по 
 убыванию количества магазинов в городе с помощью ORDER BY.
'''
SELECT 
    у.id_упаковка_кофе, 
    AVG(оценка) OVER (PARTITION BY у.страна) AS средняя_оценка,
    MIN(оценка) OVER (PARTITION BY у.страна, у.id_упаковка_кофе) AS минимальная_оценка,
    о.текст
FROM 
    отзыв о 
    JOIN упаковка_кофе у  ON о.id_упаковка_кофе = у.id_упаковка_кофе
WHERE 
    у.страна = 'Бразилия'
ORDER BY 
    средняя_оценка DESC;

'''Здесь мы используем функцию AVG() 
для вычисления средней оценки на кофе из Бразилии для каждой упаковки кофе. 
Затем мы используем оконную функцию MIN() OVER (PARTITION BY) для вычисления самой низкой оценки для каждой 
упаковки кофе. Чтобы получить отзыв с самой низкой оценкой, мы включаем поле текст из таблицы Отзывы и
 используем его вместе с MIN() OVER (PARTITION BY) в SELECT-запросе. Затем мы объединяем таблицы 
 Упаковка_кофе и Отзывы, используя оператор JOIN, чтобы получить информацию о каждой упаковке кофе и ее 
 отзывах. Далее, мы выбираем только те упаковки кофе, которые были произведены в Бразилии, используя условие 
 WHERE ук.страна = Бразилия. Затем мы группируем результаты по id_упаковка_кофе с помощью оператора GROUP
  BY и сортируем результаты по убыванию средней оценки с помощью оператора ORDER BY.'''
