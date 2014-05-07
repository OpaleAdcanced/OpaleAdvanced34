// Hack  : suppression de la recherche scorm2004 car implémentation 2004  non aboutie.
if(scServices.scorm2k4) {
	scServices.scorm2k4.xInitScorm2k4 = function(){ return false;};
}

// Hack Moodle : Protection des ' dans suspend-data, sinon Moodle plante. Les ' des fragemnts de JS sont remplacés par des tabulations.

scServices.dataUtil.serialiseObjJs = function(pObj){
	var vBuf="";
	if(pObj) for (var vKey in pObj){
		var vObj = pObj[vKey];
		if(vObj != null) {
			if(vObj instanceof Object){
				vBuf+= (vBuf!="" ? ",\t" : "\t") + vKey+"\t:{"+this.serialiseObjJs(vObj)+"}";
			} else if(typeof vObj == "number"){
					vBuf+= (vBuf!="" ? ",\t" : "\t") + vKey+"\t:" + vObj;
			} else {
				vBuf+= (vBuf!="" ? ",\t" : "\t") + vKey+"\t:\t"+vObj.toString().replace(/[\t\n\r\x5C'"]/g, this.escapeJs)+"\t";
			}
		}
	}
	return vBuf;
};
	
scServices.dataUtil.deserialiseObjJs = function(pString){
	if(!pString) return {};
	var vVal;
	eval("vVal={"+pString.replace(/[\t]/g, "\x27")+"}");
	return vVal;
};

scServices.dataUtil.escapeJs = function(pChar){
	switch(pChar) {
		case '\t' : return "\x5Ct";
		case '\n' : return "\x5Cn";
		case '\r' : return "\x5Cr";
		case '\x27' : return "\x5Cx27";
		case '\x22' : return "\x5Cx22";
		case '\x5C' : return "\x5Cx5C";
	} 
	return "";
}