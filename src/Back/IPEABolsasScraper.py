import requests
import datetime
import pandas as pd

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
        
        # Realiza o fetch da página
        response = self._fetch_page()
        if not response:
            return self._format_response([], "error")

        # Parse do HTML
        lista_chamadas = self._parse_html(response.text)
        if not lista_chamadas:
            return self._format_response([], "error")

        # Extrai os itens do HTML
        chamadas = lista_chamadas.find_all("li")
        all_items = []
        for i, chamada in enumerate(chamadas):
            print(f"(Scraper) Processando item {i+1} de {len(chamadas)}")
            item_data = self._extract_item_data(chamada)
            all_items.append(item_data)
        
        # Salva os itens no CSV
        df = pd.DataFrame(all_items)
        df.to_csv(self.csv_name, index=False, encoding="utf-8-sig")
        print(f"(Scraper) {len(all_items)} itens salvos em '{self.csv_name}'")

        # Transforma a lista em uma lista de dicionários
        result = self._format_response(all_items, "success")
        return result

        

    def _fetch_page(self):
        try:
            print(f"(Scraper) Fazendo requisição para: {self.url}")
            response = requests.get(self.url)
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
        """Formata a resposta no padrão solicitado"""

        formatted_items = []
        for i, item in enumerate(items, 1):
            formatted_items.append({
                "id": i,
                "title": item["titulo"],
                "situacao": item["situacao"],
                "programa": item["programa"],
                "link": item["link"]
            })
        
        return {
            "items": formatted_items,
            "timestamp": datetime.datetime.now().isoformat(),
            "status": status,
            "total_items": len(formatted_items)
        }


    def _extract_item_data(self, chamada) -> Dict[str, str]:
        """Extrai dados de um item específico"""
        # Título e link
        h4 = chamada.find("h4", class_="result-title")
        a_tag = h4.find("a") if h4 else None
        titulo = a_tag.get_text(strip=True) if a_tag else ""
        link = self.base_url + a_tag["href"] if a_tag and "href" in a_tag.attrs else ""
        
        # Situação e Programa
        p_tags = chamada.find_all("p")
        situacao = ""
        programa = ""
        
        for p in p_tags:
            strong = p.find("strong")
            if strong:
                label = strong.get_text(strip=True).replace(":", "")
                texto = p.get_text(strip=True).replace(strong.get_text(), "").strip()
                
                if label == "Situacao":
                    situacao = texto
                elif label == "Programa":
                    programa = texto
        
        return {
            "titulo": titulo,
            "situacao": situacao,
            "programa": programa,
            "link": link
        }