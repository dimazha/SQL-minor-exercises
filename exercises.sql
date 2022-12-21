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

--№31
SELECT DISTINCT class, country
FROM classes
WHERE bore >= 16

--№32
Select country, cast(avg((power(bore,3)/2)) as numeric(6,2)) as weight
from (select country, classes.class, bore, name from classes left join ships on classes.class=ships.class
union all
select distinct country, class, bore, ship from classes t1 left join outcomes t2 on t1.class=t2.ship
where ship=class and ship not in (select name from ships) ) a
where name IS NOT NULL group by country

--№33
SELECT o.ship 
FROM BATTLES b
LEFT JOIN outcomes o ON o.battle = b.name
WHERE b.name = 'North Atlantic' AND o.result = 'sunk'

--№34
Select name 
from classes,ships 
where launched >=1922 
and displacement>35000 
and type='bb' 
and ships.class = classes.class

--№35
SELECT model, type
FROM product
WHERE upper(model) NOT like '%[^A-Z]%'
OR model not like '%[^0-9]%'

--№36
Select name 
from ships 
where class = name
union
select ship as title 
from classes,outcomes 
where classes.class = outcomes.ship

--№37
SELECT c.class
FROM classes c
 LEFT JOIN (
 SELECT class, name
 FROM ships
 UNION
 SELECT ship, ship
 FROM outcomes
) AS out ON s.class = c.class
GROUP BY c.class
HAVING COUNT(s.name) = 1

--№38
SELECT country
FROM classes
GROUP BY country
HAVING COUNT(DISTINCT type) = 2

--№39
WITH b_s AS
(SELECT o.ship, b.name, b.date, o.result
FROM outcomes o
LEFT JOIN battles b ON o.battle = b.name )
SELECT DISTINCT a.ship FROM b_s a
WHERE UPPER(a.ship) IN
(SELECT UPPER(ship) FROM b_s b
WHERE b.date < a.date AND b.result = 'damaged')

--№40
SELECT DISTINCT maker, MAX(type)
FROM product
GROUP BY maker
HAVING COUNT(model) > 1
AND COUNT(DISTINCT type) = 1

--№41
WITH temp AS 
(SELECT model, price FROM PC
UNION
SELECT model, price FROM Laptop
UNION
SELECT model, price FROM Printer)
SELECT p.maker, 
CASE WHEN COUNT(*) = COUNT(price) THEN MAX(price) END
FROM Product p
INNER JOIN temp
ON p.model = temp.model
GROUP BY p.maker

--№42
SELECT ship, battle
FROM outcomes
WHERE result = 'sunk'

--№43
SELECT name
FROM battles
WHERE YEAR(date) NOT IN 
(SELECT launched
FROM ships
WHERE launched IS NOT NULL)

--№44
SELECT ship
FROM outcomes
WHERE ship LIKE 'R%'
UNION
SELECT name
FROM ships
WHERE name LIKE 'R%'

--№45
SELECT name
FROM ships
WHERE name LIKE '% % %'
UNION
SELECT ship
FROM outcomes
WHERE ship LIKE '% % %'

--№46
SELECT DISTINCT ship, displacement, numGuns
FROM classes c
LEFT JOIN ships s
ON c.class = s.class
RIGHT JOIN outcomes o 
ON c.class = o.ship
OR s.name = o.ship
WHERE battle = 'Guadalcanal'

--№47
WITH temp AS
(SELECT s.name, c.country
FROM classes c JOIN ships s
ON c.class = s.class 
UNION
SELECT o.ship name, c.country
FROM classes c JOIN outcomes o
ON o.ship = c.class), temp2 AS
(SELECT country, COUNT(*) AS count
FROM temp
GROUP BY country), temp3 AS 
(SELECT country, COUNT(*) AS sunk_count
FROM temp JOIN outcomes o
ON o.ship = temp.name
WHERE result ='sunk'
GROUP BY country)
SELECT temp3.country
FROM temp3 JOIN temp2
ON temp2.country = temp3.country
AND temp2.count = temp3.sunk_count

--№48
SELECT class 
FROM Outcomes o
LEFT JOIN ships s
ON o.ship = s.name
WHERE result = 'sunk' AND class IS NOT NULL
UNION 
SELECT class 
FROM Outcomes o
LEFT JOIN classes c
ON o.ship = c.class
WHERE result = 'sunk' AND class IS NOT NULL

--№49
SELECT name 
FROM ships
WHERE class IN
(SELECT class FROM classes WHERE bore = 16)
UNION
SELECT ship FROM outcomes WHERE ship IN
(SELECT class FROM classes WHERE bore = 16)

