global_doc = []
global_doc_mentions = []

# MONGOOSE = "http://blake.cs.umass.edu:27080"
MONGOOSE = "http://localhost:27080"

mongoQuery = (query, _success, _error) ->
    q = encodeURI(JSON.stringify(query))
    $.ajax MONGOOSE+"/DEFT/docs/_find?criteria="+q,
        type: 'GET'
        dataType: 'jsonp'
        error: _error
        success: _success

getMongoDoc = (id, _success) ->
    mongoQuery(
        {"_id": {"$oid" : id} },
        ((data, textStatus, jqXHR) ->
            global_doc = data.results[0]
            _success(data.results[0])
        ),
        ((jqXHR, textStatus, errorThrown) ->
            console.log "AJAX Error: #{textStatus}"
            $("body").append('<h2><font color="red"> Could not find that document in the database. </font></h2>')
        ))

getMongoDocMentions = (id, _success) ->
    q = encodeURI(JSON.stringify({"doc": {"$oid": id}}))
    $.ajax MONGOOSE+"/DEFT/docMentions/_find?criteria="+q,
        type: 'GET'
        dataType: 'jsonp'
        error: (jqXHR, textStatus, errorThrown) ->
            console.log "AJAX Error: #{textStatus}"
            $("body").append('<h2><font color="red"> Failed to find document mentions. </font></h2>')
        success: _success

getMongoDocAndMentions = (id, _success) ->
    getMongoDoc(id, () ->
        getMongoDocMentions(id, (data) ->
            global_doc_mentions = data.results
            console.log("mentions:")
            console.log(global_doc_mentions)
            _success(global_doc, global_doc_mentions)
        )
    )

getMongoDocList = (_success) ->
    q = encodeURI(JSON.stringify(["name"]))
    $.ajax MONGOOSE+"/DEFT/docs/_find?fields="+q,
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

renderDoc = (doc, getData) ->
    console.log ("RENDER: ")
    # console.log(JSON.stringify(doc))
    head.ready(() ->
        Util.embed(
            # id of the div element where brat should embed the visualisations
            'pos-div',
            # object containing collection data
            collData,
            # object containing document data
            getData(doc),
            # Array containing locations of the visualisation fonts
            webFontURLs
        )
    )

renderDocAndMentions = (doc, mentions, getData) ->
    console.log('Doc:')
    console.log(JSON.stringify(doc))
    console.log("Mentions:")
    console.log(JSON.stringify(mentions))
    head.ready(() ->
        Util.embed(
            # id of the div element where brat should embed the visualisations
            'pos-div',
            # object containing collection data
            collData,
            # object containing document data
            getData(doc, mentions),
            # Array containing locations of the visualisation fonts
            webFontURLs
        )
    )
