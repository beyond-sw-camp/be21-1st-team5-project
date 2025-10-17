truncate TABLE platform;

DELIMITER //
CREATE PROCEDURE InsertAllPlatformData()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE cat INT;
    DECLARE done INT DEFAULT 0;
    
    -- Set random seed for reproducible randomness (optional)
    SET @seed = UNIX_TIMESTAMP();
    
    WHILE i <= 5939 DO
        -- Generate random ott_category_id between 1-6
        SET cat = FLOOR(1 + RAND() * 6);
        
        INSERT INTO platform (ott_category_id, video_id) VALUES (cat, i);
        
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;

CALL InsertAllPlatformData();
DROP PROCEDURE InsertAllPlatformData;

-- procedure to generate dummy data for platform table

-- Check distribution of categories
SELECT ott_category_id, COUNT(*) as count 
FROM platform 
GROUP BY ott_category_id 
ORDER BY ott_category_id;

-- Verify all video_ids are present
SELECT COUNT(*) as total_videos FROM platform;
-- Should return 981

WITH RECURSIVE VideoSeries (video_id) AS (
    -- 앵커 멤버: 시작 값 (995)
    SELECT 995
    
    UNION ALL
    
    -- 재귀 멤버: video_id를 1씩 증가시키며 1975까지 반복
    SELECT video_id + 1
    FROM VideoSeries
    WHERE video_id < 1975
),
-- 각 비디오에 대해 무작위로 OTT 카테고리 ID를 할당할 후보군 생성
RandomOttPairs AS (
    SELECT
        v.video_id,
        -- 1에서 6 사이의 랜덤 정수를 ott_category_id로 선택
        (FLOOR(1 + (RAND() * 6))) AS ott_category_id, 
        -- 각 비디오당 최대 3개의 연결 시도 (Multiplier 테이블을 이용)
        ROW_NUMBER() OVER (PARTITION BY v.video_id ORDER BY RAND()) as rn
    FROM VideoSeries v
    -- 각 비디오당 연결 시도 횟수를 늘리기 위한 임시 테이블 (1, 2, 3)
    CROSS JOIN (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3) AS Multiplier 
)
-- 최종적으로 고유한 OTT-Video 쌍을 platform 테이블에 삽입
INSERT INTO platform (ott_category_id, video_id)
SELECT DISTINCT
    rop.ott_category_id,
    rop.video_id
FROM RandomOttPairs rop
-- 각 비디오당 랜덤하게 1개에서 3개의 연결만 유지 (랜덤성을 더함)
WHERE rop.rn <= FLOOR(1 + (RAND() * 3)) 
ORDER BY rop.video_id, rop.ott_category_id;