global_doc = []

mongoQuery = (query, _success, _error) ->
    q = encodeURI(JSON.stringify(query))
    $.ajax "http://localhost:27080/DEFT/docs/_find?criteria="+q,
        type: 'GET'
        dataType: 'jsonp'
        error: _error
        success: _success

getMongoDoc = (id) ->
    mongoQuery(
        {"_id": {"$oid" : id} },
        ((data, textStatus, jqXHR) ->
            console.log(data)
            global_doc = data.results[0]
            renderDoc(data.results[0])
        ),
        ((jqXHR, textStatus, errorThrown) ->
            console.log "AJAX Error: #{textStatus}"
            $("body").append('<h2><font color="red"> Could not find that document in the database. </font></h2>')
        ))

getMongoDocList = (_success) ->
    q = encodeURI(JSON.stringify(["name"]))
    $.ajax "http://localhost:27080/DEFT/docs/_find?fields="+q,
        type: 'GET'
        dataType: 'jsonp'
        error: (jqXHR, textStatus, errorThrown) ->
            console.log "AJAX Error: #{textStatus}"
            $("body").append('<h2><font color="red"> Could not connect to the database. </font></h2>')
        success: _success

getDocData = (doc) -> {
    text: (
        doc.text
    ),
    entities: (
        _.zip(
          # index with 'T'
          _.map(_.range(doc.tstarts.length), (elt) -> "T" + elt)
          # tag
          doc.tpos,
          _.map(
              _.zip(
                  # start offsets
                  doc.tstarts,
                  # end offsets
                  _.map(_.zip(doc.tstarts, doc.tlengths), (elt) -> elt[0] + elt[1])
              )
              (elt) -> [elt]
          )
        )
    )
}

collData = {
    entity_types: [ {
            type   : 'Person',
            labels : ['Person', 'Per'],
            # Blue is a nice colour for a person?
            bgColor: "#7fa2ff",
            # Use a slightly darker version of the bgColor for the border
            borderColor: 'darken'
    } ],
}

renderDoc = (doc) ->
    # console.log(JSON.stringify(doc))
    head.ready(() ->
        Util.embed(
            # id of the div element where brat should embed the visualisations
            'pos-div',
            # object containing collection data
            collData,
            # object containing document data
            getDocData(doc),
            # Array containing locations of the visualisation fonts
            webFontURLs
        )
    )