--№50
SELECT DISTINCT battle
FROM ships s
INNER JOIN outcomes o
ON s.name = o.ship
WHERE s.class = 'Kongo'

--№51
WITH a AS 
(SELECT name AS ship, numGuns, displacement
FROM classes c
INNER JOIN ships s
ON s.class = c.class
UNION
SELECT ship, numGuns, displacement
FROM outcomes o
INNER JOIN classes c
ON o.ship = c.class)
SELECT ship
FROM a
INNER JOIN 
(SELECT displacement, MAX(numGuns) AS MaxNum
FROM a
GROUP BY displacement) AS b
ON a.displacement = b.displacement
AND a.numGuns = b.MaxNum

--№52
SELECT name
FROM ships s
INNER JOIN 
classes c
ON s.class = c.class
WHERE (numGuns >= 9 OR numGuns IS NULL)
AND (bore < 19 OR bore IS NULL)
AND (displacement <= 65000 OR displacement IS NULL)
AND (country = 'Japan' OR country IS NULL)
AND (type = 'bb' OR type IS NULL)

--№53
SELECT CAST(AVG(numGuns*1.0) AS NUMERIC(4,2))
FROM classes
WHERE type = 'bb'

--№54
SELECT CAST(AVG(numGuns * 1.0) AS NUMERIC(6,2)) Avg_numG
FROM
(SELECT s.name, c.numGuns
FROM classes c JOIN ships s
ON c.class = s.class
WHERE type = 'bb'
union
SELECT o.ship, c.numGuns
FROM classes c JOIN outcomes o
ON c.class = o.ship
WHERE type = 'bb') a

--№55
SELECT c.class, MIN(launched)
FROM classes c
LEFT JOIN ships s
ON c.class = s.class
GROUP BY c.class

--№56
WITH temp AS
(SELECT class, COUNT(*) cnt
FROM
(SELECT s.class, o.ship, result
FROM outcomes o 
JOIN ships s
ON s.name = o.ship
UNION
SELECT c.class, o.ship, result
FROM outcomes o 
JOIN classes c
ON c.class = o.ship) a
WHERE result = 'sunk'
GROUP BY class)
SELECT c.class, CASE WHEN cnt IS NULL THEN 0 ELSE cnt END sunk
FROM classes c
LEFT JOIN temp
ON c.class = temp.class

--№57
WITH temp AS
(SELECT class, name 
FROM ships
UNION
SELECT ship AS class, ship AS name
FROM outcomes
WHERE ship IN (SELECT class FROM classes))
, temp2 AS
(SELECT class 
FROM temp
GROUP BY class
HAVING COUNT(name) >= 3)
SELECT temp.class, COUNT(*)
FROM temp
JOIN outcomes o
ON temp.name = o.ship
WHERE result = 'sunk' 
AND temp.class IN (SELECT class FROM temp2)
GROUP BY class

--№58
SELECT m, t,
CAST(100.0*cc/cc1 AS NUMERIC(5,2))
from
(SELECT m, t, sum(c) cc from
(SELECT distinct maker m, 'PC' t, 0 c from product
union all
SELECT distinct maker, 'Laptop', 0 from product
union all
SELECT distinct maker, 'Printer', 0 from product
union all
SELECT maker, type, count(*) from product
group by maker, type) as tt
group by m, t) tt1
JOIN (
SELECT maker, count(*) cc1 from product group by maker) tt2
ON m=maker

--№59
WITH temp AS (
SELECT CASE WHEN i.point IS NULL THEN o.point ELSE i.point END AS point,
CASE WHEN i.date IS NULL THEN o.date ELSE i.date END AS date,
CASE WHEN inc IS NULL THEN 0 ELSE inc END - CASE WHEN out IS NULL THEN 0 ELSE out END AS remain
FROM income_o i
FULL JOIN outcome_o o
ON i.point = o.point
AND i.date = o.date)
SELECT point, SUM(remain) remain
FROM temp
GROUP BY point

--№60
WITH temp AS (
SELECT CASE WHEN i.point IS NULL THEN o.point ELSE i.point END AS point, 
CASE WHEN i.date IS NULL THEN o.date ELSE i.date END AS date,
CASE WHEN inc IS NULL THEN 0 ELSE inc END - CASE WHEN out IS NULL THEN 0 ELSE out END AS remain
FROM income_o i
FULL JOIN outcome_o o
ON i.point = o.point
AND i.date = o.date)
SELECT point, SUM(remain) 
FROM temp
WHERE date < '2001-04-15'
GROUP BY point
