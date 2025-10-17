-- 유저 생성

INSERT INTO users (user_id, user_name, user_email, user_pwd, user_nickname, user_birth, is_admin)
VALUES (Null,'김민준','minjun.kim@example.com', 'hashed_password_123','MJ_Gamer','1995-07-25',0 );

SELECT *
FROM users
WHERE user_nickname = 'MJ_Gamer';

-- 유저 수정

UPDATE users
SET user_nickname = 'MJG'
WHERE user_nickname = 'MJ_Gamer';

SELECT *
FROM users
WHERE user_id = 8154;

-- 유저 글 작성
INSERT INTO reviews (review_no, article, rating, user_id, video_id)
VALUES (NULL,'정말 재밌어요', 4, 8154, 10);

SELECT *
FROM reviews
WHERE user_id = 8154;

-- 유저 글 수정
UPDATE reviews
SET article = '최고의 영화에요!'
WHERE user_id = 8154;

SELECT *
FROM reviews
WHERE user_id = 8154;

-- 평점
INSERT INTO watch_history (history_id, create_dt, video_id, user_id)
VALUES (null, NOW(), 153, 8154);

SELECT *
FROM watch_history
WHERE user_id = 8154;
-- 유저 삭제

DELETE FROM users
WHERE user_id = 8154;

SELECT *
FROM users
WHERE user_id = 8154;

SELECT *
FROM reviews
WHERE user_id = 8154;

SELECT *
FROM watch_history
WHERE user_id = 8154;