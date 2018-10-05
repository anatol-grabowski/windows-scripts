var fs = require('fs');

var walk = function(dir) {
  var results = [];
  var list = fs.readdirSync(dir);
	
	for (var i = 0; i < list.length; i++) {
		var file = list[i];
		file = dir + '/' + file;
		results.push(file);
		var stat = fs.statSync(file);
		if (stat && stat.isDirectory()) {
			var res = walk(file);
			results = results.concat(res);
		}
	}
	return results
};

var dir = "d:/Грабовский/_5_Portable/_1_BASIC_APPS/_SCRIPTS/nodejs";
var results = walk(dir);
console.log(results);
setTimeout(function() {}, 1000000);