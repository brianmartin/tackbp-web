// Generated by CoffeeScript 1.4.0
var MONGOOSE, collData, getDocData, getMongoDoc, getMongoDocAndMentions, getMongoDocList, getMongoDocMentions, global_doc, global_doc_mentions, mongoQuery, renderDoc, renderDocAndMentions;

global_doc = [];

global_doc_mentions = [];

MONGOOSE = "http://localhost:27080";

mongoQuery = function(query, _success, _error) {
  var q;
  q = encodeURI(JSON.stringify(query));
  return $.ajax(MONGOOSE + "/DEFT/docs/_find?batch_size=10000&criteria=" + q, {
    type: 'GET',
    dataType: 'jsonp',
    error: _error,
    success: _success
  });
};

getMongoDoc = function(id, _success) {
  return mongoQuery({
    "_id": {
      "$oid": id
    }
  }, (function(data, textStatus, jqXHR) {
    global_doc = data.results[0];
    return _success(data.results[0]);
  }), (function(jqXHR, textStatus, errorThrown) {
    console.log("AJAX Error: " + textStatus);
    return $("body").append('<h2><font color="red"> Could not find that document in the database. </font></h2>');
  }));
};

getMongoDocMentions = function(id, _success) {
  var q;
  q = encodeURI(JSON.stringify({
    "doc": {
      "$oid": id
    }
  }));
  return $.ajax(MONGOOSE + "/DEFT/docMentions/_find?batch_size=10000&criteria=" + q, {
    type: 'GET',
    dataType: 'jsonp',
    error: function(jqXHR, textStatus, errorThrown) {
      console.log("AJAX Error: " + textStatus);
      return $("body").append('<h2><font color="red"> Failed to find document mentions. </font></h2>');
    },
    success: _success
  });
};

getMongoDocAndMentions = function(id, _success) {
  return getMongoDoc(id, function() {
    return getMongoDocMentions(id, function(data) {
      global_doc_mentions = data.results;
      console.log("mentions:");
      console.log(global_doc_mentions);
      return _success(global_doc, global_doc_mentions);
    });
  });
};

getMongoDocList = function(_success) {
  var q;
  q = encodeURI(JSON.stringify(["name"]));
  return $.ajax(MONGOOSE + "/DEFT/docs/_find?fields=" + q, {
    type: 'GET',
    dataType: 'jsonp',
    error: function(jqXHR, textStatus, errorThrown) {
      console.log("AJAX Error: " + textStatus);
      return $("body").append('<h2><font color="red"> Could not connect to the database. </font></h2>');
    },
    success: _success
  });
};

getDocData = function(doc) {
  return {
    text: doc.text,
    entities: _.zip(_.map(_.range(doc.tstarts.length), function(elt) {
      return "T" + elt;
    }), doc.tpos, _.map(_.zip(doc.tstarts, _.map(_.zip(doc.tstarts, doc.tlengths), function(elt) {
      return elt[0] + elt[1];
    })), function(elt) {
      return [elt];
    }))
  };
};

collData = {
  entity_types: [
    {
      type: 'Person',
      labels: ['Person', 'Per'],
      bgColor: "#7fa2ff",
      borderColor: 'darken'
    }
  ]
};

renderDoc = function(doc, getData) {
  console.log("RENDER: ");
  return head.ready(function() {
    return Util.embed('pos-div', collData, getData(doc), webFontURLs);
  });
};

renderDocAndMentions = function(doc, mentions, getData) {
  console.log('Doc:');
  console.log(JSON.stringify(doc));
  console.log("Mentions:");
  console.log(JSON.stringify(mentions));
  return head.ready(function() {
    return Util.embed('pos-div', collData, getData(doc, mentions), webFontURLs);
  });
};
