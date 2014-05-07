// Hack  : suppression de la recherche scorm2004 car implémentation 2004  non aboutie.
if(scServices.scorm2k4) {
	scServices.scorm2k4.xInitScorm2k4 = function(){ return false;};
}

// Hack Ganesha : Suppression de l'enregistrement suspend-data qui semble limité à 450 caractères au lieu des 4000 de la norme.
//ce qui est vraiment trop faible et provoque un echec avec 4 ou 5 quiz seulement.
scServices.suspendDataStorage.commit = function() {};