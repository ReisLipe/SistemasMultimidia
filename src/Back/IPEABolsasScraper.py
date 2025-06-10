
import requests
import datetime
import pandas as pd
import re

from bs4 import BeautifulSoup
from typing import Dict, List, Optional


class IPEABolsasScraper:
    """Scraper para coletar dados de bolsas do IPEA"""

    def __init__(self):
        self.base_url = "https://www.ipea.gov.br"
        self.url = self.base_url + "/portal/bolsas-de-pesquisa"
        self.csv_name = "bolsas_ipea.csv"

    def scrape(self) -> Dict:
        print("(Scraper) Iniciando raspagem das bolsas IPEA...")

        all_items = []

        for start in range(0, 40, 10):  # Vai de 0 até 30 (inclusive), pulando de 10 em 10
            page_url = self.url if start == 0 else f"{self.url}?start={start}"
            print(f"\n(Scraper) Raspando página com URL: {page_url}")

            response = self._fetch_page(page_url)
            if not response:
                continue  # Pula para a próxima página se der erro

            lista_chamadas = self._parse_html(response.text)
            if not lista_chamadas:
                continue

            chamadas = lista_chamadas.find_all("li")
            for i, chamada in enumerate(chamadas):
                print(f"(Scraper) Processando item {len(all_items)+1}")
                item_data = self._extract_item_data(chamada)
                all_items.append(item_data)

        df = pd.DataFrame(all_items)
        df = df[["titulo", "descricao", "inscricoes", "link", "situacao"]]
        df.to_csv(self.csv_name, index=False, encoding="utf-8-sig")
        print(f"\n(Scraper) {len(all_items)} itens salvos em '{self.csv_name}'")

        return self._format_response(all_items, "success")

        

    def _fetch_page(self, page_url):
        try:
            print(f"(Scraper) Fazendo requisição para: {page_url}")
            response = requests.get(page_url)
            response.encoding = 'utf-8'
            print(f"(Scraper) Resposta recebida! Status: {response.status_code}")
            return response
        except requests.exceptions.RequestException as e:
            print(f"(Scraper) Erro na requisição: {e}")
            return None


    def _parse_html(self, html_content: str):
        try:
            soup = BeautifulSoup(html_content, "html.parser")
            lista_chamadas = soup.find("ul", class_="search-resultsbolsas")
            
            if not lista_chamadas:
                print("(Scraper) Lista de chamadas não encontrada na página.")
                return None
            
            print(f"(Scraper) Lista encontrada! Processando dados...")
            return lista_chamadas
        except Exception as e:
            print(f"(Scraper) Erro no parsing HTML: {e}")
            return None


    def _format_response(self, items: List[Dict], status: str = "success") -> Dict:
        formatted_items = []
        for i, item in enumerate(items, 1):
            formatted_items.append({
                "id": i,
                "title": item["titulo"],
                "situacao": item["situacao"],
                "descricao": item.get("descricao", ""),   # Corrigido aqui
                "inscricoes": item.get("inscricoes", ""), # Também para manter padronizado
                "link": item["link"]
            })
        
        return {
            "items": formatted_items,
            "timestamp": datetime.datetime.now().isoformat(),
            "status": status,
            "total_items": len(formatted_items)
        }



    def _extract_item_data(self, chamada) -> Dict[str, str]:
        h4 = chamada.find("h4", class_="result-title")
        a_tag = h4.find("a") if h4 else None
        titulo_completo = a_tag.get_text(strip=True) if a_tag else ""
        link = self.base_url + a_tag["href"] if a_tag and "href" in a_tag.attrs else ""

        # titulo
        match = re.search(r"Chamada Pública nº? ?\d+/\d{4}", titulo_completo)
        titulo = match.group(0) if match else titulo_completo
        # descricao
        descricao = ""
        p_objetivo = chamada.find("p", class_="objetivo")
        if p_objetivo:
            texto_objetivo = p_objetivo.get_text(strip=True)
            projeto_match = re.search(r'Projeto:\s*[“"]?(.*?)[”"]?\.?$', texto_objetivo)
            if projeto_match:
                descricao = projeto_match.group(1).strip().strip('“”"')

        # Situacao, programa e Pprazo de inscricao
        p_tags = chamada.find_all("p")
        situacao = ""
        prazo_inscricao = ""

        for p in p_tags:
            strong = p.find("strong")
            if strong:
                label = strong.get_text(strip=True).replace(":", "").lower()
                texto = p.get_text(strip=True).replace(strong.get_text(), "").strip()

                if label == "situação":
                    situacao = texto
                elif "prazo de inscrição" in label:
                    prazo_inscricao = texto.replace("Prazo de inscrição:", "").strip()

        return {
            "titulo": titulo,
            "descricao": descricao,
            "inscricoes": prazo_inscricao,
            "link": link,
            "situacao": situacao
        }

