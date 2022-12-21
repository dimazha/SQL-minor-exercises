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

--№61
SELECT sum(i) FROM
(SELECT point, sum(inc) as i FROM
income_o
GROUP BY point
UNION
SELECT point, -sum(out) as i FROM
outcome_o
GROUP BY point
) as t

--№62
SELECT
(SELECT sum(inc) FROM Income_o WHERE date<'2022-12-18')
-
(SELECT sum(out) FROM Outcome_o WHERE date<'2022-12-18')
AS ost

--№63
SELECT name FROM Passenger
WHERE ID_psg in
(SELECT ID_psg FROM Pass_in_trip
GROUP BY place, ID_psg
HAVING count(*)>1)

--№64
SELECT i1.point, i1.date, 'inc', sum(inc) FROM Income,
(SELECT point, date FROM Income
EXCEPT
SELECT Income.point, Income.date FROM Income
JOIN Outcome ON (Income.point=Outcome.point) AND
(Income.date=Outcome.date)
) AS i1
WHERE i1.point=Income.point AND i1.date=Income.date
GROUP BY i1.point, i1.date
UNION
SELECT o1.point, o1.date, 'out', sum(out) FROM Outcome,
(SELECT point, date FROM Outcome
EXCEPT
SELECT Income.point, Income.date FROM Income
JOIN Outcome ON (Income.point=Outcome.point) AND
(Income.date=Outcome.date)
) AS o1
WHERE o1.point=Outcome.point AND o1.date=Outcome.date
GROUP BY o1.point, o1.date

--№65
SELECT row_number() over(ORDER BY maker,s),t, type FROM
(SELECT maker,type,
CASE
WHEN type='PC'
THEN 0
WHEN type='Laptop'
THEN 1
ELSE 2
END AS s,
CASE
WHEN type='Laptop' AND (maker in (SELECT maker FROM Product WHERE
type='PC'))
THEN
WHEN type='Printer' AND ((maker in (SELECT maker FROM Product WHERE
type='PC')) OR (maker in (SELECT maker FROM Product WHERE
type='Laptop')))
THEN ''
ELSE maker
END AS t
FROM Product
GROUP BY maker,type) AS t1
ORDER BY maker, s

--№66
SELECT date, max(c) FROM
(SELECT date,count(*) AS c FROM Trip,
(SELECT trip_no,date FROM Pass_in_trip WHERE date>='2003-04-01' AND date<='2003-04-07' GROUP BY trip_no, date) AS t1
WHERE Trip.trip_no=t1.trip_no AND town_from='Rostov'
GROUP BY date
UNION ALL
SELECT '2003-04-01',0
UNION ALL
SELECT '2003-04-02',0
UNION ALL
SELECT '2003-04-03',0
UNION ALL
SELECT '2003-04-04',0
UNION ALL
SELECT '2003-04-05',0
UNION ALL
SELECT '2003-04-06',0
UNION ALL
SELECT '2003-04-07',0) AS t2
GROUP BY date

--№67
select count(*) from
(SELECT TOP 1 WITH TIES count(*) c, town_from, town_to from trip
group by town_from, town_to
order by c desc) as t

--№68
select count(*) from (
select TOP 1 WITH TIES sum(c) cc, c1, c2 from (
SELECT count(*) c, town_from c1, town_to c2 from trip
where town_from>=town_to
group by town_from, town_to
union all
SELECT count(*) c,town_to, town_from from trip
where town_to>town_from
group by town_from, town_to) as way1
group by c1,c2
order by cc desc) as way2

--№69
with t as
(select point, "date", inc, 0 AS "out" from income
  union all
  select point, "date", 0 AS inc, "out" from outcome)
SELECT t.point, TO_CHAR ( t."date", 'DD/MM/YYYY') AS day,
 (select SUM(i.inc) from t i
  where i."date" <= t."date" and i.point = t.point )
-
(select SUM(i."out") from t i
 where i."date" <= t."date" and i.point = t.point ) AS rem
from t
group by t.point, t."date"

--№70
SELECT DISTINCT o.battle
FROM outcomes o
LEFT JOIN ships s ON s.name = o.ship
LEFT JOIN classes c ON o.ship = c.class OR s.class = c.class
WHERE c.country IS NOT NULL
GROUP BY c.country, o.battle
HAVING COUNT(o.ship) >= 3

--№71
SELECT p.maker
FROM product p
LEFT JOIN pc ON pc.model = p.model
WHERE p.type = 'PC'
GROUP BY p.maker
HAVING COUNT(p.model) = COUNT(pc.model)

