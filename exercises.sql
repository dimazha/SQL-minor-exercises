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
