({
	getCharacter : function(component, event, helper) {
       		//Se toma el valor del campo ID del formulario y se guarda en una var para comparar su dato.
        	var search = component.find("formID").get("v.value");
        	var str = search;
        // Si el tipo de dato es igual a 0, esta vacio o es mayor a 88 (actual numero de personajes en la api)
        // arroja una alerta de error
        if(!str || 0 === str.length || str== "0" || str >= 89 ){
            alert('Ingrese un ID correcto');            
        }else{
        	//Si todo esta bien se crea la accion que va a traer al personaje desde la API
            // y se pasa como parametro el ID para buscarlo
            
            var action = component.get("c.getCharacterData");
          	
            action.setParams({paramID: search })
        // cuando vuelve la respuesta de la api con/sin los datos
        action.setCallback(this, function(response) {
            //Si vuelve con datos, se pasa el varlor de la respuesta (el personaje)
            //a la variable personaje del componente y se usa para mostrar los campos en el form
            var state = response.getState();
            if (state === "SUCCESS") {
                var algo= response.getReturnValue();
                //console.log(algo);
                component.set("v.personaje", algo );
				// Se habilita el boton de subir a la base de datos
            	var chagestate = component.find("buttonsave").set("v.disabled",false);
              	//Funcion que recorre todos los input y checkea si son campos desconocidos, si lo son, se activa para su edicion
              	//caso contrario, se deshabilita para que el usuario no pueda interactuar con dicho componente.
                var disab = component.find('atribID').reduce(function (validar, inputCmp) {
                    var check = inputCmp.get("v.value");
                    if(check == 'unknown'){inputCmp.set("v.disabled",false)
                                          }else{inputCmp.set("v.disabled",true)};
                },true);
                
                
                
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        // Se envia para ser ejecutada cuando pueda
        $A.enqueueAction(action);
        }
        },
    
    // Funcion del boton guardar
    clickSave : function(component, event, helper) {
  		//Valida si todos los campos del formulario son validos	
        var validforUpload = component.find('atribID').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        	}, true);
	    
        //Si todos los campos son validos, se procede a hacer la accion para subirlo.
        if(validforUpload){
            	
        
        	//Se setea la accion y se manda el personaje a subir a la base de datos.
        	var action = component.get("c.SubirDatos");
        	var contactoList = component.get("v.personaje");
			action.setParams({dato: contactoList });
        	// Se envia para ser ejecutada cuando pueda
        	
        	//Se arma un callback para recuperar el mensaje para mostrar si se cargo o no.
        	 action.setCallback(this, function(response) {
            //Si vuelve con datos, se pasa el varlor de la respuesta (el personaje)
            //a la variable personaje del componente y se usa para mostrar los campos en el form
            var state = response.getState();
            // Si el servidor se encuentra, devuelve el mensaje dependiendo si se cargo o no el personaje.
            if (state === "SUCCESS") {
                var returnmsg =response.getReturnValue();
                alert(returnmsg);               
            }else {
                console.log("Failed with state: " + state);
            }
        });
        
        	 
        	$A.enqueueAction(action);
        
        
        
        
        }
        
        
        	
        
        
        
        
        
	}
    
})