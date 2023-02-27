({
    doInit : function(component, event, helper) {
		console.log("diinit get called!!");
	},
    handlePlayClick : function(component, event, helper) {
		helper.setStartTime(component);
	},
    handlePauseClick : function(component, event, helper) {
		helper.setPauseTime(component);
	},
    handleStopClick : function(component, event, helper) {
		helper.setStopTime(component);
	}   
})