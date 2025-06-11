import time
import json
import traceback
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from bs4 import BeautifulSoup


# Configurações do navegador
chrome_options = ChromeOptions()
chrome_options.add_argument("--headless")  # Ative se quiser rodar sem abrir janela
chrome_options.add_argument("--disable-gpu")
chrome_options.add_argument("--no-sandbox")
chrome_options.add_argument("--disable-dev-shm-usage")
chrome_options.add_argument("user-agent=Mozilla/5.0")
chrome_options.add_argument("--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36")


def buscar_bolsas_Ipea(termo_busca):
    driver = webdriver.Chrome(options=chrome_options)
    try:
        driver.get("https://www.ipea.gov.br/portal/bolsas-de-pesquisa")
        time.sleep(3)

        campo_busca = WebDriverWait(driver, 10).until(
            EC.element_to_be_clickable((By.ID, "q"))
        )
        campo_busca.clear()
        campo_busca.send_keys(termo_busca)
        campo_busca.send_keys(Keys.RETURN)

        time.sleep(3)
        html = driver.page_source
        soup = BeautifulSoup(html, "html.parser")
        div = soup.find('div', id='search-results')
        formatar_json(str(div))

    except Exception:
        traceback.print_exc()
        return None
    finally:
        driver.quit()

        
def buscar_bolsas_facepe():
    driver = webdriver.Chrome(options=chrome_options)
    try:
        driver.get("https://www.facepe.br/editais/todos/?c=aberto")
        time.sleep(3)
        html = driver.page_source
        soup = BeautifulSoup(html, "html.parser")
        div = soup.findAll("div", class_="edital clearfix")
        extrair_editais_para_json(str(div))
    except Exception:
        traceback.print_exc()
        return None
    finally:
        driver.quit()


def buscar_bolsas_gov(termo_busca):
    driver = webdriver.Chrome(options=chrome_options)
    try:
        driver.get("https://www.gov.br/pt-br/search?origem=form&SearchableText=Bolsas%20de%20pesquisa")
        wait = WebDriverWait(driver, 15)
        time.sleep(3)
        try:
            btn_rejeitar = wait.until(EC.element_to_be_clickable((By.CSS_SELECTOR, 'button[aria-label="Rejeitar cookies"]')))
            btn_rejeitar.click()
        except:
            pass  # Se não aparecer, ignora

        campo_busca = wait.until(EC.element_to_be_clickable((By.ID, "searchtext-input")))
        campo_busca.clear()
        campo_busca.send_keys(" "+termo_busca)
        campo_busca.send_keys(Keys.RETURN)
        time.sleep(3)
        wait.until(EC.presence_of_element_located((By.ID, "search-results")))
        time.sleep(2)

        html = driver.page_source
        soup = BeautifulSoup(html, "html.parser")
        div = soup.find('div', id='search-results')
        return str(div) if div else None
    except Exception:
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
    salvar_em_arquivo('Ipea.Json',resultados)
    return resultados


def extrair_editais_para_json(html, arquivo_saida="Facepe.Json"):
    soup = BeautifulSoup(html, "html.parser")
    editais_html = soup.find_all("div", class_="edital clearfix")

    resultados = []

    for edital in editais_html:
        try:
            conteudo = edital.find("div", class_="edital-conteudo")
            titulo_tag = conteudo.find("h5").find_all("a")[-1]  # último <a> contém o título
            titulo = titulo_tag.get_text(strip=True)
            link_pdf = titulo_tag.get("href")

            # Encontra a data de publicação (aparece como texto após <hr/>)
            publicacao_texto = conteudo.get_text(separator="\n", strip=True)
            data_publicacao = None
            for linha in publicacao_texto.splitlines():
                if "Publicação:" in linha:
                    data_publicacao = linha.replace("Publicação:", "").strip()
                    break

            # Link de download
            download_tag = edital.find("a", class_="avia-button")
            link_download = download_tag.get("href") if download_tag else link_pdf

            resultados.append({
                "titulo": titulo,
                "link_pdf": link_pdf,
                "data_publicacao": data_publicacao,
                "link_download": link_download
            })
        except Exception as e:
            print("Erro ao processar edital:", e)

    salvar_em_arquivo(arquivo_saida, resultados)

def salvar_em_arquivo(nome_arquivo, dados):
    with open(nome_arquivo, 'w', encoding='utf-8') as f:
        json.dump(dados, f, indent=4, ensure_ascii=False)
    
if __name__ == "__main__":
      buscar_bolsas_Ipea('saúde') # só chamar essa função e passar a palavra a ser pesquisada no site do Ipea
      buscar_bolsas_facepe() #só chamar a função e n precisa passar nada e ela retorna os dados do site da FACEPE
      #buscar_bolsas_gov('saúde') # ainda estou trabalhando nela , não usar no momento
