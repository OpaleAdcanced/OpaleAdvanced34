/* === Opale template manager =============================================== */
var tplMgr = {
	fFraPath : "ide:tplFra",
	fCoPath : "ide:tplCo",
	fCbkPath : "des:.cbkClosed",
	fMediaPath : "des:object.resVideo|object.resAudio",
	fWaiMnuPath : "ide:accessibility",
	fWaiBtnPath : "des:.waiBtn",
	fResumeBtnPath : "ide:my-header/des:.resumeBtn",
	fSaveBtnPath : "ide:my-header/des:.saveBtn",
	fRefLnkPath : "des:.refOutlineEntry/chi:a",
	fScreenTouch : false,
	fScreenSmall : false,

/* === Public API =========================================================== */
	/** init function - must be called at the end of page body */
	init : function(){
		try {
			// Init template-wide flags & handles
			this.fScreenTouch = "ontouchstart" in window && ((/iphone|ipad/gi).test(navigator.appVersion) || (/android/gi).test(navigator.appVersion));
			this.fScreenSmall = Number(screen.width) <= 1024;
			this.fPortrait = window.innerHeight > window.innerWidth;
			this.fCo = scPaLib.findNode(this.fCoPath);
			// Add classes to frame if needed
			var vFra = scPaLib.findNode(this.fFraPath);
			if (vFra != null && (this.fScreenTouch || this.fScreenSmall)) vFra.className = "tplFra_small" + (this.fScreenTouch ? " tplFra_touch" : "");
			// Close collapsable blocks that are closed by default.
			var vCbks = scPaLib.findNodes(this.fCbkPath);
			for (var i in vCbks) {
				var vTgl = scPaLib.findNode("des:a", vCbks[i]);
				if (vTgl) vTgl.onclick();
			}
			// Set touch-screen specific behaviour
			if (this.fScreenTouch){// Load the iScroll lib...
				var vAjax = new XMLHttpRequest();
				vAjax.open('GET', scServices.scLoad.getRootUrl()+"/wdgt/tplMgr/iscroll.js", false);
				vAjax.send(null);
				if (vAjax.responseText){
					var vScript = document.createElement( "script" );
					vScript.language = "javascript";
					vScript.type = "text/javascript";
					vScript.text = vAjax.responseText;
					document.getElementsByTagName("head")[0].appendChild(vScript);
				}
				if (!navigator.mimeTypes["application/x-shockwave-flash"]){
					// Transform possible compatible audio and video players into HTML5 players.
					var vMedias = scPaLib.findNodes(this.fMediaPath,this.fCo);
					for (var i = 0; i< vMedias.length; i++){
						var vMedia = vMedias[i];
						var vParam = vMedia.firstChild;
						var vType = "video";
						var vUri = null;
						while (vParam) { // Look for param giving media uri
							if (vParam.name && (vParam.name=="FlashVars" ||vParam.name=="src")){
								vUri = vParam.value;
								break;
							}
							vParam = vParam.nextSibling;
						}
						if (vUri){
							if (vUri.indexOf("mp3=")==0) {
								vType = "audio";
								vUri = vUri.substring(4);
							} else if (vUri.indexOf("flv=")==0) {
								vUri = vUri.substring(7);
							}
							if (vUri.indexOf("&")>0) vUri = vUri.substring(0,vUri.indexOf("&"));
							vMedia.parentNode.innerHTML="<"+vType+" controls='true' src='"+vUri+"' width='"+vMedia.width+"' height='"+vMedia.height+"'/>";
						}
					}
				}
			}
			if (this.fScreenTouch && "ScSiRuleResize" in window) new ScSiRuleResize(this.fCoPath,function(){tplMgr.fCo.fScroller.refresh()});
			this.fStore = new LocalStore();
			scOnLoads[scOnLoads.length] = this;
		} catch(e) {
			//alert("L'initialisation de la page a échouée : "+e);
		}
	},
	/** scCoLib OnLoad  */
	onLoad: function() {
		scCoLib.util.log("tplMgr.onLoad");
		
		// Set tooltip callback functions.
		if ("scTooltipMgr" in window) {
			if (this.fScreenTouch){
				scTooltipMgr.xGetEltL = this.sTtGetEltL;
				scTooltipMgr.xGetEltT = this.sTtGetEltT;
			} else {
				scTooltipMgr.addShowListener(this.sTtShow);
				scTooltipMgr.addHideListener(this.sTtHide);
			}
		}
		// Set SubWin callback functions.
		if ("scDynUiMgr" in window && !this.fScreenTouch) {
			scDynUiMgr.subWindow.addOnLoadListener(this.sSwLoad);
			scDynUiMgr.subWindow.addCloseListener(this.sSwClose);
		}
		
		// Set save & resume button onclicks.
		var vResumeBtns = scPaLib.findNodes(this.fResumeBtnPath);
		for (var i in vResumeBtns) {
			if(vResumeBtns[i]) vResumeBtns[i].onclick=function(){
				var vUrl = window.sessionStorage.getItem("courseUrl");
				if(vUrl) this.setAttribute("href", vUrl);
			}
		}
		var vSaveBtns = scPaLib.findNodes(this.fSaveBtnPath);
		for (var i in vSaveBtns) {
			if(vSaveBtns[i]) vSaveBtns[i].onclick=function(){
				window.sessionStorage.setItem("courseUrl", document.location.href);
			}
		}
		
		// Accessibility menu focus.
		var vWaiMnu = scPaLib.findNode(this.fWaiMnuPath);
		if (vWaiMnu){
			vWaiMnu.fClass = vWaiMnu.className;
			var vWaiBtns = scPaLib.findNodes(this.fWaiBtnPath,vWaiMnu);
			for (var i in vWaiBtns) {
				vWaiBtns[i].onfocus = function(){vWaiMnu.className = vWaiMnu.fClass + " waiFocus"}
				vWaiBtns[i].onblur = function(){vWaiMnu.className = vWaiMnu.fClass}
			}
		}
		
		// Set touch-screen specific behaviour
		if (this.fScreenTouch && "iScroll" in window){
			
			// deactivate scImgMgr focusing.
			if ("scImgMgr" in window) scImgMgr.setFocus(false);
			
			// Make refOutlineEntry links iScroll comptible.
			/*var vRefLnks = scPaLib.findNodes(this.fRefLnkPath,this.fCo);
			for (var i = 0; i < vRefLnks.length; i++){
				var vRefLnk =  vRefLnks[i];
				vRefLnk.onclick = function(){
					try{
						var vId = this.hash.replace("#","");
						tplMgr.fCo.fScroller.scrollToElement(sc$(vId),500);
					}catch(e){alert(e);}
					return false;
				}
			}*/
			// Add touch specific event handling
			document.addEventListener("touchstart", this.sTouchHandler, true);
			document.addEventListener("touchmove", this.sTouchHandler, true);
			document.addEventListener("touchend", this.sTouchHandler, true);
			document.addEventListener("touchcancel", this.sTouchHandler, true);
			document.addEventListener("click", this.sTouchHandler, true);
			
			/*Cause pb alignement galerie*/
			//if ("scImgMgr" in window) scImgMgr.registerListener("onAnimationOpen", this.sTouchGalOpen);
			
			if ("scDragMgr" in window) {
				
				scDragMgr.addStartListener(function(){
					tplMgr.fDisableTouchEvents = true;
				});
				scDragMgr.addStopListener(function(){
					tplMgr.fDisableTouchEvents = false;
				});
			}
			
			
			
			
			
			// Add scrolling to content.
			this.fCo.fScroller = new iScroll(this.fCo,{
				vScrollbar:true,
				fixedScrollbar:true,
				bounce:false,
				onBeforeScrollStart: function (e) {
					var target = e.target;
					while (target.nodeType != 1) target = target.parentNode;
					if (target.tagName != 'SELECT' && target.tagName != 'INPUT' && target.tagName != 'TEXTAREA') e.preventDefault();
				},
				useTransform:(scPaLib.findNode("des:.mediaWeb",this.fCo)?false:true)});
				
			
		}
	},
	loadSortKey : "AZ",
	/** Load next image if gallery open or page if exists */
	next: function() {
		if ("scImgMgr" in window && scImgMgr.fCurrItem && scImgMgr.fCurrItem.fName == "gal"){
			scImgMgr.xNxtSs(scImgMgr.fCurrItem);
		} else {
			var vBtn = scPaLib.findNode("des:a.btnNxt");
			if(vBtn) document.location = vBtn.href;
		}
	},
	/** Load previous image if gallery open or page if exists */
	previous: function() {
		if ("scImgMgr" in window && scImgMgr.fCurrItem && scImgMgr.fCurrItem.fName == "gal"){
			scImgMgr.xPrvSs(scImgMgr.fCurrItem);
		} else {
			var vBtn = scPaLib.findNode("des:a.btnPrv");
			if(vBtn) document.location = vBtn.href;
		}
	},
	xMediaFallback: function(pMedia) {
		while (pMedia.firstChild) {
			if (pMedia.firstChild instanceof HTMLSourceElement) {
				pMedia.removeChild(pMedia.firstChild);
			} else {
				pMedia.parentNode.insertBefore(pMedia.firstChild, pMedia);
			}
		}
		pMedia.parentNode.removeChild(pMedia);
	},
/* === Event Handlers & lib override functions ============================== */
	/** Touch event Handler */
	sTouchHandler: function(pEvt) {
		if (tplMgr.fDisableTouchEvents) return;
		switch(pEvt.type) {
			case "click":
				if ("scTooltipMgr" in window) scTooltipMgr.hideTooltip(); // Close tooltips on click as mouseup is not available
				break;
			/*case "touchstart":
				if(pEvt.touches.length == 1){
					tplMgr.fSwipeStart = {x:pEvt.touches[0].pageX,y:pEvt.touches[0].pageY};
					tplMgr.fSwipeEnd = tplMgr.fSwipeStart;
				}
				break;
			case "touchmove":
				pEvt.preventDefault()
				if(pEvt.touches.length == 1){
					tplMgr.fSwipeEnd = {x:pEvt.touches[0].pageX,y:pEvt.touches[0].pageY};
				}
				break;
			case "touchend":
				try{ //Swipe left & right to change page (delta Y < 30% & delta X > 100px)
					var vDeltaX = tplMgr.fSwipeStart.x - tplMgr.fSwipeEnd.x;
					if (Math.abs((tplMgr.fSwipeStart.y - tplMgr.fSwipeEnd.y)/vDeltaX) < 0.3){ 
						if (vDeltaX > 100) tplMgr.next();
						else if(vDeltaX <- 100) tplMgr.previous();
					}
					tplMgr.fSwipeStart = {x:null,y:null};
					tplMgr.fSwipeEnd = tplMgr.fSwipeStart;
				} catch(e){}*/
		}
	},
	/** sTouchGalOpen callback : this = function */
	sTouchGalOpen: function(pGal) {
		if (!pGal || !pGal.fFra || typeof pGal.fFra.fTouchScreen != "undefined") return;
		pGal.fFra.className = pGal.fFra.className + " " + pGal.fFra.className + "_touch";
	},
	/** Tooltip lib show callback : this = function */
	sTtShow: function(pNode) {
		var vClsBtn = scPaLib.findNode("des:a.tooltip_x", scTooltipMgr.fCurrTt);
		if (vClsBtn) window.setTimeout(function(){vClsBtn.focus();}, pNode.fOpt.DELAY + 10);
		else if (!pNode.onblur) pNode.onblur = function(){scTooltipMgr.hideTooltip(true);};
	},
	/** Tooltip lib hide callback : this = function */
	sTtHide: function(pNode) {
		if (pNode) pNode.focus();
	},
	/** Tooltip lib xGetEltL - added iScroll compatibility : this = scTooltipMgr */
	sTtGetEltL: function(pElt) {
		var vX;
		if (pElt.style.pixelLeft) {
			vX = this.xInt(pElt.style.pixelLeft);
		} else {
			vX = this.xInt(pElt.offsetLeft);
			if (pElt.offsetParent.tagName.toLowerCase() != 'body' && pElt.offsetParent.tagName.toLowerCase() != 'html') {
				vX -= pElt.offsetParent.scrollLeft;
				if(pElt.offsetParent.fScroller) vX += pElt.offsetParent.fScroller.x
				vX += this.xGetEltL(pElt.offsetParent);
			}
		}
		return vX;
	},
	/** Tooltip lib xGetEltT - added iScroll compatibility : this = scTooltipMgr */
	sTtGetEltT: function(pElt) {
		var vY;
		if (pElt.style.pixelTop) {
			vY = this.xInt(pElt.style.pixelTop);
		} else {
			vY = this.xInt(pElt.offsetTop);
			if (pElt.offsetParent.tagName.toLowerCase() != 'body' && pElt.offsetParent.tagName.toLowerCase() != 'html') 							{	
				vY -= pElt.offsetParent.scrollTop;
				if(pElt.offsetParent.fScroller) vY += pElt.offsetParent.fScroller.y
				vY += this.xGetEltT(pElt.offsetParent);
			}
		}
		return vY;
	},
	/** SubWin lib load callback : this = function */
	sSwLoad: function(pFra) {
		var vCo = scPaLib.findNode("ide:content", pFra.contentDocument);
		if (vCo) vCo.focus();
	},
	/** SubWin lib close callback : this = function */
	sSwClose: function(pId) {
		var vSubWin = scDynUiMgr.subWindow.fSubWins[pId];
		if (vSubWin && vSubWin.fAnc) vSubWin.fAnc.focus();
	}
}

