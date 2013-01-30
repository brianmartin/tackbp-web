
/*
 * GET doc listing.
 */

exports.list = function(req, res){
  res.render('doc', { title: "doc #" + req.query["id"], id: req.query["id"] });
};
