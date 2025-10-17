# 특정연령대 장르별 시청순위 TOP10
# ( ex. 20대 액션영화 TOP10, 40대 로맨스드라마 TOP10, 청소년 스릴러애니메이션 TOP10, …)
DELIMITER //
CREATE OR REPLACE PROCEDURE genreForAges(IN input_group varchar(20),
                                         IN category_name varchar(100),
                                         IN num int
)
BEGIN
    SELECT *
    FROM video v
             JOIN category c ON v.category_code = c.category_code
             JOIN watch_history w ON v.video_id = w.video_id
             JOIN users_age u ON u.user_id = w.user_id
    WHERE c.category_name LIKE CONCAT('%', category_name, '%')
      AND u.age_group = input_group
    GROUP BY v.video_id
    ORDER BY COUNT(*) DESC
    LIMIT num;
END //

DELIMITER ;

CALL genreForAges('20대', '액션영화', 30);

# 연령대별 위시리스트 TOP10
# ( ex. 30대가 가장 보고싶어한 영화 TOP20, 50대가 가장 보고싶어한 드라마 TOP20, …)
DELIMITER //
CREATE OR REPLACE PROCEDURE genreForAgesWishlist(IN input_group varchar(20),
                                                 IN category_name varchar(100),
                                                 IN num int
)
BEGIN
    SELECT *
    FROM video v
             JOIN category c ON v.category_code = c.category_code
             JOIN wish_list w ON v.video_id = w.video_id
             JOIN users_age u ON u.user_id = w.user_id
    WHERE c.category_name LIKE CONCAT('%', category_name, '%')
      AND u.age_group = input_group
    GROUP BY v.video_id
    ORDER BY COUNT(*) DESC
    LIMIT num;
END //

DELIMITER ;

CALL genreForAgesWishlist('20대', '액션영화', 30);


# // 플랫폼별 별점(리뷰5개이상) 높은 순위!!!
DELIMITER //

DROP PROCEDURE IF EXISTS RatingGood //

CREATE PROCEDURE RatingGood(
    IN s_ott_name VARCHAR(100),
    IN result_limit INT
)
BEGIN
    SELECT V.title            AS 비디오_제목,
           V.director         AS 감독,
           OC.ott_name        AS OTT_플랫폼,
           C.category_name    AS 장르,
           AVG(R.rating)      AS 평균_평점,
           COUNT(R.review_no) AS 리뷰_개수
    FROM video V
             INNER JOIN
         reviews R ON V.video_id = R.video_id
             INNER JOIN
         platform P ON V.video_id = P.video_id
             INNER JOIN
         ott_category OC ON P.ott_category_id = OC.ott_category_id
             INNER JOIN
         category C ON V.category_code = C.category_code
    WHERE OC.ott_name = s_ott_name
    GROUP BY V.video_id, V.title, V.director, OC.ott_name, C.category_name
    HAVING COUNT(R.review_no) >= 5
    ORDER BY 평균_평점 DESC, 리뷰_개수 DESC
    LIMIT result_limit;
END//

DELIMITER ;

CALL RatingGood('Netflix', 10);
CALL RatingGood('Disney+', 10);
CALL RatingGood('Watcha', 10);
CALL RatingGood('Waave', 10);
CALL RatingGood('Tving', 10);
CALL RatingGood('Coupang Play', 10);


# -------------------------------------
# -- 장르별 추천 프리시저
# -------------------------------------

-- 1. 대분류별 추천 (영화, 드라마, 애니메이션, 예능, 시사/교양, 공연)
DELIMITER //

CREATE or REPLACE PROCEDURE recommendCategory(IN category bigint,
                                   IN num int)
BEGIN
    SELECT *
    FROM video a
             JOIN category b ON a.category_code = b.category_code
    WHERE b.ref_category_code = category
    LIMIT num;
END //

DELIMITER ;

CALL recommendCategory(1,10);

-- 2. 장르별 추천 (션영화, 로맨스영화, 스릴러영화, 코미디영화, 호러영화, 액션드라마, 로맨스드라마, 스릴러드라마, 코미디드라마,
--              호러드라마, 액션애니메이션, 로맨스애니메이션, 스릴러애니메이션, 코미디애니메이션, 호러애니메이션)

DELIMITER //

CREATE or REPLACE PROCEDURE recommendSubcategory(IN category bigint,
                                      IN num int)
BEGIN
    SELECT *
    FROM video a
             JOIN category b ON a.category_code = b.category_code
    WHERE a.category_code = category
    LIMIT num;
END //

DELIMITER ;

-- 실행결과 확인

CALL recommendSubcategory(7, 10); -- 액션 영화 출력