--№72
select TOP 1 WITH TIES name, c3 from passenger
join
(select c1, max(c3) c3 from
(select pass_in_trip.ID_psg c1, Trip.ID_comp c2, count(*) c3 from pass_in_trip
join trip on trip.trip_no=pass_in_trip.trip_no
group by pass_in_trip.ID_psg, Trip.ID_comp) as t
group by c1
having count(*)=1) as tt
on ID_psg=c1
order by c3 desc

--№73
SELECT DISTINCT c.country, b.name
FROM battles b, classes c
MINUS
SELECT c.country, o.battle
FROM outcomes o
LEFT JOIN ships s ON s.name = o.ship
LEFT JOIN classes c ON o.ship = c.class OR s.class = c.class
WHERE c.country IS NOT NULL
GROUP BY c.country, o.battle

--№74
SELECT c.country, c.class
FROM classes c
WHERE UPPER(c.country) = 'RUSSIA' AND EXISTS (
SELECT c.country, c.class
FROM classes c
WHERE UPPER(c.country) = 'RUSSIA' )
UNION ALL
SELECT c.country, c.class
FROM classes c
WHERE NOT EXISTS (SELECT c.country, c.class
FROM classes c
WHERE UPPER(c.country) = 'RUSSIA' )

--№75
select maker, max(l.price) as laptop, max(pc.price) as pc, max(pr.price) as printer
from laptop l 
right join product p on l.model = p.model 
left join pc on pc.model = p.model 
left join printer pr on p.model = pr.model
where maker in (select maker from product 
where model in (select model from pc where price is not null 
union 
select model from printer where price is not null 
union 
select model from laptop where price is not null)) 
group by maker 
order by maker;

--№76
WITH cte AS
(SELECT ROW_NUMBER() OVER (PARTITION BY ps.ID_psg,pit.place ORDER BY pit.date) AS rowNumber
,DATEDIFF (minute, time_out, DATEADD(DAY,IIF(time_in<time_out,1,0),time_in)) AS timeFlight, ps.Id_psg, ps.name
FROM Pass_in_trip pit LEFT JOIN trip tr ON pit.trip_no = tr.trip_no
LEFT JOIN Passenger ps ON ps.ID_psg = pit.ID_psg)
SELECT MAX(cte.name),SUM(timeFlight) FROM cte
GROUP BY cte.ID_psg
HAVING MAX(rowNumber) = 1

--№77
SELECT TOP 1 WITH TIES * FROM (
  SELECT COUNT (DISTINCT P.trip_no) count, date
  FROM Pass_in_trip P
  JOIN Trip T ON T.trip_no = P.trip_no AND town_from = 'Rostov'
  GROUP BY P.trip_no, date) X
ORDER BY 1 DESC

--№78
SELECT name, REPLACE(CONVERT(CHAR(12), DATEADD(m, DATEDIFF(m,0,date),0), 102),'.','-') AS first,
             REPLACE(CONVERT(CHAR(12), DATEADD(s,-1,DATEADD(m, DATEDIFF(m,0,date)+1,0)), 102),'.','-') AS end
FROM Battles

--№79
SELECT Passenger.name, A.minutes
FROM (SELECT P.ID_psg,
      SUM((DATEDIFF(minute, time_out, time_in) + 1440)%1440) AS minutes,
      MAX(SUM((DATEDIFF(minute, time_out, time_in) + 1440)%1440)) OVER() AS MaxMinutes
      FROM Pass_in_trip P JOIN
       Trip AS T ON P.trip_no = T.trip_no
      GROUP BY P.ID_psg
      ) AS A JOIN
 Passenger ON Passenger.ID_psg = A.ID_psg
WHERE A.minutes = A.MaxMinutes

--№80
SELECT DISTINCT maker
FROM product
WHERE maker NOT IN (
     SELECT maker
     FROM product
     WHERE type='PC' AND model NOT IN (
          SELECT model
          FROM PC))

--№81
SELECT O.*
FROM outcome O
INNER JOIN

--№82
(SELECT TOP 1 WITH TIES YEAR(date) AS year, MONTH(date) AS month, SUM(out) AS vsego
FROM outcome
GROUP BY YEAR(date), MONTH(date)
ORDER BY ALL_TOTAL DESC) R 
ON YEAR(O.date) = R.year 
AND MONTH(O.date) = R.month

--№83
WITH CTE(code,price,number)
AS
(
SELECT PC.code,PC.price, number= ROW_NUMBER() OVER (ORDER BY PC.code)
FROM PC
)
SELECT CTE.code, AVG(C.price)
FROM CTE
JOIN CTE C ON (C.number-CTE.number)<6 AND (C.number-CTE.number)> =0
GROUP BY CTE.number,CTE.code
HAVING COUNT(CTE.number)=6

