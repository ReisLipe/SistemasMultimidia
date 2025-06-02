import requests
from bs4 import BeautifulSoup
import pandas as pd


base_url = "https://www.ipea.gov.br"
url = base_url + "/portal/bolsas-de-pesquisa"

response = requests.get(url)
response.encoding = 'utf-8'

soup = BeautifulSoup(response.text, "html.parser")

# Lista no html do site da ipea
lista_chamadas = soup.find("ul", class_="search-resultsbolsas")

dados = []

if lista_chamadas:
    chamadas = lista_chamadas.find_all("li")
    
    for chamada in chamadas:
        # Titulo e link
        h4 = chamada.find("h4", class_="result-title")
        a_tag = h4.find("a") if h4 else None
        titulo = a_tag.get_text(strip=True) if a_tag else ""
        link = base_url + a_tag["href"] if a_tag and "href" in a_tag.attrs else ""
        
        # Situacao e Programa
        p_tags = chamada.find_all("p")
        situacao = ""
        programa = ""
        
        for p in p_tags:
            strong = p.find("strong")
            if strong:
                label = strong.get_text(strip=True).replace(":", "")
                texto = p.get_text(strip=True).replace(strong.get_text(), "").strip()
                
                if label == "Situação":
                    situacao = texto
                elif label == "Programa":
                    programa = texto
        
        dados.append({
            "Título": titulo,
            "Situação": situacao,
            "Programa": programa,
            "Link": link
        })
else:
    print("Lista de chamadas não encontrada na página.")


df = pd.DataFrame(dados)
df.to_csv("bolsas_ipea.csv", index=False, encoding="utf-8-sig")

print("✅ Dados salvos no arquivo 'bolsas_ipea.csv'")
