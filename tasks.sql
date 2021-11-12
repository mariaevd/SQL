--Найдите номер модели, скорость и размер жесткого диска для всех ПК стоимостью менее 500 дол. Вывести: model, speed и hd
	
	SELECT model, speed, hd
	FROM PC
	WHERE price < 500;
	
--Найдите производителей принтеров. Вывести: maker
	
	SELECT DISTINCT maker
	FROM Product
	WHERE type = 'Printer';
	
--Найдите номер модели, объем памяти и размеры экранов ПК-блокнотов, цена которых превышает 1000 дол.
	
	SELECT model, ram, screen
	FROM Laptop
	WHERE price > 1000;
	
--Найдите все записи таблицы Printer для цветных принтеров.
	
	SELECT code, model, color, type, price
	FROM Printer
	WHERE color = 'y';
	
--Найдите номер модели, скорость и размер жесткого диска ПК, имеющих 12x или 24x CD и цену менее 600 дол.
	
	SELECT model, speed, hd
	FROM PC
	WHERE (cd = '12x' or cd = '24x') and price < 600;
	
--Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска не менее 10 Гбайт, найти скорости таких ПК-блокнотов. Вывод: производитель, скорость.
	
	SELECT DISTINCT Product.maker, Laptop.speed
	FROM Product INNER JOIN Laptop
	ON Product.model = Laptop.model
	WHERE Laptop.hd >= 10;
	
--Найдите номера моделей и цены всех имеющихся в продаже продуктов (любого типа) производителя B (латинская буква).

	SELECT model, price 
	FROM PC 
	WHERE model IN (SELECT model 
		FROM Product 
		WHERE maker = 'B' AND 
		type = 'PC'
		)
	UNION
	SELECT model, price 
	FROM Laptop 
	WHERE model IN (SELECT model 
		FROM Product 
		WHERE maker = 'B' AND 
		type = 'Laptop'
		)
	UNION
	SELECT model, price 
	FROM Printer 
	WHERE model IN (SELECT model 
		FROM Product 
		WHERE maker = 'B' AND 
		type = 'Printer'
		);

--Найдите производителя, выпускающего ПК, но не ПК-блокноты.

	SELECT maker FROM Product
	WHERE type = 'PC'
	EXCEPT
	SELECT maker FROM Product
	WHERE type = 'Laptop';
	
--Найдите производителей ПК с процессором не менее 450 Мгц. Вывести: Maker.

	SELECT DISTINCT Maker
	FROM Product INNER JOIN PC
	ON Product.model = PC.model
	WHERE PC.speed >= 450;

--Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price.

	SELECT model, price
	FROM Printer
	WHERE price = (SELECT MAX(price)
		FROM Printer
		);

--Найдите среднюю скорость ПК.
	
	SELECT AVG(speed) AS speed
	FROM PC;
	
--Найдите среднюю скорость ПК-блокнотов, цена которых превышает 1000 дол.

	SELECT AVG(speed) AS speed 
	FROM Laptop
	WHERE price > 1000;
	
--Найдите среднюю скорость ПК, выпущенных производителем A.

	SELECT AVG(speed) AS speed
	FROM PC INNER JOIN Product
	ON PC.model = Product.model
	WHERE Product.maker = 'A';
	
--Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий.

	SELECT Ships.class, Ships.name, Classes.country
	FROM Ships INNER JOIN Classes
	ON Ships.class = Classes.class
	WHERE Classes.numGuns >= 10;
	
--Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD.

	SELECT hd
	FROM PC
	GROUP BY hd
	HAVING COUNT(model) >= 2;

--Найдите пары моделей PC, имеющих одинаковые скорость и RAM. В результате каждая пара указывается только один раз, т.е. (i,j), но не (j,i), Порядок вывода: модель с большим номером, модель с меньшим номером, скорость и RAM.

	SELECT DISTINCT A.model AS model_1, B.model AS model_2, A.speed, A.ram
	FROM PC AS A, PC B
	WHERE A.speed = B.speed and A.ram = B.ram and
	A.model > B.model;
	
--Найдите модели ПК-блокнотов, скорость которых меньше скорости каждого из ПК. Вывести: type, model, speed

	SELECT DISTINCT Product.type, Product.model, Laptop.speed
	FROM Laptop INNER JOIN Product
	ON Laptop.model = Product.model
	WHERE Laptop.speed < (SELECT MIN(speed) FROM PC);
	
--Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price.
	
	SELECT DISTINCT Product.maker, Printer.price
	FROM Product INNER JOIN Printer
	ON Product.model = Printer.model
	WHERE Printer.color = 'y' and Printer.price = (SELECT MIN(price) FROM Printer WHERE Printer.color = 'y');

--Для каждого производителя, имеющего модели в таблице Laptop, найдите средний размер экрана выпускаемых им ПК-блокнотов. Вывести: maker, средний размер экрана.

	SELECT Product.maker, AVG(screen) AS screen
	FROM Product INNER JOIN Laptop
	ON Product.model = Laptop.model
	GROUP BY Product.maker;
	
--Найдите производителей, выпускающих по меньшей мере три различных модели ПК. Вывести: Maker, число моделей ПК.

	SELECT Product.maker, COUNT(model)
	FROM Product
	WHERE Product.type = 'PC'
	GROUP BY Product.maker
	HAVING COUNT(DISTINCT model) >= 3;
	
--Найдите максимальную цену ПК, выпускаемых каждым производителем, у которого есть модели в таблице PC. Вывести: maker, максимальная цена.

	SELECT product.maker, MAX(price) AS price
	FROM product INNER JOIN PC
	ON product.model = pc.model
	GROUP BY product.maker;
	
--Для каждого значения скорости ПК, превышающего 600 МГц, определите среднюю цену ПК с такой же скоростью. Вывести: speed, средняя цена.

	SELECT pc.speed, AVG(price)
	FROM pc 
	GROUP BY pc.speed
	HAVING pc.speed > 600;
	
--Найдите производителей, которые производили бы как ПК со скоростью не менее 750 МГц, так и ПК-блокноты со скоростью не менее 750 МГц. Вывести: Maker

	SELECT  DISTINCT maker
	FROM product INNER JOIN pc ON product.model = pc.model
	WHERE pc.speed >= 750 and maker IN
	(SELECT maker
	FROM product INNER JOIN laptop ON product.model = laptop.model
	WHERE laptop.speed >= 750);

