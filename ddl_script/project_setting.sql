-- =========================================================
--  DATABASE: OTT 서비스 플랫폼
--  STRUCTURE: 정규화 + CASCADE + TRIGGER 완전 버전
-- =========================================================

CREATE DATABASE IF NOT EXISTS ott
    DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;

USE ott;

-- =========================================================
-- 1. 사용자 테이블 (users)
-- =========================================================
CREATE TABLE `users` (
    `user_id` BIGINT NOT NULL AUTO_INCREMENT,
    `user_name` VARCHAR(100) NOT NULL,
    `user_email` VARCHAR(100) NOT NULL UNIQUE,
    `user_pwd` VARCHAR(100) NOT NULL,
    `user_nickname` VARCHAR(100) NOT NULL UNIQUE,
    `user_birth` INT NOT NULL,
    `is_admin` BOOLEAN NULL DEFAULT FALSE,
    CONSTRAINT `PK_USERS` PRIMARY KEY (`user_id`)
) COMMENT '사용자 정보';


-- =========================================================
-- 2. OTT 카테고리 테이블 (ott_category)
-- =========================================================
CREATE TABLE `ott_category` (
    `ott_category_id` INT NOT NULL AUTO_INCREMENT,
    `ott_name` VARCHAR(100) NOT NULL UNIQUE,
    CONSTRAINT `PK_OTT_CATEGORY` PRIMARY KEY (`ott_category_id`)
) COMMENT 'OTT 서비스 정보 (예: Netflix, Disney+, Watcha 등)';


-- =========================================================
-- 3. 카테고리 테이블 (category)
-- =========================================================
CREATE TABLE `category` (
    `category_code` INT NOT NULL AUTO_INCREMENT,
    `category_name` VARCHAR(100) NOT NULL,
    `ref_category_code` INT NULL,
    CONSTRAINT `PK_CATEGORY` PRIMARY KEY (`category_code`),
    CONSTRAINT `FK_CATEGORY_REF` FOREIGN KEY (`ref_category_code`)
        REFERENCES `category` (`category_code`)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) COMMENT '비디오 카테고리 정보 (예: 액션, 드라마, 다큐멘터리)';


-- =========================================================
-- 4. 비디오 테이블 (video)
-- =========================================================
CREATE TABLE `video` (
    `video_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '비디오 고유 ID',
    `title` VARCHAR(100) NOT NULL COMMENT '비디오 제목',
    `link` VARCHAR(255) NULL COMMENT '비디오 링크',
    `thumbnail` TEXT NULL COMMENT '썸네일 이미지 경로',
    `director` VARCHAR(100) NULL COMMENT '감독명',
    `actor` VARCHAR(100) NULL COMMENT '주요 출연 배우',
    `view_count` BIGINT NULL DEFAULT 0 COMMENT '조회수',
    `category_code` INT NOT NULL COMMENT '카테고리 코드 (FK)',
    CONSTRAINT `PK_VIDEO` PRIMARY KEY (`video_id`),
    CONSTRAINT `FK_VIDEO_CATEGORY` FOREIGN KEY (`category_code`)
        REFERENCES `category` (`category_code`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) COMMENT '비디오 메타데이터';


-- =========================================================
-- 5. 등급 테이블 (grade)
-- =========================================================
CREATE TABLE `grade` (
    `grade` VARCHAR(3) NOT NULL COMMENT '등급명 (예: ALL, 12, 15, 19)',
    `video_id` BIGINT NOT NULL COMMENT '비디오 아이디 (FK)',
    CONSTRAINT `PK_GRADE` PRIMARY KEY (`grade`, `video_id`),
    CONSTRAINT `FK_GRADE_VIDEO` FOREIGN KEY (`video_id`)
        REFERENCES `video` (`video_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) COMMENT '비디오 등급 정보';


