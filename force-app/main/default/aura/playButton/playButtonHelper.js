({
    waitingTime: null,
	playClick : function(component) {
        var currTime =component.get("v.contadorPlay");
        var isStopp = component.get("v.stop");
        
        if(isStopp == true){
                var evento = component.getEvent("cmpPlayEvent");
                evento.setParams({"seeOrNot" : false, "message" : currTime, "stop" : false});
        		evento.fire();
            }
        
        if (isStopp == false){
            var evento = component.getEvent("cmpPlayEvent");
        	//Se crea la variable con le tiempo actual (setea la hora en 00:00:00 como default)
        
        	var ss = currTime.split(":");
        	var dt = new Date();
            dt.setHours(ss[0],ss[1],ss[2]);
        
        	//Se crea otra variable tiempo 1 segundo adelantado
        	var dt2 = new Date(dt.valueOf() + 1000);
        
        	//Uso timetostring para recuperar solo el Tiempo en formato string "00:00:02 GMT-0300"
        	//luego separo por " " para que quede un array [0] = 00:00:02 y [1] = GMT-0300
        	var temp = dt2.toTimeString().split(" ");
        	var ts = temp[0].split(":");
        	var tsComplete = ts[0] + ":" + ts[1] + ":" + ts[2];
        	this.waitingTime =setTimeout($A.getCallback(() => this.playClick(component)), 1000);
            var evento = component.getEvent("cmpPlayEvent");
                evento.setParams({"seeOrNot" : true, "stop" : false});
        		evento.fire();
            component.set("v.contadorPlay",tsComplete);
        }
     }
})