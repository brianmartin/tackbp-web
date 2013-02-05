bratLocation = '/assets/brat'

head.js(
    # External libraries
    bratLocation + '/client/lib/jquery.min.js',
    bratLocation + '/client/lib/jquery.svg.min.js',
    bratLocation + '/client/lib/jquery.svgdom.min.js',

    # brat helper modules
    bratLocation + '/client/src/configuration.js',
    bratLocation + '/client/src/util.js',
    bratLocation + '/client/src/annotation_log.js',
    bratLocation + '/client/lib/webfont.js',

    # brat modules
    bratLocation + '/client/src/dispatcher.js',
    bratLocation + '/client/src/url_monitor.js',
    bratLocation + '/client/src/visualizer.js'
)

webFontURLs = [
    bratLocation + '/static/fonts/Astloch-Bold.ttf',
    bratLocation + '/static/fonts/PT_Sans-Caption-Web-Regular.ttf',
    bratLocation + '/static/fonts/Liberation_Sans-Regular.ttf'
]


# this doesnt seem to be working
collData = {
    entity_types: [ {
            type   : 'POS',
            labels : ['NNP'],
            # Blue is a nice colour for a person?
            bgColor: "#7fa2ff",
            # Use a slightly darker version of the bgColor for the border
            borderColor: 'darken'
    } ]
}

# Example doc data
#
# docData = {
#     # Our text of choice
#     text     : "Ed O'Kelley was the man who shot the man who shot Jesse James.",
#     # The entities entry holds all entity annotations
#     entities : [
#         ['T1', 'Person', [[0, 11]]],
#         ['T2', 'Person', [[20, 23]]],
#         ['T3', 'Person', [[37, 40]]],
#         ['T4', 'Person', [[50, 61]]],
#     ],
#  }

getDocData = (doc) -> {
    text: doc.text
    entities:
        _.zip(
          _.map(_.range(doc.tstarts.length), (elt) -> "T" + elt)
          doc.tpos,
          _.map(
              _.zip(
                  # start offsets
                  doc.sstarts,
                  # end offsets
                  _.map(_.zip(doc.sstarts, doc.slengths), (elt) -> elt[0] + elt[1])
              )
              (elt) -> [elt]
          )
        )
}

getDocMentionData = (doc, mentions) ->
    console.log("GET DOC MENTIONS DATA: ")
    console.log("---------------------- ")
    console.log(mentions)
    s = {
        text: doc.text
        entities:
            _.zip(
              # index with 'T'
              _.map(_.range(doc.tstarts.length), (elt) -> "T" + elt)
              # tag
              doc.tpos,
              _.map(
                  _.zip(
                      # start offsets
                      doc.sstarts,
                      # end offsets
                      _.map(_.zip(doc.sstarts, doc.slengths), (elt) -> elt[0] + elt[1])
                  )
                  (elt) -> [elt]
              )
            )
    }
    console.log("get doc: ")
    console.log(getDocData(doc))
    console.log("get doc mentions: ")
    console.log(JSON.stringify(s))
    s
