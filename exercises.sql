--№1
SELECT model, speed, hd FROM PC WHERE price < 500

--№2
SELECT DISTINCT maker FROM Product WHERE Product.type = 'Printer'  

--№3
SELECT model, ram, screen FROM Laptop WHERE price > 1000  

--№4
SELECT * FROM Printer WHERE color = 'y'  

--№5
SELECT model, speed, hd FROM PC WHERE (CD = '12x' OR CD = '24x') AND price < 600  

--№6
SELECT DISTINCT Product.maker, Laptop.speed
FROM Laptop
JOIN Product
ON Product.model = Laptop.model
WHERE Laptop.hd >= 10

--№7
SELECT Product.model, PC.price
FROM Product 
JOIN PC
ON Product.model = PC.model
WHERE Product.maker = 'B'
UNION
SELECT Product.model, Laptop.price
FROM Product 
JOIN Laptop
ON Product.model = Laptop.model
WHERE Product.maker = 'B'
UNION
SELECT Product.model, Printer.price
FROM Product 
JOIN Printer
ON Product.model = Printer.model
WHERE Product.maker = 'B'

--№8
SELECT DISTINCT Product.maker
FROM Product
WHERE type = 'PC'
EXCEPT
SELECT DISTINCT Product.maker
FROM Product
WHERE type = 'Laptop'

--№9
SELECT DISTINCT Product.maker
FROM PC
INNER JOIN Product 
ON Product.model = PC.model
WHERE PC.speed >= 450

--№10
SELECT model, price
FROM Printer
WHERE price = 
  (SELECT MAX(price)
  FROM Printer)

--№11
SELECT AVG(speed) FROM PC

--№12
SELECT AVG(speed)
FROM Laptop
WHERE price > 1000

--№13
SELECT AVG(PC.speed)
FROM Product 
JOIN PC
ON Product.model = PC.model
WHERE maker = 'A'

--№14
SELECT Ships.class, Ships.name, Classes.country
FROM Ships
JOIN Classes
ON Classes.class = Ships.class
WHERE numGuns >= 10

--№15
SELECT hd 
FROM pc 
GROUP BY hd 
HAVING COUNT(model) >= 2

--№16
SELECT DISTINCT pc2.model, pc1.model, pc1.speed, pc1.ram
FROM PC pc1, PC pc2
WHERE pc1.speed = pc2.speed AND pc1.ram = pc2.ram AND pc2.model > pc1.model

--№17
SELECT DISTINCT  Product.type, Product.model, Laptop.speed
FROM Laptop
JOIN Product
ON Product.model = Laptop.model
WHERE speed < (SELECT MIN (speed) FROM PC)

--№18
SELECT DISTINCT Product.maker, Printer.price
FROM Printer
JOIN Product
ON Product.model = Printer.model
WHERE color = 'y'
AND price = (SELECT MIN(price) FROM Printer WHERE color = 'y')

--№19
SELECT maker, AVG(screen)
FROM Laptop
JOIN Product
ON Laptop.model = Product.model
GROUP BY maker

--№20
SELECT maker, COUNT(model)
FROM Product
WHERE type = 'pc'
GROUP BY maker
HAVING COUNT(model) >= 3

--№21
SELECT maker, MAX(PC.price)
FROM PC, Product
WHERE PC.model = Product.model
GROUP BY Product.maker

--№22
SELECT speed, AVG(price)
FROM PC
WHERE speed > 600
GROUP BY speed

--№23
SELECT DISTINCT maker
FROM Product
JOIN Laptop
ON Product.model = Laptop.model
WHERE speed >= 750
AND maker IN
(SELECT DISTINCT maker
FROM Product
JOIN PC
ON Product.model = PC.model
WHERE speed >= 750)

--№24
SELECT model FROM
(SELECT DISTINCT model, price FROM laptop WHERE laptop.price = (SELECT MAX(price) FROM laptop)  
UNION 
SELECT DISTINCT model, price FROM pc WHERE pc.price = (SELECT MAX(price) FROM pc)  
UNION 
SELECT DISTINCT model, price FROM printer WHERE printer.price = (SELECT MAX(price) FROM printer)) as mod1 
WHERE mod1.price=(SELECT MAX(price) FROM 
(SELECT DISTINCT price FROM laptop WHERE laptop.price = (SELECT MAX(price) FROM laptop)  
UNION 
SELECT DISTINCT price FROM pc WHERE pc.price = (SELECT MAX(price) FROM pc)  
UNION 
SELECT DISTINCT price FROM printer WHERE printer.price = (SELECT MAX(price) FROM printer)) as mod2)

--№25
SELECT DISTINCT maker
FROM product
WHERE model IN (SELECT model
                FROM pc
                WHERE ram = (SELECT MIN(ram)
                             FROM pc)
AND speed = (SELECT MAX(speed)
             FROM pc
             WHERE ram = (SELECT MIN(ram)
                          FROM pc)))
AND
maker IN (SELECT maker
          FROM product
          WHERE type='printer')

--№26
SELECT SUM(s.price)/SUM(s.kol) as Средняя_цена 
FROM
(SELECT price,1 as kol FROM pc,product
 WHERE pc.model=product.model AND product.maker='A'
UNION all
 SELECT price,1 as kol FROM laptop,product
 WHERE laptop.model=product.model AND product.maker='A') as s

--№27
SELECT product.maker, AVG(pc.hd)
FROM pc, product WHERE product.model = pc.model
AND product.maker IN (SELECT DISTINCT maker
FROM product
WHERE product.type = 'printer')
GROUP BY maker

--№28
SELECT COUNT(maker) as mak 
FROM (SELECT DISTINCT maker
FROM product 
GROUP BY maker 
HAVING COUNT(model) = 1) AS pr

--№29
SELECT t1.point, t1.date, inc, out
FROM income_o t1 LEFT 
JOIN outcome_o t2 ON t1.point = t2.point
AND t1.date = t2.date
UNION
SELECT t2.point, t2.date, inc, out
FROM income_o t1 RIGHT 
JOIN outcome_o t2 ON t1.point = t2.point
AND t1.date = t2.date

--№30
SELECT point, date, SUM(sum_out), SUM(sum_inc)
FROM(SELECT point, date, SUM(inc) as sum_inc, null as sum_out 
     FROM Income 
     GROUP BY point, date
UNION
SELECT point, date, null as sum_inc, SUM(out) as sum_out 
FROM Outcome 
GROUP BY point, date ) as t
GROUP BY point, date 
ORDER BY point
