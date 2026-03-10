from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route('/')
def home():
    version = os.environ.get('APP_VERSION', '1.0.0')
    environment = os.environ.get('APP_ENV', 'development')
    
    return jsonify({
        "message": "Welcome to the GitOps Demo App By Ajay Bhai! - Version 1.0.1 🚀",
        "version": version,
        "environment": environment,
        "status": "Healthy"
    })

@app.route('/health')
def health_check():
    return jsonify({"status": "Healthy"}), 200

if __name__ == '__main__':
    # Binding to 0.0.0.0 allows external connections when running in a Docker container
    port = int(os.environ.get('PORT', 8080))
    app.run(host='0.0.0.0', port=port)