--№84
SELECT name
FROM Ships AS s JOIN Classes AS cl1 ON s.class = cl1.class
WHERE
CASE WHEN numGuns = 8 THEN 1 ELSE 0 END +
CASE WHEN bore = 15 THEN 1 ELSE 0 END +
CASE WHEN displacement = 32000 THEN 1 ELSE 0 END +
CASE WHEN type = 'bb' THEN 1 ELSE 0 END +
CASE WHEN launched = 1915 THEN 1 ELSE 0 END +
CASE WHEN s.class = 'Kongo' THEN 1 ELSE 0 END +
CASE WHEN country = 'USA' THEN 1 ELSE 0 END > = 4

--№85
SELECT C.name, A.N_1_10, A.N_11_21, A.N_21_30
FROM (SELECT T.ID_comp,
       SUM(CASE WHEN DAY(P.date) < 11 THEN 1 ELSE 0 END) AS N_1_10,
       SUM(CASE WHEN (DAY(P.date) > 10 AND DAY(P.date) < 21) THEN 1 ELSE 0 END) AS N_11_21,
       SUM(CASE WHEN DAY(P.date) > 20 THEN 1 ELSE 0 END) AS N_21_30
      FROM Trip AS T JOIN
       Pass_in_trip AS P ON T.trip_no = P.trip_no AND CONVERT(char(6), P.date, 112) = '200304'
      GROUP BY T.ID_comp
      ) AS A JOIN
 Company AS C ON A.ID_comp = C.ID_comp

--№86
select maker
from product
group by maker
having count(distinct type) = 1 and
       (min(type) = 'pc' or
       (min(type) = 'printer' and count(model) > 2))

--№87
SELECT maker,
       CASE count(distinct type) when 2 then MIN(type) + '/' + MAX(type)
                                 when 1 then MAX(type)
                                 when 3 then 'Laptop/PC/Printer' END
FROM Product
GROUP BY maker

--№88
SELECT DISTINCT name, COUNT(town_to) nazn
FROM Trip tr JOIN Pass_in_trip pit ON tr.trip_no = pit.trip_no JOIN
         Passenger psg ON pit.ID_psg = psg.ID_psg
WHERE town_to = 'Moscow' AND pit.ID_psg NOT IN(SELECT DISTINCT ID_psg
FROM Trip tr JOIN Pass_in_trip pit ON tr.trip_no = pit.trip_no
WHERE date+time_out = (SELECT MIN (date+time_out)
                       FROM Trip tr1 JOIN Pass_in_trip pit1 ON tr1.trip_no = pit1.trip_no
                       WHERE pit.ID_psg = pit1.ID_psg)
AND town_from = 'Moscow')
GROUP BY pit.ID_psg, name
HAVING COUNT(town_to) > 1

--№89
SELECT
 (SELECT name FROM Passenger WHERE ID_psg = B.ID_psg) AS name,
 B.trip_Qty,
 (SELECT name FROM Company WHERE ID_comp = B.ID_comp) AS Company
FROM (SELECT P.ID_psg, MIN(T.ID_comp) AS ID_comp, COUNT(*) AS trip_Qty, MAX(COUNT(*)) OVER() AS Max_Qty
      FROM Pass_in_trip AS P JOIN
       Trip AS T ON P.trip_no = T.trip_no
      GROUP BY P.ID_psg
      HAVING MIN(T.ID_comp) = MAX(T.ID_comp)
      ) AS B
WHERE B.trip_Qty = B.Max_Qty

--№90
select Maker , count(distinct model) mod 
from Product
group by maker
having count(distinct model) > = ALL
(select count(distinct model) 
from Product
group by maker)
or
count(distinct model) <= ALL
(select count(distinct model) 
from Product
group by maker)

--№92
SELECT Q_NAME
FROM utQ
WHERE Q_ID IN (SELECT DISTINCT B.B_Q_ID
FROM (SELECT B_Q_ID
FROM utB
GROUP BY B_Q_ID
HAVING SUM(B_VOL) = 765) AS B
WHERE B.B_Q_ID NOT IN (SELECT B_Q_ID
FROM utB
WHERE B_V_ID IN (SELECT B_V_ID
FROM utB
GROUP BY B_V_ID
HAVING SUM(B_VOL) < 255)))

--№93
select c.name, sum(vr.vr)
from
(select distinct t.id_comp, pt.trip_no, pt.date,t.time_out,t.time_in,--pt.id_psg,
case
     when DATEDIFF(mi, t.time_out,t.time_in)> 0 then DATEDIFF(mi, t.time_out,t.time_in)
     when DATEDIFF(mi, t.time_out,t.time_in)<=0 then DATEDIFF(mi, t.time_out,t.time_in+1)
end vr
from pass_in_trip pt left 
join trip t on pt.trip_no=t.trip_no) 
join company c on vr.id_comp=c.id_comp
group by c.name

