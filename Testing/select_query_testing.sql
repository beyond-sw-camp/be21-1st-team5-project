SELECT
    a.title AS '제목' ,
    b.category_name AS "장르",
    a.view_count 
FROM video a
JOIN category b ON a.category_code = b.category_code
WHERE b.ref_category_code = 1
ORDER BY a.view_count DESC
LIMIT 10;

SELECT 
a.title,
b.category_name,
a.view_count
FROM video a
JOIN category b ON a.category_code = b.category_code 
WHERE b.category_name LIKE ('로맨스%')
ORDER BY a.view_count DESC
LIMIT 10;