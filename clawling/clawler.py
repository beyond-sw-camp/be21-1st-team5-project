import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# --- 드라이버 설정 ---
chrome_options = webdriver.ChromeOptions()
chrome_options.add_experimental_option("detach", True)
driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=chrome_options)
driver.maximize_window()

# --- 1. 페이지 접속 ---
url = 'https://m.kinolights.com/discover/explore'
driver.get(url)
print("🔗 키노라이츠 탐색 페이지 로딩 완료.")

# --- 2. 넷플릭스 필터 버튼 클릭 ---
try:
    print("🔍 넷플릭스 필터 버튼을 찾습니다...")
    netflix_button = WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((
            By.XPATH,
            "//button[.//i[contains(@class, 'kino-icon kino-icon--watcha-play')]]"
        ))
    )
    driver.execute_script("arguments[0].click();", netflix_button)
    print("✅ 넷플릭스 필터 버튼을 성공적으로 클릭했습니다!")
    time.sleep(3)
except Exception as e:
    print(f"❌ 넷플릭스 버튼 클릭 중 오류가 발생했습니다: {e}")
    driver.quit()
    exit()

# --- 3. 🎬 1,000개 수집 또는 끝까지 스크롤 ---
print("⬇️ 목표(1000개) 또는 페이지 끝까지 스크롤을 시작합니다...")
last_height = driver.execute_script("return document.body.scrollHeight")
collected_titles = set()  # 중복 저장을 방지하기 위해 set 사용

while len(collected_titles) < 1000:
    # 페이지 맨 아래로 스크롤
    driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    time.sleep(2)  # 콘텐츠 로딩 대기

    # 현재 화면에 보이는 모든 제목 요소를 가져옴
    title_elements = driver.find_elements(By.CSS_SELECTOR, "span.body__title")

    # 새로운 제목들을 set에 추가
    for element in title_elements:
        title = element.text
        if title:  # 비어있지 않은 제목만 추가
            collected_titles.add(title)

    # 스크롤 후 높이 측정
    new_height = driver.execute_script("return document.body.scrollHeight")

    # 수집 현황 출력
    print(f"🔄 스크롤 중... 수집된 제목: {len(collected_titles)}/1000")

    # 더 이상 스크롤이 되지 않으면(페이지 끝에 도달하면) 반복 중단
    if new_height == last_height:
        print("🛑 페이지 맨 아래에 도달했습니다. 스크롤을 중단합니다.")
        break
    last_height = new_height

# --- 4. 💾 수집된 데이터를 파일로 저장 ---
print(f"\n📝 총 {len(collected_titles)}개의 제목 수집 완료. 파일에 저장합니다.")

# 1000개가 넘었다면 1000개까지만 잘라서 저장
final_titles = list(collected_titles)[:1000]

try:
    # 'output.txt' 파일에 UTF-8 인코딩으로 저장
    with open('output.txt', 'w', encoding='utf-8') as f:
        for i, title in enumerate(final_titles, 1):
            f.write(f"{i}. {title}\n")
    print("✅ 'output.txt' 파일 저장이 완료되었습니다.")

except Exception as e:
    print(f"❌ 파일 저장 중 오류가 발생했습니다: {e}")

print("\n🎉 스크립트 실행이 완료되었습니다.")