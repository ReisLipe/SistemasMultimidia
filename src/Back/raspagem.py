import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options
from bs4 import BeautifulSoup
import requests
import json

def buscar_bolsas(termo_busca):
    options = Options()
    options.add_argument("--headless")
    options.add_argument("--disable-gpu")
    driver = webdriver.Chrome(options=options)
    driver.get("https://www.ipea.gov.br/portal/bolsas-de-pesquisa")
    time.sleep(3)

    try:
        campo_busca = driver.find_element(By.ID, "q")
        campo_busca.clear()
        campo_busca.send_keys(termo_busca)
        campo_busca.send_keys(Keys.RETURN)
        time.sleep(3)

        page = requests.get(driver.current_url)
        soup = BeautifulSoup(page.text, "html.parser")
        div = soup.find('div', id='search-results')

        return str(div) if div else None

    except Exception as e:
        print(f"Erro: {e}")
        return None

    finally:
        driver.quit()

def formatar_json(div_html):
    if not div_html:
        return []

    soup = BeautifulSoup(div_html, "html.parser")
    base_url = 'https://www.ipea.gov.br'
    resultados = []

    for li in soup.select("ul.search-resultsbolsas li"):
        item = {}

        a_tag = li.find("a")
        if a_tag:
            item["titulo"] = a_tag.get_text(strip=True)
            item["link"] = base_url + a_tag["href"]

        for p in li.find_all("p"):
            strong = p.find("strong")
            if strong:
                chave = strong.get_text(strip=True).replace(":", "").lower()
                valor = p.get_text(strip=True).replace(strong.get_text(), "").strip()
                item[chave] = valor

        resultados.append(item)

    return resultados

def salvar_em_arquivo(nome_arquivo, dados):
    with open(nome_arquivo, 'w', encoding='utf-8') as f:
        json.dump(dados, f, indent=4, ensure_ascii=False)
    print(f" Arquivo salvo como '{nome_arquivo}'")

# Uso do raspador
if __name__ == "__main__":
    while True:
        termo = input("Digite o termo de busca (ou 'sair' para encerrar): ").strip()
        if termo.lower() == "sair":
            break

        html_div = buscar_bolsas(termo)
        resultados = formatar_json(html_div)

        if resultados:
            print("\nResultados encontrados:")
            print(json.dumps(resultados, indent=4, ensure_ascii=False))
            nome_arquivo = f"resultados_{termo}.json".replace(" ", "_")
            salvar_em_arquivo(nome_arquivo, resultados)
        else:
            print("Nenhum resultado encontrado.")
