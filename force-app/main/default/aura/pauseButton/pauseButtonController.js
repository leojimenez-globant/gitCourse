({
    handlePauseClick : function(component, event, helper) {
		var evento = component.getEvent("cmpPauseEvent");
        var tsComplete = component.get("v.contadorPlay");
        
        evento.setParams({"seeOrNot" : false,  "message" : tsComplete , "stop" : true});
        evento.fire();
        
        
    }
})