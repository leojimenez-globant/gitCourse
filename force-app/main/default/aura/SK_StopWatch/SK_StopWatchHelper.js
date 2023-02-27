({
    waitingTimeId: null,
	setStartTime : function(component) {
        component.set("v.verContador",true);
        //Se crea la variable con le tiempo actual (setea la hora en 00:00:00 como default)
        var currTime =component.get("v.contador");
        var ss = currTime.split(":");
        var dt = new Date();
        dt.setHours(ss[0],ss[1],ss[2]);
        
        //Se crea otra variable tiempo 1 segundo adelantado
        var dt2 = new Date(dt.valueOf() + 1000);
        
        //Uso timetostring para recuperar solo el Tiempo en formato string "00:00:02 GMT-0300"
        //luego separo por " " para que quede un array [0] = 00:00:02 y [1] = GMT-0300
        var temp = dt2.toTimeString().split(" ");
        
        var ts = temp[0].split(":");
        
        component.set("v.contador",ts[0] + ":" + ts[1] + ":" + ts[2]);
        this.waitingTimeId =setTimeout($A.getCallback(() => this.setStartTime(component)), 1000);
    },
    setPauseTime : function(component) {
        component.set("v.verContador",false);
        window.clearTimeout(this.waitingTimeId);
    },
    setStopTime : function(component) {
        component.set("v.verContador",false);
        component.set("v.contador","00:00:00");
        window.clearTimeout(this.waitingTimeId);
    }
})