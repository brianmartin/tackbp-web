
getParams = () ->
    prmstr = window.location.search.substr(1)
    prmarr = prmstr.split ("&")
    params = {}

    _.each(prmarr, (elt) ->
        tmparr = elt.split("=")
        params[tmparr[0]] = tmparr[1]
    )

    return params

