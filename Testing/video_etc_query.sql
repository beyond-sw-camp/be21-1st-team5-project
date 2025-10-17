-- 새로운 영상 추가
INSERT INTO video (title, link, thumbnail, director, actor, view_count, category_code)
VALUES ('Slow Horses', 'www.ottlink.com/slow', 'www.thumbnaillink.com/slowhorses',
        'James Hawes', 'Gary Oldman', 3367412, 14);

SELECT *
FROM video
WHERE title = 'Slow Horses';

-- 영상 정보 업데이트
UPDATE video
SET link = 'newottlink.com/slow'
WHERE title = 'Slow Horses';

SELECT *
FROM video
WHERE title = 'Slow Horses';

-- 영상 삭제
DELETE FROM video
WHERE title = 'Slow Horses';

SELECT *
FROM video
WHERE title = 'Slow Horses'