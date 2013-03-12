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
            type   : 'Mention',
            labels : ['Ment', 'M'],
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
    text: doc.text.replace(/(\r\n|\n|\r)/gm," ")
    entities: (
        _.zip(
          _.map(_.range(doc.tstarts.length), (elt) -> "T" + elt)
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

getDocMentionData = (doc, mentions) ->
    mstarts_tok  = _.map(mentions, (elt) -> elt.start)
    mlengths_tok = _.map(mentions, (elt) -> elt.length)
    mends_tok    = _.map(_.zip(mstarts_tok, mlengths_tok), (elt) -> elt[0] + elt[1] - 1)

    mstarts_char  = _.map(mstarts_tok, (elt) -> doc.tstarts[elt])
    mends_char    = _.map(mends_tok, (elt) -> doc.tstarts[elt] + doc.tlengths[elt])

    {
        text: doc.text.replace(/(\r\n|\n|\r)/gm," ")
        entities:
            _.zip(
              _.map(_.range(mentions.length), (elt) -> "T" + elt)
              # tag
              _.map(mentions, (elt) -> "M-" + elt.docEntity),
              _.map(
                  _.zip(
                      mstarts_char,
                      mends_char
                  )
                  (elt) -> [elt]
              )
            )
    }