--№94
SELECT DATEADD(day, S.Num, D.date) AS Dt,
       (SELECT COUNT(DISTINCT P.trip_no)
        FROM Pass_in_trip P
               JOIN Trip T
                 ON P.trip_no = T.trip_no
                    AND T.town_from = 'Rostov'
                    AND P.date = DATEADD(day, S.Num, D.date)) AS Qty
FROM (SELECT (3 * ( x - 1 ) + y - 1) AS Num
        FROM (SELECT 1 AS x UNION ALL SELECT 2 UNION ALL SELECT 3) AS N1
               CROSS JOIN (SELECT 1 AS y UNION ALL SELECT 2 UNION ALL SELECT 3) AS N2
        WHERE (3 * ( x - 1 ) + y ) < 8) AS S,
       (SELECT MIN(A.date) AS date
        FROM (SELECT P.date,
                       COUNT(DISTINCT P.trip_no) AS Qty,
                       MAX(COUNT(DISTINCT P.trip_no)) OVER() AS M_Qty
                FROM Pass_in_trip AS P
                       JOIN Trip AS T
                         ON P.trip_no = T.trip_no
                            AND T.town_from = 'Rostov'
                GROUP BY P.date) AS A
        WHERE A.Qty = A.M_Qty) AS D

--№95
SELECT name,
    COUNT(DISTINCT CONVERT(CHAR(24),date)+CONVERT(CHAR(4),Trip.trip_no)),
    COUNT(DISTINCT plane),
    COUNT(DISTINCT ID_psg),
    COUNT(*)
FROM Company,Pass_in_trip,Trip
WHERE Company.ID_comp=Trip.ID_comp and Trip.trip_no=Pass_in_trip.trip_no
GROUP BY Company.ID_comp,name

--№96
with r as (select v.v_name,
       v.v_id,
       count(case when v_color = 'R' then 1 end) over(partition by v_id) cnt_r,
       count(case when v_color = 'B' then 1 end) over(partition by b_q_id) cnt_b
  from utV v join utB b on v.v_id = b.b_v_id)
select v_name
  from r
where cnt_r > 1
  and cnt_b > 0
group by v_name

--№97
select code, speed, ram, price, screen
from laptop where exists (
  select 1 x
  from (
    select v, rank()over(order by v) rn
    from ( select cast(speed as float) sp, cast(ram as float) rm,
                  cast(price as float) pr, cast(screen as float) sc
    )l unpivot(v for c in (sp, rm, pr, sc))u
  )l pivot(max(v) for rn in ([1],[2],[3],[4]))p
  where [1]*2 <= [2] and [2]*2 <= [3] and [3]*2 <= [4])

--№98
with CTE AS
(select
1 n, cast (0 as varchar(16)) bit_or,
code, speed, ram FROM PC
UNION ALL
select n*2,
cast (convert(bit,(speed|ram)&n) as varchar(1))+cast(bit_or as varchar(15))
, code, speed, ram
from CTE where n < 65536)
select code, speed, ram from CTE
where n = 65536
and CHARINDEX('1111', bit_or )> 0

--№99
select point, "date" income_date, "date" + nvl(
                  min(case when diff > cnt then cnt else null end),
                  max(cnt)+1
                ) incass_date
from (select i.point,
             i."date",
             (trunc(o."date") - trunc(i."date")) diff,
             count(1) over (partition by i.point, i."date" order by o."date" rows between unbounded preceding and current row)-1 cnt
      from income_o i
               join (select point, "date", 1 disabled from outcome_o
                     union
                     select point, trunc("date"+7,'DAY'), 1 disabled from income_o) o
                 on i.point = o.point
      where o."date" > = i."date")
group by point, "date";

--№100
Select distinct A.date , A.R, B.point, B.inc, C.point, C.out
From (Select distinct date, ROW_Number() OVER(PARTITION BY date ORDER BY code asc) as R From Income
Union Select distinct date, ROW_Number() OVER(PARTITION BY date ORDER BY code asc) From Outcome) A
LEFT Join (Select date, point, inc
                , ROW_Number() OVER(PARTITION BY date ORDER BY code asc) as RI FROM Income
           ) B on B.date=A.date and B.RI=A.R
LEFT Join (Select date, point, out
                , ROW_Number() OVER(PARTITION BY date ORDER BY code asc) as RO FROM Outcome
           ) C on C.date=A.date and C.RO=A.R;
