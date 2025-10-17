<img src="./Gemini_Generated_Image_6ie0ko6ie0ko6ie0.png" width=850 height= 720>

<br/>
<br/>


# 1. Project Overview (프로젝트 개요)
- 프로젝트 이름: " 너 뭐봤어? "
- 팀 이름 : 無제
- 프로젝트 설명: 도대체 뭘 봐야 할 지 모르겠는 요즘, 연령별 추천으로 더욱 빠르게 영상 선택후 시청 !

  
<br/>
<br/>

# 2. Team Members (팀원 및 팀 소개)
| 이건우 | 정규원 | 이상준 | 윤홍석 |
|:------:|:------:|:------:|:------:|
| <img width="150" src="https://github.com/user-attachments/assets/ca495e10-3288-41a2-a682-0600df99b304" alt="이건우" /> | <img src="https://github.com/user-attachments/assets/c349b2c7-79b1-44b6-bc13-90b52ba90fa6" alt="정규원" width="150"> | <img src="https://github.com/user-attachments/assets/33011338-a3c0-4f6e-b0d2-5198f6b0729b" alt="이상준" width="150"> | <img src="https://github.com/user-attachments/assets/66bdcd20-7ab9-413f-ae3d-6f5fae802c27" alt="윤홍석" width="150"> |
| BE | BE | BE | BE |
| [GitHub](https://github.com/LDK1009) | [GitHub](https://github.com/Gyuwon-Jung) | [GitHub](https://github.com/Ongsaem0) | [GitHub](https://github.com/ehsy25) |

<br/>
<br/>

# 3. Key Features (주요 기능)

- ** 특정 연령대별 추천 **:
  - 15세 미만, 청소년 관람불가, 20대, 30대, 40대 등등... 연령별 별점 및 조회수기반 영상추천😘 !


- ** 장르별 추천 **:
  - 액션, 로맨스, 스릴러, 코미디 등등... 장르별 추천받기 가능😍 !


- ** 플랫폼별 추천 **:
  - 넷플릭스, 디즈니+, 쿠팡 플레이 등 6개 플랫폼의 영상확인 가능 !


- ** 별점과 조회수 기반 **:
  - 특정 연령대, 장르, 플랫폼 모두를 합쳐도 별점과 조회수기반 추천 가능 !


- ** 관심목록 **:
  - 나중에 보고싶은 영상 찜꽁 가능 !
  - 미성년자는 찜꽁만 가능하고 영상 시청은 ❌(성인되면 보세요) !!!


- ** 리뷰검색 **:
  - 영상 시청 전 리뷰확인 후 영상 시청 가능 !


<br/>
<br/>

## 🏛️ DB 설계

### 1. ER 다이어그램 (ERD)

> 💡 ERD 이미지를 이곳에 삽입하여 테이블 간의 관계를 시각적으로 보여주세요.

<img width="1968" height="1072" alt="너 뭐봤어_" src="https://github.com/user-attachments/assets/778a542b-c770-4fbc-99fe-8e8f8069cb75" />

<br>

### 2. 유즈케이스 다이어그램

> 💡 시스템의 전체적인 기능과 사용자-시스템 간의 상호작용을 나타냅니다.

<img width="903" height="777" alt="image" src="https://github.com/user-attachments/assets/de53788e-5df9-4cac-b62a-adaf16ec9f35" />


### 3. Replica Server

<img width="1162" height="606" alt="slave_status" src="https://github.com/user-attachments/assets/75345f31-d069-433f-a225-5b3e31b19039" />
<img width="1117" height="518" alt="master_side" src="https://github.com/user-attachments/assets/8b818c6d-423f-48a6-9bf4-bcb6c49802a3" />


<br>

### 4. 핵심 로직 (Stored Procedures)


> 💡 **특정 연령대/장르별 시청 순위 TOP N**을 반환하는 Stored Procedure입니다.

<br>

![연령별 장르](https://github.com/user-attachments/assets/78a398d3-e599-4a84-a60d-5339ea608f95)

<br>

<details>
<summary><b>[PROCEDURE] genreForAges 코드 보기</b></summary>

```sql
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

```
</details>


<br />

> 💡 **특정 연령대/장르별 찜 목록 순위 TOP N**을 반환하는 Stored Procedure입니다.

<br>

![위시리스트](https://github.com/user-attachments/assets/fd50900c-8be6-488e-aafd-3faad8283e88)


<br>

<details>
<summary><b>[PROCEDURE] genreForAgesWishlist 코드 보기</b></summary>
  
```sql
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
```
</details>

<br />

> 💡 **플랫폼별 별점 순위 TOP N**을 반환하는 Stored Procedure입니다.

<br>


![플랫폼별](https://github.com/user-attachments/assets/390dae55-b05d-4649-a1cb-90224607f6e6)


<br>

<details>
<summary><b>[PROCEDURE] RatingGood 코드 보기</b></summary>

  ```sql
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
 ```
</details>

<br />

> 💡 **대분류 카테고리별 전체 시청 순위 TOP N**을 반환하는 Stored Procedure입니다.

<br>


![대분류](https://github.com/user-attachments/assets/a94b96fb-8d02-4780-aba2-5cb007ccc9e9)



<br>


<details>
<summary><b>[PROCEDURE] recommendCategory 코드 보기</b></summary>

  ```sql
-- 대분류별 추천 (영화, 드라마, 애니메이션, 예능, 시사/교양, 공연)
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
  ```
</details>

<br />

> 💡 **중분류 카테고리별 전체 시청 순위 TOP N**을 반환하는 Stored Procedure입니다.

<br>


![중분류](https://github.com/user-attachments/assets/d779481d-1f86-43a1-9728-4140af5ce914)



<br>

<details>
<summary><b>[PROCEDURE] recommendSubcategory 코드 보기</b></summary>

```sql
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
```
</details>

<br />
<br />

# 4. 산출물
### 1. 요구사항 정의서

<img width="2522" height="1850" alt="image" src="https://github.com/user-attachments/assets/59e02b44-2a9a-419f-832a-3362e31e215e" />
[요구사항명세.pdf](https://github.com/user-attachments/files/22939020/default.pdf)

<br>

### 2. 테이블 정의서
<img width="1273" height="559" alt="image" src="https://github.com/user-attachments/assets/b1cb303a-d4a4-4c7e-ac73-885d9f81a862" />
https://docs.google.com/spreadsheets/d/1XuGiOeN81BNXQ872vB4l5lMVDLwzt4yCBBkFVzkoo7U/edit?usp=sharing
<br/>
<br/>

# 5. Technology Stack (기술 스택)

|  |  |
|-----------------|-----------------|
| MariaDB    |<img src="https://github.com/user-attachments/assets/fb62bd46-87e5-47d1-99ce-78b1d423aec2" alt="MariaDB" width="100">| 
| Git    |  <img src="https://github.com/user-attachments/assets/483abc38-ed4d-487c-b43a-3963b33430e6" alt="git" width="100">    | 
| GitHub |  <img src="https://github.com/user-attachments/assets/022dcd7c-f9fc-45b5-8eb9-b4113ea5baf7" alt="GitHub" img width="100"> |
| Notion    |  <img src="https://github.com/user-attachments/assets/34141eb9-deca-416a-a83f-ff9543cc2f9a" alt="Notion" width="100">  |
| DBeaver    |  <img src="https://github.com/user-attachments/assets/4a4b6d01-3a45-4ceb-87d8-69939f403a47" alt="Dbeaver" width="100">  |
| Linux  |  <img width="100" alt="Linux" src="https://github.com/user-attachments/assets/9838f491-3048-4126-b19c-0700af706a68" />
| Ubuntu  |  <img width="100" height="189" alt="Ubuntu" src="https://github.com/user-attachments/assets/ac26afd3-cafe-464a-acba-6c4ac2c4fee1" /> |

<br/>

<br/>

# 6. Project Structure (프로젝트 구조)
```plaintext
project
├── category/                                            ## 영상 장르 테이블
│   └── create_category.sql
├── clawling/                                            ## 플랫폼별 데이터 크로울링
│   ├── clawler.py
│   ├── coupang.txt
│   ├── disney.txt
│   ├── neflix.txt
│   ├── tving.txt
│   ├── watcha.txt
│   └── wavve.txt
├── create video/                                        ## 플랫폼별 영상 데이터 생성
│   ├── 2_create_disney.sql
│   ├── 3_create_watcha.sql
│   ├── 4_create_wavve.sql
│   ├── 5_create_tving.sql
│   ├── 6_create_coupang.sql
│   └── create_video_full.sql
├── ddl_script/                                          ## 데이터베이스 테이블 생성
│   └── project_setting.sql
├── dummy_reviews/                                       ## 사용자 리뷰 더미데이터
│   ├── reviews_age_filtered_part_1.sql
│   ├── reviews_age_filtered_part_2.sql
│   ├── reviews_age_filtered_part_3.sql
│   ├── reviews_age_filtered_part_4.sql
│   └── reviews_age_filtered_part_5.sql
├── dummy_watch_history/                                 ## 사용자 시청기록 더미데이터
│   ├── watch_history_from_reviews_part_1.sql
│   ├── watch_history_from_reviews_part_10.sql
│   ├── watch_history_from_reviews_part_2.sql
│   ├── watch_history_from_reviews_part_3.sql
│   ├── watch_history_from_reviews_part_4.sql
│   ├── watch_history_from_reviews_part_5.sql
│   ├── watch_history_from_reviews_part_6.sql
│   ├── watch_history_from_reviews_part_7.sql
│   ├── watch_history_from_reviews_part_8.sql
│   └── watch_history_from_reviews_part_9.sql
├── dummy_wish_list/                                     ## 사용자 관심목록 더미데이터
│   ├── wish_list_data_last_year_part_1.sql
│   ├── wish_list_data_last_year_part_2.sql
│   ├── wish_list_data_last_year_part_3.sql
│   ├── wish_list_data_last_year_part_4.sql
│   └── wish_list_data_last_year_part_5.sql
├── Gemini_Generated_Image_6ie0ko6ie0ko6ie0.png          ## 팀로고
├── platform/                                            ## 플랫폼 데이터 생성 
│   └── platform_data_insertion.sql
├── procedure/                                           ## 프로시저 생성
│   └── create_procedure.sql
├── README.md
└── users_grade/                                         ## 사용자 연령별 구분 데이터
    ├── users_15세미만.sql
    ├── users_1957~1966(60대) .sql
    ├── users_1967~1976(50대).sql
    ├── users_1987~1996(30대).sql
    ├── users_1987~1996(40대).sql
    ├── users_1997~2006(20대).sql
    ├── users_2000년대생.sql
    └── users_random.sql
```

<br/>
<br/>
