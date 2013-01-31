
/*
 * GET doc listing.
 */

exports.single = function(req, res){
  res.render('doc', { title: "doc #" + req.query["id"], id: req.query["id"] });
};

exports.list = function(req, res){
  res.render('docs', { title: "doc list" });
};
