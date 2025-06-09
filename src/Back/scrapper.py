import json
import flask
import flask_cors
import pandas as pd

from IPEABolsasScraper import IPEABolsasScraper
from CNPQBolsasScraper import CNPQBolsasScraper


app = flask.Flask(__name__)
flask_cors.CORS(app)


def scrape_all():
    scraper_ipea = IPEABolsasScraper()
    scraper_cnpq = CNPQBolsasScraper()

    # Rodar os scrapers
    resultado_ipea = scraper_ipea.scrape()
    resultado_cnpq = scraper_cnpq.scrape()

    # Extrair listas de itens (garantindo que não sejam None)
    itens_ipea = resultado_ipea.get("items", []) if resultado_ipea else []
    itens_cnpq = resultado_cnpq.get("items", []) if resultado_cnpq else []

    # Combinar os dados
    todos_itens = itens_ipea + itens_cnpq

    # Ajustar IDs sequenciais (opcional)
    for idx, item in enumerate(todos_itens, 1):
        item["id"] = idx

    # Salvar CSV combinado
    df = pd.DataFrame(todos_itens)

    # Forçar ordem das colunas, caso falte alguma
    colunas = ["id", "title", "descricao", "inscricoes", "link", "situacao"]
    for col in colunas:
        if col not in df.columns:
            df[col] = ""

    df = df[colunas]

    csv_filename = "bolsas_combinadas.csv"
    df.to_csv(csv_filename, index=False, encoding="utf-8-sig")
    print(f"(Scrapper) {len(todos_itens)} bolsas salvas em '{csv_filename}'")

    # Retornar a resposta JSON padrão, com o resultado combinado
    return {
        "items": todos_itens,
        "timestamp": pd.Timestamp.now().isoformat(),
        "status": "success" if todos_itens else "empty",
        "total_items": len(todos_itens)
    }


@app.route('/api/scrape', methods=['GET'])
def get_scrapped_data():
    try:
        resultado = scrape_all()
        return flask.jsonify(resultado), 200
    except Exception as e:
        return flask.jsonify({
            "status": "error",
            "message": str(e)
        }), 500


@app.route('/api/health', methods=['GET'])
def health_check():
    return flask.jsonify({"status": "healthy"}), 200


if __name__ == '__main__':
    PORT = "8080"  # MacOs já ocupa a porta padrão do Flask (5000)
    app.run(debug=True, host='0.0.0.0', port=PORT)