/** Local Storage API (localStorage/userData/cookie) */
function LocalStore(pId){
	if (pId && !/^[a-z][a-z0-9]+$/.exec(pId)) throw new Error("Invalid store name");
	this.fId = pId || "";
	this.fRootKey = document.location.pathname.substring(0,document.location.pathname.lastIndexOf("/")) +"/";
	if ("localStorage" in window && typeof window.localStorage != "undefined") {
		this.get = function(pKey) {var vRet = localStorage.getItem(this.fRootKey+this.xKey(pKey));return (typeof vRet == "string" ? unescape(vRet) : null)};
		this.set = function(pKey, pVal) {localStorage.setItem(this.fRootKey+this.xKey(pKey), escape(pVal))};
	} else if (window.ActiveXObject){
		this.get = function(pKey) {this.xLoad();return this.fIE.getAttribute(this.xEsc(pKey))};
		this.set = function(pKey, pVal) {this.fIE.setAttribute(this.xEsc(pKey), pVal);this.xSave()};
		this.xLoad = function() {this.fIE.load(this.fRootKey+this.fId)};
		this.xSave = function() {this.fIE.save(this.fRootKey+this.fId)};
		this.fIE=document.createElement('div');
		this.fIE.style.display='none';
		this.fIE.addBehavior('#default#userData');
		document.body.appendChild(this.fIE);
	} else {
		this.get = function(pKey){var vReg=new RegExp(this.xKey(pKey)+"=([^;]*)");var vArr=vReg.exec(document.cookie);if(vArr && vArr.length==2) return(unescape(vArr[1]));else return null};
		this.set = function(pKey,pVal){document.cookie = this.xKey(pKey)+"="+escape(pVal)};
	}
	this.xKey = function(pKey){return this.fId + this.xEsc(pKey)};
	this.xEsc = function(pStr){return "LS" + pStr.replace(/ /g, "_")};
}

