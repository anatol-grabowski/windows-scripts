var fs = require("fs");
var path = require("path");
var util = require('util');

//=======================================================================
FileRecord = function(file) {
	this.name = "";
	this.size = 0;
	this.created = 0;
	this.modified = 0;
	
	this.fromFile = function(file) {
		var stats = fs.statSync(file);
		this.name = file;
		this.size = stats.isFile() ? stats.size : Number.NaN;
		this.created = stats.birthtime;
		this.modified = stats.ctime;
	}
	
	if (file) this.fromFile(file);
}


FilesStructure = function(files) {
	this.fileRecords = Array();
	this.lastScanned = Date();
	
	this.scan = function(files) {
		for(var i=0; i<files.length; i++) {
			var fr = new FileRecord(files[i]);
			this.fileRecords.push(fr);
		}
		this.lastScanned = Date();
	}
	
	if(files) {
		this.scan(files);
	}	
}


ComparisonResult = function(oldStruct, newStruct) {
	this.addedRecords = Array();
	this.removedRecords = Array();
	
	findRecord = function(record, records) {
		for (var i = 0; i < records.length; i++) {
			if (record.name == records[i].name) {
				return records[i];
			}
		}
	} 
	
	for (var i = 0; i < newStruct.fileRecords.length; i++) {
		var fr = newStruct.fileRecords[i];
		if ( !findRecord(fr, oldStruct.fileRecords) )
			this.addedRecords.push(fr.name);
	}
	
	for (var i = 0; i < oldStruct.fileRecords.length; i++) {
		var fr = oldStruct.fileRecords[i];
		if ( !findRecord(fr, newStruct.fileRecords) )
			this.removedRecords.push(fr.name);
	}
}


var walk = function(dir, log) {
  var results = [];
  var list = fs.readdirSync(dir);
	
	for (var i = 0; i < list.length; i++) {
		var file = list[i];
		file = dir + '/' + file;
		file = path.resolve(file);
		results.push(file);
		if (log) log.write("\r " + ++filesCounter);
		var stat = fs.statSync(file);
		if (stat && stat.isDirectory()) {
			var res = walk(file, log);
			results = results.concat(res);
		}
	}
	return results
};

//=====================================================================
//=====================================================================


var scanPath = "\\\\172.20.131.12\\For Exchange\\!!!OOK\\";
var scanPath = "d:/Грабовский/_5_Portable/_1_BASIC_APPS/_SCRIPTS/nodejs/../..";
//var scanPath = "d:/Грабовский/_5_Portable/_1_BASIC_APPS/_SCRIPTS/nodejs";

var dbPath = "d:/Грабовский/_5_Portable/_1_BASIC_APPS/_SCRIPTS/nodejs/db.dat";
var addedPath = "d:/Грабовский/_5_Portable/_1_BASIC_APPS/_SCRIPTS/nodejs/added.dat";
var removedPath = "d:/Грабовский/_5_Portable/_1_BASIC_APPS/_SCRIPTS/nodejs/removed.dat";

var file;

var filesCounter = 0;
console.log("Scanning...");
var files = walk(scanPath, process.stdout);
process.stdout.write("\r " + files.length + " files & folders.");

console.log();
console.log("Getting new...");
var struct_new = new FilesStructure(files);
console.log(" "+struct_new.fileRecords.length + " file records.");

console.log("Reading old...");
var stat = fs.statSync(dbPath);
if (stat.size != 0) {
	var struct_old = JSON.parse( fs.readFileSync(dbPath).toString() );
	console.log(" "+struct_old.fileRecords.length + " file records.");
	
	console.log("  Comparing...");
	var cmpRes = new ComparisonResult(struct_old, struct_new);
	console.log("   "+cmpRes.addedRecords.length + " added.");
	console.log("   "+cmpRes.removedRecords.length + " removed.");
	console.log("   "+ (struct_old.fileRecords.length - cmpRes.removedRecords.length) + " the same.");

	console.log("  Saving added...");
	file = fs.createWriteStream(addedPath, {flags : 'w'});
	file.write( JSON.stringify(cmpRes.addedRecords, null, 2) );

	console.log("  Saving removed...");
	file = fs.createWriteStream(removedPath, {flags : 'w'});
	file.write( JSON.stringify(cmpRes.removedRecords, null, 2) );
	
} else {
	console.log("  no old db");
}

console.log("Saving db...");
file = fs.createWriteStream(dbPath, {flags : 'w'});
file.write( JSON.stringify(struct_new, null, 2) );

console.log("Done.");
setTimeout(function() {}, 10000000);
