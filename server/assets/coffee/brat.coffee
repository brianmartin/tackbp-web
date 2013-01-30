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


collData = {
    entity_types: [ {
            type   : 'Person',
            labels : ['Person', 'Per'],
            # Blue is a nice colour for a person?
            bgColor: "#7fa2ff",
            # Use a slightly darker version of the bgColor for the border
            borderColor: 'darken'
    } ]
}

docData = {
    # Our text of choice
    text     : "Ed O'Kelley was the man who shot the man who shot Jesse James.",
    # The entities entry holds all entity annotations
    entities : [
        ['T1', 'Person', [[0, 11]]],
        ['T2', 'Person', [[20, 23]]],
        ['T3', 'Person', [[37, 40]]],
        ['T4', 'Person', [[50, 61]]],
    ],
}

head.ready(() ->
    Util.embed(
        # id of the div element where brat should embed the visualisations
        'pos-div',
        # object containing collection data
        collData,
        # object containing document data
        docData,
        # Array containing locations of the visualisation fonts
        webFontURLs
    )
)
