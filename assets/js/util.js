// Generated by CoffeeScript 1.4.0
var getParams;

getParams = function() {
  var params, prmarr, prmstr;
  prmstr = window.location.search.substr(1);
  prmarr = prmstr.split("&");
  params = {};
  _.each(prmarr, function(elt) {
    var tmparr;
    tmparr = elt.split("=");
    return params[tmparr[0]] = tmparr[1];
  });
  return params;
};