-- =========================================================
-- 6. 플랫폼 테이블 (platform)
--  - OTT와 비디오 간 N:M 관계
-- =========================================================
CREATE TABLE `platform` (
    `platform_id` INT NOT NULL AUTO_INCREMENT,
    `ott_category_id` INT NOT NULL COMMENT 'OTT 카테고리 아이디 (FK)',
    `video_id` BIGINT NOT NULL COMMENT '비디오 아이디 (FK)',
    CONSTRAINT `PK_PLATFORM` PRIMARY KEY (`platform_id`),
    CONSTRAINT `UK_PLATFORM_UNIQUE` UNIQUE (`ott_category_id`, `video_id`),
    CONSTRAINT `FK_PLATFORM_OTT` FOREIGN KEY (`ott_category_id`)
        REFERENCES `ott_category` (`ott_category_id`)
        ON DELETE CASCADE   -- OTT 삭제 시 platform도 삭제됨
        ON UPDATE CASCADE,
    CONSTRAINT `FK_PLATFORM_VIDEO` FOREIGN KEY (`video_id`)
        REFERENCES `video` (`video_id`)
        ON DELETE CASCADE   -- 비디오 삭제 시 platform도 삭제됨
        ON UPDATE CASCADE
) COMMENT '비디오가 어떤 OTT 플랫폼에 포함되어 있는지';


-- =========================================================
-- 7. 리뷰 테이블 (reviews)
-- =========================================================
CREATE TABLE `reviews` (
    `review_no` INT NOT NULL AUTO_INCREMENT,
    `article` TEXT NULL COMMENT '리뷰 본문',
    `rating` TINYINT NOT NULL COMMENT '평점 (1~5점)',
    `user_id` BIGINT NOT NULL COMMENT '사용자 ID (FK)',
    `video_id` BIGINT NOT NULL COMMENT '비디오 ID (FK)',
    CONSTRAINT `PK_REVIEWS` PRIMARY KEY (`review_no`),
    CONSTRAINT `FK_REVIEWS_USERS` FOREIGN KEY (`user_id`)
        REFERENCES `users` (`user_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT `FK_REVIEWS_VIDEO` FOREIGN KEY (`video_id`)
        REFERENCES `video` (`video_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) COMMENT '비디오 리뷰 정보';


-- =========================================================
-- 8. 찜 목록 테이블 (wish_list)
-- =========================================================
CREATE TABLE `wish_list` (
    `wish_list_code` INT NOT NULL AUTO_INCREMENT,
    `create_dt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    `user_id` BIGINT NOT NULL COMMENT '사용자 ID (FK)',
    `video_id` BIGINT NOT NULL COMMENT '비디오 ID (FK)',
    CONSTRAINT `PK_TO_WATCH_LIST` PRIMARY KEY (`to_watch_code`),
    CONSTRAINT `UK_TOWL_UNIQUE` UNIQUE (`user_id`, `video_id`),
    CONSTRAINT `FK_TOWL_USERS` FOREIGN KEY (`user_id`)
        REFERENCES `users` (`user_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT `FK_TOWL_VIDEO` FOREIGN KEY (`video_id`)
        REFERENCES `video` (`video_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) COMMENT '사용자 찜 목록';


-- =========================================================
-- 9. 시청 기록 테이블 (watch_history)
-- =========================================================
CREATE TABLE `watch_history` (
    `history_id` INT NOT NULL AUTO_INCREMENT,
    `create_dt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '시청 일시',
    `video_id` BIGINT NOT NULL COMMENT '비디오 ID (FK)',
    `user_id` BIGINT NOT NULL COMMENT '사용자 ID (FK)',
    CONSTRAINT `PK_WATCH_HISTORY` PRIMARY KEY (`history_id`),
    CONSTRAINT `FK_WH_VIDEO` FOREIGN KEY (`video_id`)
        REFERENCES `video` (`video_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT `FK_WH_USERS` FOREIGN KEY (`user_id`)
        REFERENCES `users` (`user_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) COMMENT '사용자 시청 기록';


-- =========================================================
-- 🔄 트리거: OTT 삭제 → 플랫폼 삭제 → 비디오 자동 삭제
-- =========================================================
DELIMITER $$

CREATE TRIGGER `trg_platform_after_delete`
AFTER DELETE ON `platform`
FOR EACH ROW
BEGIN
    DECLARE cnt INT;
    -- 해당 비디오가 다른 플랫폼에도 존재하는지 확인
    SELECT COUNT(*) INTO cnt
    FROM platform
    WHERE video_id = OLD.video_id;

    -- 더 이상 어떤 플랫폼에도 포함되지 않으면 비디오 삭제
    IF cnt = 0 THEN
        DELETE FROM video WHERE video_id = OLD.video_id;
    END IF;
END $$

DELIMITER ;

-- =========================================================
-- ✅ 요약:
-- 1. ott_category 삭제 → platform 자동 삭제
-- 2. platform 삭제 시 → 비디오가 다른 플랫폼에 없으면 삭제
-- 3. video 삭제 시 → reviews, grade, watch_history, to_watch_list, platform 자동 삭제
-- =========================================================