({
    handlecmpPlayEvent : function(component, event, helper) {
		var contadorBool = event.getParam("seeOrNot");
        var time = event.getParam("message");
        var stop = event.getParam("stop");
        
        component.set("v.verContador", contadorBool);
        component.set("v.contador", time);
        component.set("v.isStop",stop );
        component.set("v.verStop");
    },
    
    handlecmpPauseEvent : function(component, event, helper) {
		var contadorBool = event.getParam("seeOrNot");
        var time = event.getParam("message");
        var stop = event.getParam("stop");
        
        component.set("v.isStop",stop );
        component.set("v.verContador", contadorBool);
        component.set("v.contador", time);
        
        
    },
    
    handlecmpStopEvent : function(component, event, helper) {
		var contadorBool = event.getParam("seeOrNot");
        var stop = event.getParam("stop");
        var time = event.getParam("message");
        
        component.set("v.verContador", contadorBool);
        component.set("v.contador", time);
        component.set("v.isStop", stop);
        
    }
})