import json
import flask
import flask_cors

from IPEABolsasScraper import IPEABolsasScraper


app = flask.Flask(__name__)
flask_cors.CORS(app)


def scrape_data():
    scraper = IPEABolsasScraper()
    data = scraper.scrape()
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


if __name__ == '__main__':
    PORT = "8080" # MacOs já ocupa a porta padrão do Flask (5000)
    app.run(debug=True, host='0.0.0.0', port=PORT)

    
   