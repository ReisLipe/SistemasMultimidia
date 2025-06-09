import requests
import datetime
import pandas as pd

from bs4 import BeautifulSoup
from typing import Dict, List


class CNPQBolsasScraper:
    """Scraper para coletar chamadas públicas abertas do site do CNPq"""

    def __init__(self):
        self.base_url = "http://memoria2.cnpq.br"
        self.url = self.base_url + "/web/guest/chamadas-publicas?p_p_id=resultadosportlet_WAR_resultadoscnpqportlet_INSTANCE_0ZaM&filtro=abertas"
        self.csv_name = "chamadas_cnpq.csv"

    def scrape(self) -> Dict:
        print("(CNPQ Scraper) Iniciando raspagem de chamadas abertas do CNPq...")

        response = self._fetch_page()
        if not response:
            return self._format_response([], "error")

        soup = BeautifulSoup(response.text, "html.parser")
        chamadas_html = soup.select("ol.list-chamadas > li")
        if not chamadas_html:
            print("(CNPQ Scraper) Nenhuma chamada encontrada.")
            return self._format_response([], "error")

        all_items = []
        for i, chamada in enumerate(chamadas_html):
            print(f"(CNPQ Scraper) Processando chamada {i+1} de {len(chamadas_html)}")
            item_data = self._extract_item_data(chamada)
            all_items.append(item_data)

        df = pd.DataFrame(all_items)
        df = df[["titulo", "descricao", "inscricoes", "link", "situacao"]]
        df.to_csv(self.csv_name, index=False, encoding="utf-8-sig")
        print(f"(CNPQ Scraper) {len(all_items)} chamadas salvas em '{self.csv_name}'")

        return self._format_response(all_items, "success")

    def _fetch_page(self):
        try:
            print(f"(CNPQ Scraper) Requisitando página: {self.url}")
            response = requests.get(self.url)
            response.encoding = 'utf-8'
            print(f"(CNPQ Scraper) Página carregada. Status: {response.status_code}")
            return response
        except requests.exceptions.RequestException as e:
            print(f"(CNPQ Scraper) Erro na requisição: {e}")
            return None

    def _extract_item_data(self, chamada) -> Dict[str, str]:
        # Título
        h4 = chamada.find("h4")
        titulo = h4.get_text(strip=True) if h4 else ""

        # Descrição
        p = chamada.find("p")
        descricao = p.get_text(strip=True) if p else ""

        # Período de inscrições
        inscricao = chamada.select_one("div.inscricao ul.datas li")
        periodo_inscricao = inscricao.get_text(strip=True) if inscricao else ""

        # Link da chamada
        link_tag = chamada.select_one("div.links-normas a.btn")
        link = link_tag["href"] if link_tag and "href" in link_tag.attrs else ""

        situacao = "abertas"  # fixo

        return {
            "titulo": titulo,
            "descricao": descricao,
            "inscricoes": periodo_inscricao,
            "link": link,
            "situacao": situacao
        }


    def _format_response(self, items: List[Dict], status: str = "success") -> Dict:
        formatted_items = []
        for i, item in enumerate(items, 1):
            formatted_items.append({
                "id": i,
                "title": item["titulo"],
                "descricao": item["descricao"],
                "inscricoes": item["inscricoes"],
                "link": item["link"]
            })

        return {
            "items": formatted_items,
            "timestamp": datetime.datetime.now().isoformat(),
            "status": status,
            "total_items": len(formatted_items)
        }
