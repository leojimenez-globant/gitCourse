({
    doInit : function(component, event, helper) {
		helper.getCases(component);
    },
    
    populateCase: function(component, event, helper){
       helper.getCasesToClose(component);
    },
    
    SaveCases: function(component, event, helper){
      	
		var casos = component.get("v.valueCases");
    	var prueba2 = component.get("v.casesToUp");
        
        // Use el casos como referencia para cerrar 1 o mas casos. Si vale uno es que se selecciono uno solo
        if (casos.length == 1){
            //El componente tiene un comportamiento raro donde una ves que se crea queda como un array por mas q se vacie (seleccionando y deseleccionando un checkbox)
            //https://salesforce.stackexchange.com/questions/281201/error-component-find-get-is-not-a-function-in-lightning
            var valor =  component.find('atribID');  
            valor = Array.isArray(valor) ? valor[0].get("v.value") : valor.get("v.value");
            
            if(valor === null || valor === '' || valor.trim().length == 0){
                helper.handleShowNoticeError(component);
            }else{
                var idCase = component.find('recordEditForm'); 
            	idCase = Array.isArray(idCase) ? idCase[0].get("v.recordId") : idCase.get("v.recordId");
                //Se recorre cada caso a cerrar y se compara con el ID del caso creado en el form (recordId)
                //cuando coinciden (quiere decir q el form pertenece al caso a cerrar, se procede a cerrarlo)
                for(let j = 0 ; j <prueba2.length ; j++){
                    if (prueba2[j].Id == idCase){
                        prueba2[j].Reason_for_closing__c = valor;
                        prueba2[j].Status = "Closed";
                        helper.CloseCase(component,prueba2[j]);
                        //Se crea y asigna un array vacio a valueCases para que desaparesca el form del caso que se cerro
                        var myArray = new Array();
                        component.set("v.valueCases",myArray);
                        helper.handleShowToastSucess(component);
                    }
                }
                
            }
        }else{
            // validarTodo devuelve true si todos los casos seleccionados tienen un valor en el field Reason_for_closing__c.
            var validarTodo = component.find('atribID').reduce(function (validar, inputCmp, i) {
                    var valor = inputCmp.get("v.value");
                	
                	
                	return validar && valor && (valor != '') && (valor.trim().length != 0);
                },true);
            //Si todos tienen valor, se procede a recorrer uno por uno el form creado (correspodiente a cada caso) y se cierran.
            if(validarTodo){
                
                var updateAll = component.find('atribID').reduce(function (validar, inputCmp, i) {
                    var valor = inputCmp.get("v.value");
                	
                	for(let j = 0 ; j <prueba2.length ; j++){
                    	if (prueba2[j].Id == casos[i]){
                            prueba2[j].Reason_for_closing__c = valor;
                            prueba2[j].Status = "Closed";
                            
							helper.CloseCase(component,prueba2[j]);
                            
                    	}
                	}
                },true);
                var myArray = new Array();
                component.set("v.valueCases",myArray);
                helper.handleShowToastSucess(component);
            }else{
                helper.handleShowNoticeError(component);
            }
        }
    }
    
})