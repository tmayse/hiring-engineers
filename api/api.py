import os, sys
import traceback
import random
import time
import json
import pprint
import psycopg2
import logging
import json_logging

from datadog import initialize, api
from flask import Flask, send_file, redirect
from ddtrace import tracer, patch
from ddtrace.contrib.flask import TraceMiddleware

POSTGRES_PASSWORD = os.environ['POSTGRES_PASSWORD']

patch(requests=True)
import requests

options = {'api_key': os.environ['DD_API_KEY']}

initialize(**options)

app = Flask(__name__)
json_logging.ENABLE_JSON_LOGGING = True
json_logging.init(framework_name='flask')
json_logging.init_request_instrument(app)

logger = logging.getLogger("ddtrace.writer")
logger.setLevel(logging.DEBUG)
logger.addHandler(logging.StreamHandler(sys.stdout))

tracer.configure(hostname="good_vs_evil")
traced_app = TraceMiddleware(app, tracer, service="api", distributed_tracing=True)

@app.route(u'/ce')
def cause_exception():
    assert(1==3)
    return

@app.route(u'/tfs')
def trace_full_stack():
    try:
        connect_str = "dbname='DDHEE' " + \
                        "user='ddhee' host='127.0.0.1' " + \
                        "password='{}'".format(POSTGRES_PASSWORD)
        # use our connection values to establish a connection
        conn = psycopg2.connect(connect_str)
        # create a psycopg2 cursor that can execute queries
        cursor = conn.cursor()
        # create a new table with a single column called "name"
        cursor.execute("""CREATE TABLE tutorials (name char(40));""")
        # run a SELECT statement - no data in there, but we can try it
        for i in range(99):
            cursor.execute("""SELECT * from tutorials""")
            rows = cursor.fetchall()
        return json.dumps(rows)
    except Exception as e:
        print("Uh oh, can't connect. Invalid dbname, user or password?")
        print(e)

@app.route(u'/ks')
def kill_server():
    quit()
    return 'aborted'

@app.route(u'/pc')
def post_comment():
    choice = random.randint(0,4)
    choices = ['Datadog should use Clojure!',
                'Functional programming is special.',
                'Garbage in: garbage out',
                'Datadog is the leader of the pack.',
                'PyTorch makes machine learning fun!!!']
    api.Comment.create(
        handle ='iamtonymayse@gmail.com',
        message = choices[choice]
    )
    return choices[choice]

@app.route(u'/event')
def post_event():
    title = "Something big happened!"
    text = 'Check this nifty demo!'
    tags = ['version:2', 'eehdd:post_event', 'application:web']
    api.Event.create(title=title, text=text, tags=tags)
    return 'Event Created'

@app.route(u'/pt')
def post_trace():
    # Create IDs.
    TRACE_ID = random.getrandbits(64)
    SPAN_ID = random.getrandbits(64)
    START = int(time.time() * 1e9) #ns
    DURATION = 2.5e+10 #2.5e+10 nanoseconds = 25 seconds
    spans = []
    trace =[spans]
    parent_span = {
            u'trace_id': TRACE_ID,
            u'span_id': SPAN_ID,
            u'name': u'app level',
            u'resource': u'/pt',
            u'service': u'api',
            u'type': u'web',
            u'start': int(START),
            u'duration': int(DURATION)
    }
    spans.append(parent_span)
    trace.append(spans)

    add_to_span(parent_span, spans) #this is the meat

    # Send the traces.
    headers = {"Content-Type": "application/json"}
    requests.put("http://dd-agent:8126/v0.3/traces", data=json.dumps(trace), headers=headers)

    return json.dumps(trace)

# Everything not declared before (not an API endpoint)...
@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def not_found(path):
    #302 = keep trying
    return redirect("https://docs.datadoghq.com/integrations/postgres/", code=302)

def add_to_span(span, spans):
    pp = pprint.PrettyPrinter(indent=4)
    pp.pprint(span)
    pp.pprint(spans)
    max_time = span[u'duration']
    start_delay = int(random.triangular(0.0, max_time, max_time / 3))
    start_time = int(span[u'start'] + start_delay)
    max_time -= start_delay
    SPAN_ID = random.randint(1,1000000)

    choice = random.randint(1,10)
    if (choice < 3 or max_time < 900000000.0): #stop adding spans < 0.9s left
        spans.append(span)
    else:
        new_span = {
            u'trace_id': span[u'trace_id'],
            u'span_id': SPAN_ID,
            u'parent_id': span[u'span_id'],
            u'name': u'app level',
            u'resource': u'/pt',
            u'service': u'api',
            u'type': u'web',
            u'start': start_time,
            u'duration': int(max_time)
        }
        add_to_span(new_span, spans)

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True, port=8080)
