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


FilesStructure = function(dir, log) {
	this.fileRecords = Array();
	this.lastScanned = Date();
	
	this.scan = function(dir, log) {
		var list = fs.readdirSync(dir);
		for (var i = 0; i < list.length; i++) {
		
			var file = list[i];
			file = dir + '/' + file;
			file = path.resolve(file);
			var fr = new FileRecord(file);
			this.fileRecords.push(fr);
			
			if (log) log.write("\r " + ++filesCounter);
			
			if (!(fr.size >= 0)) {
				var res = this.scan(file, log);
			}
		}
		this.lastScanned = Date();
	}
	
	if(dir) {
		this.scan(dir, log);
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
	
	var compareNewCounter = 0;
	var compareOldCounter = 0;
	for (var i = 0; i < newStruct.fileRecords.length; i++) {
		process.stdout.write("\r   " + ++compareNewCounter + "/" + newStruct.fileRecords.length + " searching added");
		var fr = newStruct.fileRecords[i];
		if ( !findRecord(fr, oldStruct.fileRecords) )
			this.addedRecords.push(fr.name);
	}
	
	process.stdout.write("\n");
	for (var i = 0; i < oldStruct.fileRecords.length; i++) {
		process.stdout.write("\r   " + ++compareOldCounter + "/" + oldStruct.fileRecords.length + " searching removed");
		var fr = oldStruct.fileRecords[i];
		if ( !findRecord(fr, newStruct.fileRecords) )
			this.removedRecords.push(fr.name);
	}
	process.stdout.write("\n");
}

//=====================================================================
//=====================================================================


var scanPath = "\\\\172.20.131.12\\For Exchange\\";
//var scanPath = "d:/Грабовский/_5_Portable/_1_BASIC_APPS/_SCRIPTS/nodejs/../..";
var scanPath = "d:/Грабовский/_5_Portable/_1_BASIC_APPS/_SCRIPTS/nodejs";

var dbPath = "d:/Грабовский/_5_Portable/_1_BASIC_APPS/_SCRIPTS/nodejs/db.dat";
var addedPath = "d:/Грабовский/_5_Portable/_1_BASIC_APPS/_SCRIPTS/nodejs/added.dat";
var removedPath = "d:/Грабовский/_5_Portable/_1_BASIC_APPS/_SCRIPTS/nodejs/removed.dat";

var file;
var t0;

t0 = Date();
console.log();
console.log("Reading new..." +"  "+ Date());
var filesCounter = 0;
var struct_new = new FilesStructure(scanPath, process.stdout);
console.log(" " +   " file records.");

t0 = Date();
console.log("Reading old..." +"  "+ Date());
var stat = fs.statSync(dbPath);
if (stat.size != 0) {
	var struct_old = JSON.parse( fs.readFileSync(dbPath).toString() );
	console.log(" "+struct_old.fileRecords.length + " file records.");
	
	console.log("  Comparing..." +"  "+ Date());
	var cmpRes = new ComparisonResult(struct_old, struct_new);
	console.log("   "+cmpRes.addedRecords.length + " added.");
	console.log("   "+cmpRes.removedRecords.length + " removed.");
	console.log("   "+ (struct_old.fileRecords.length - cmpRes.removedRecords.length) + " the same.");

	console.log("  Saving added..." +"  "+ Date());
	file = fs.createWriteStream(addedPath, {flags : 'w'});
	file.write( JSON.stringify(cmpRes.addedRecords, null, 2) );

	console.log("  Saving removed..." +"  "+ Date());
	file = fs.createWriteStream(removedPath, {flags : 'w'});
	file.write( JSON.stringify(cmpRes.removedRecords, null, 2) );
	
} else {
	console.log("  no old db");
}

console.log("Saving db..." +"  "+ Date());
file = fs.createWriteStream(dbPath, {flags : 'w'});
file.write( JSON.stringify(struct_new, null, 2) ); 

console.log("Done." +"  "+ Date());
setTimeout(function() {}, 10000000);
