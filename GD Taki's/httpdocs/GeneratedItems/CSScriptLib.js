/* -- Adobe GoLive JavaScript Library */

CSStopExecution=false;
function CSAction(array) {return CSAction2(CSAct, array);}
function CSAction2(fct, array) { 
	var result;
	for (var i=0;i<array.length;i++) {
		if(CSStopExecution) return false; 
		var aa = fct[array[i]];
		if (aa == null) return false;
		var ta = new Array;
		for(var j=1;j<aa.length;j++) {
			if((aa[j]!=null)&&(typeof(aa[j])=="object")&&(aa[j].length==2)){
				if(aa[j][0]=="VAR"){ta[j]=CSStateArray[aa[j][1]];}
				else{if(aa[j][0]=="ACT"){ta[j]=CSAction(new Array(new String(aa[j][1])));}
				else ta[j]=aa[j];}
			} else ta[j]=aa[j];
		}			
		result=aa[0](ta);
	}
	return result;
}
CSAct = new Object;
function CSOpenWindow(action) {
	var wf = "";	
	wf = wf + "width=" + action[3];
	wf = wf + ",height=" + action[4];
	wf = wf + ",resizable=" + (action[5] ? "yes" : "no");
	wf = wf + ",scrollbars=" + (action[6] ? "yes" : "no");
	wf = wf + ",menubar=" + (action[7] ? "yes" : "no");
	wf = wf + ",toolbar=" + (action[8] ? "yes" : "no");
	wf = wf + ",directories=" + (action[9] ? "yes" : "no");
	wf = wf + ",location=" + (action[10] ? "yes" : "no");
	wf = wf + ",status=" + (action[11] ? "yes" : "no");		
	window.open(action[1],action[2],wf);
}
function CSClickReturn () {
	var bAgent = window.navigator.userAgent; 
	var bAppName = window.navigator.appName;
	if ((bAppName.indexOf("Explorer") >= 0) && (bAgent.indexOf("Mozilla/3") >= 0) && (bAgent.indexOf("Mac") >= 0))
		return true; /* dont follow link */
	else return false; /* dont follow link */
}