({
    handleStopClick : function(component, event, helper) {
		var evento = component.getEvent("cmpStopEvent");
        var tsComplete = "00:00:00";
        
        evento.setParams({"seeOrNot" : false ,  "message" : tsComplete, "stop" : true });
        evento.fire();
       
    }
})