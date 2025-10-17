
# 대분류 설정
insert into category VALUES (null, '영화',null),
                            (null, '드라마', null),
                            (null, '애니메이션', null),
                            (null, '예능', null),
                            (null, '시사/교양', null),
                            (null, '공연', null)
                            ;
# 중분류 설정
insert into category VALUES (null, '액션영화', 1),
                            (null, '로맨스영화', 1),
                            (null, '스릴러영화', 1),
                            (null, '코미디영화', 1),
                            (NULL, '호러영화', 1),
                            (null, '액션드라마', 2),
                            (null, '로맨스드라마', 2),
                            (null, '스릴러드라마', 2),
                            (null, '코미디드라마', 2),
                            (NULL, '호러드라마', 2),
                            (null, '액션애니메이션', 3),
                            (null, '로맨스애니메이션', 3),
                            (null, '스릴러애니메이션', 3),
                            (null, '코미디애니메이션', 3),
                            (NULL, '호러애니메이션', 3);