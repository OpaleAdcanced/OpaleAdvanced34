// Hack  : suppression de la recherche scorm2004 car impl�mentation 2004  non aboutie.
if(scServices.scorm2k4) {
	scServices.scorm2k4.xInitScorm2k4 = function(){ return false;};
}

// Hack Syfadis : 
// - N�cessit� d'affecter un lesson_status, sinon la session est consid�r�e invalide.
// - Alerte � la fin pour permettre au code javascript de s'executer int�gralement avant la fermeture (bug navigateur).
scOnUnloads[scOnUnloads.length] = {
	onUnload : function() {
		if(scServices.scorm12 && scServices.scorm12.isScorm12Active()) {
			try{
				var vApi = scServices.scorm12.getScorm12API();
				var vStatus = vApi.LMSGetValue("cmi.core.lesson_status");
				if( ! vStatus || vStatus == "not attempted" ) vApi.LMSSetValue("cmi.core.lesson_status", "incomplete");
			} catch(e){
				//alert(e);
			}
		}
	},
	unloadSortKey : "0status"
}

scOnUnloads[scOnUnloads.length] = {
	onUnload : function() {
		alert("\xFFFCAu revoir, \xE0 bient\xF4t.\xFFFC");
	},
	unloadSortKey : "ZwaitClose"
}