
renderDoc = (doc) ->
    console.log(doc)

getMongoDoc = (name) ->
    console.log('name: ' + name)
    q = encodeURI(JSON.stringify({"name": name}))
    $.ajax "http://localhost:27080/DEFT/docs/_find?criteria="+q,
        type: 'GET'
        async: false
        dataType: 'jsonp'
        error: (jqXHR, textStatus, errorThrown) ->
            console.log "AJAX Error: #{textStatus}"
        success: (data, textStatus, jqXHR) ->
            console.log(data)
            renderDoc(data.results[0])

renderDocDivs = () ->
    # TODO: fix retrieving name from document template
    # name = $('p').text()
    name = "data/tac-nyt-sample/NYT_ENG_20070201.0063.LDC2009T13.sgm"
    console.log('render name: ' + name)
    getMongoDoc(name)

$(document).ready(renderDocDivs())
