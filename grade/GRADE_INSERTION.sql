DELIMITER //

CREATE PROCEDURE insert_grade_data()
BEGIN
    DECLARE v_id INT DEFAULT 1;
    DECLARE v_grade VARCHAR(3);
        
    -- 1부터 5939까지 반복
    WHILE v_id <= 5939 DO
        -- 랜덤 등급 선택 (all, 12, 15, 19)
        SET v_grade = ELT(1 + FLOOR(RAND() * 4), 'all', '12', '15', '19');
        
        INSERT INTO grade (video_id, grade) VALUES (v_id, v_grade);
        
        SET v_id = v_id + 1;
    END WHILE;
    
END //

DELIMITER ;

CALL insert_grade_data();

DROP PROCEDURE IF EXISTS insert_grade_data;