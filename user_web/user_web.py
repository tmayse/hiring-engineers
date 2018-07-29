### user_web
import os, datetime, logging, sys
from pythonjsonlogger import jsonlogger

from flask import Flask, send_file
app = Flask(__name__)

logger = logging.getLogger()
logHandler = logging.StreamHandler()
formatter = jsonlogger.JsonFormatter()
logHandler.setFormatter(formatter)
logger.addHandler(logHandler)

options = {'api_key': os.environ['DD_API_KEY'],
            'app_key': os.environ['DD_APP_KEY']}

tracer.configure(hostname="dub_dub_dub")
traced_app = TraceMiddleware(app, tracer, service="user_web", distributed_tracing=True)


@app.route("/")
def main():
    index_path = os.path.join(app.static_folder, 'index.html')
    return send_file(index_path)


# Everything not declared before (not a Flask route / API endpoint)...
@app.route('/<path:path>')
def route_frontend(path):
    # ...could be a static file needed by the front end that
    # doesn't use the `static` path (like in `<script src="bundle.js">`)
    file_path = os.path.join(app.static_folder, path)
    if os.path.isfile(file_path):
        return send_file(file_path)
    # ...or should be handled by the SPA's "router" in front end
    else:
        index_path = os.path.join(app.static_folder, 'index.html')
        return send_file(index_path)

@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def not_found(path):
    #302 = keep trying
    return redirect("https://docs.datadoghq.com/integrations/postgres/", code=302)

if __name__ == "__main__":
    # Only for debugging while developing
    app.run(host='0.0.0.0', debug=True, port=8080
)
