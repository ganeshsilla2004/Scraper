from flask import Flask, jsonify
import json
import os

app = Flask(__name__)

@app.route('/')
def index():
    try:
 
        with open('/app/scraped_data.json', 'r') as file:
            data = json.load(file)
        return jsonify(data)
    except Exception as e:
        return jsonify({
            'error': str(e),
            'message': 'Error reading scraped data'
        }), 500

@app.route('/health')
def health():
    return jsonify({'status': 'healthy'})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)