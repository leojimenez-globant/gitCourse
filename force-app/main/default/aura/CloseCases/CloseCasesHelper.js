({
    getCases : function(component) {
		var action = component.get("c.getCasesList");
        var search = component.get("v.recordId");
        
        action.setParams({caseId: search });
        
        action.setCallback(this,function(response){
            
            var state = response.getState();
            if(state === "SUCCESS"){
                var casess = response.getReturnValue();
                component.set("v.cases", casess);
                
            }else {
                console.log("Failed with state: " + state);
            }
                
                
        });
        $A.enqueueAction(action);
    },
    getCasesToClose: function(component){
        var action = component.get("c.getCaseToClose");
        var search = component.get("v.valueCases");
        console.log(search);
        action.setParams({casesIds: search });
        
        action.setCallback(this,function(response){
            
            var state = response.getState();
            if(state === "SUCCESS"){
                
                component.set("v.casesToUp",[]);
				var casess = response.getReturnValue();
                component.set("v.casesToUp",casess);
                
                
            }else {
                console.log("Failed with state: " + state);
            }
                
                
        });
        $A.enqueueAction(action);
        
    },
    
    CloseCase: function(component,casse){
        var action = component.get("c.updateCase");
        action.setParams({casse: casse });
        
        action.setCallback(this,function(response){
            
            var state = response.getState();
            if(state === "SUCCESS"){
                
                console.log("Se cerro con exito");
                
            }else {
                var error = response.getError()[0].pageErrors[0].message;
                console.log("Failed with state: " + error);
                
            }
                
                
        });
        
        $A.enqueueAction(action);
        component.updateListCase();
    },
    
    handleShowToastSucess : function(component, event, helper) {
        component.find('notifLib').showToast({
            "variant": "success",
            "title": "Success!",
            "message": "The record has been updated successfully."
        });
    },
    
    handleShowNoticeError : function(component, event, helper) {
        component.find('notifLib').showNotice({
            "variant": "error",
            "header": "Something has gone wrong!",
            "message": "Debe completar la Razon de cierre para poder cerrar los casos",
            
        });
    }
    
})