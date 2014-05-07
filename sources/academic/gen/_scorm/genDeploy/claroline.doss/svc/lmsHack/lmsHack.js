// Hack Claroline : suppression de la recherche scorm2004 car impl�mentation 2004 pr�sente mais non aboutie.
if(scServices.scorm2k4) {
	scServices.scorm2k4.xInitScorm2k4 = function(){ return false;};
}

//optimisation : D�sactivation des events unload inop�rants sur Claroline
scServices.scorm12.onUnload = function(){};
scServices.suspendDataStorage.onUnload = function(){};
scServices.exitModeStorage.onUnload = function(){};
scServices.assmntMgr.onUnload = function(){};

//Enregistrement r�gulier pour compenser l'echec durant l'�v�nement unload.
function clarolineCycle(){
	if(scServices.scorm12 && scServices.scorm12.isScorm12Active()) {
		var vApi = scServices.scorm12.getScorm12API();
		
		//en multi-SCO : on passe en completed, incomplete en mono-SCO
		var vStatus = vApi.LMSGetValue("cmi.core.lesson_status");
		if( ! vStatus || vStatus == "not attempted" ) vApi.LMSSetValue("cmi.core.lesson_status", scServices.storage ? "incomplete" : "completed");
		
		if(scServices.suspendDataStorage._Dirty) {
			vApi.LMSSetValue("cmi.suspend_data", scServices.dataUtil.serialiseObjJs(scServices.suspendDataStorage._Fields));
			scServices.suspendDataStorage._Dirty = false;
		}
		
		var vDur = new Date().getTime() - scServices.exitModeStorage._timeStart;
		var vH = vDur > 3600000 ? Math.floor(vDur / 3600000) : 0;
		var vM = Math.floor(vDur / 60000) % 60;
		var vS = Math.floor(vDur / 1000) % 60;
		var vMs = Math.round(Math.floor(vDur % 1000)/10);
		var vTime = (vH<10 ? "0"+vH : vH) + ":" + (vM<10 ? "0"+vM : vM) + ":" + (vS<10 ? "0"+vS : vS) + "." + (vMs<10 ? "0"+vMs : vMs);
		vApi.LMSSetValue("cmi.core.session_time", vTime);
		vApi.LMSSetValue("cmi.core.exit", "");
		
		vApi.LMSCommit("");
	}
}
window.setInterval(clarolineCycle, 5000);
