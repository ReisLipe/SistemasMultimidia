import json
import flask
import flask_cors
import datetime


app = flask.Flask(__name__)
flask_cors.CORS(app)


def scrape_data():
    # TODO: Código de Scrapping
    
    data = {
        "items": [
            {"id": 1, "title": "UPE", "valor": "R$ 450"},
            {"id": 2, "title": "UFPE", "valor": "R$ 1200"},
            {"id": 3, "title": "UFRPE", "valor": "R$ 800"}
        ],
        "timestamp": datetime.datetime.now().isoformat(),
        "status": "success"
    }

    return data


@app.route('/api/scrape', methods=['GET'])
def get_scrapped_data():
    try:
        resultado = scrape_data()
        return flask.jsonify(resultado), 200
    except Exception as e:
        return flask.jsonify({
            "status": "error",
            "message": str(e)
        }), 500


@app.route('/api/health', methods=['GET'])
def health_check():
    return flask.jsonify({"status": "healthy"}), 200

        

# def main():
#     resultado = scrape_data()
#     print(json.dumps(resultado, indent=2, ensure_ascii=False))

if __name__ == '__main__':
    PORT = "8080" # MacOs já ocupa a porta padrão do Flask (5000)
    app.run(debug=True, host='0.0.0.0', port=PORT)

    
   