START TRANSACTION;
SAVEPOINT spn;
ROLLBACK;

SELECT v.title, oc.ott_name 
FROM ott_category oc 
JOIN platform p ON oc.ott_category_id = p.ott_category_id 
JOIN video v ON p.video_id = v.video_id
WHERE p.ott_category_id = 1;

DELETE FROM ott_category  
WHERE ott_name = 'Netflix';

SELECT v.title, oc.ott_name 
FROM ott_category oc 
JOIN platform p ON oc.ott_category_id = p.ott_category_id 
JOIN video v ON p.video_id = v.video_id
WHERE p.ott_category_id = 1; 