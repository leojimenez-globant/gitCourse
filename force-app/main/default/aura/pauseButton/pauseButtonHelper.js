({
    pauseClick : function(component) {
		var evento = component.getEvent("cmpPauseEvent");
        var tsComplete = component.get("v.contadorPlay");
        evento.setParams({"seeOrNot" : false,  "message" : tsComplete , "stop" : true , "reset" : false});
        evento.fire();
        
        
    }
})