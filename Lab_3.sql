SELECT        Заказы.*
FROM            Заказы
WHERE        (Дата_поставки > CONVERT(DATETIME, '2020-05-01 00:00:00', 102))

SELECT        ТОВАРЫ.*
FROM            ТОВАРЫ
WHERE        (Цена >= 30 AND Цена <= 100)

SELECT        Заказчик
FROM            Заказы
WHERE        (Наименование_товара = N'Стул')

SELECT        Заказчик, Дата_поставки
FROM            Заказы
WHERE        (Заказчик = N'ООО "Черник"')
ORDER BY Дата_поставки DESC