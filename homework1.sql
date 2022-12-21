CREATE TABLE IF NOT EXISTS users(
    id BIGSERIAL PRIMARY KEY,
    nickname VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS likes(
    id BIGSERIAL PRIMARY KEY,
    author BIGINT NOT NULL REFERENCES users(id),
    recipient BIGINT NOT NULL REFERENCES users(id)
);

--Написать запрос, который выведет такую таблицу:
 --• id пользователя
 --• имя
 --• лайков получено
 --• лайков поставлено
 --• взаимных лайков
SELECT u.id, nickname, COUNT(l.author), COUNT(l.recipient)
FROM likes l
LEFT JOIN users u on u.id = l.author
GROUP BY u.id, nickname;

--Написать запрос, который посчитает 5 самых популярных пользователей
SELECT nickname, COUNT(l.recipient) as popularity
FROM likes l
LEFT JOIN users u on u.id = l.author
GROUP BY nickname
ORDER BY popularity DESC
LIMIT 5;
