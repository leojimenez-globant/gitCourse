public with sharing class StarWarsController {
	@AuraEnabled
    //Metodo que crea la llamada y devuelve el personaje de la API
    //Lo manejo en forma de lista y no de objeto ya que una lista dinamica consume menos recurso
    //que un objeto ya pre.definido en memoria y cumple para hacer lo pedido. Antse de subirlo a
    //salesforce se guarda como objeto.
    public static List<string> getCharacterData(string paramID) {
        List<string> chr = new List<string>();
        String stringID = paramID;
        Http http = new Http();
    	HttpRequest request = new HttpRequest();
    	request.setEndpoint('https://swapi.dev/api/people/'+stringID+'/?format=json');
    	request.setMethod('GET');
    	HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {
        	
            // Se dezserializa el JSON en datos primitivos
    		Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
    		// Se guarda cada variable(campos) de los datos en sus respectivas variables y se crea una lista con ellos
    		// y se devuelve la lista de esos campos
            System.debug(results);
            String gender = (String) results.get('gender');
            String name = (String) results.get('name');
			String height = (String) results.get('height');
	 		String hair_color = (String) results.get('hair_color');
	 		String eye_color = (String) results.get('eye_color');
	 		String homeworld = (String) results.get('homeworld');
	 		String url= (String) results.get('url');
            chr.add(gender);
            chr.add(name);
            chr.add(height);
            chr.add(hair_color);
            chr.add(eye_color);
            chr.add(homeworld);
            chr.add(url); 
            chr.add(stringID);
         }
        
		return chr;
    }
    	// Metodo que recibe el personaje como una lista de sus atributos (datos)
    	// y la sube a la base de datos
    	@AuraEnabled
        public static String SubirDatos(List<String> dato){
            //variable a devolver para darle un mensaje al usuario de carga o error.
            String complete = '';
            
            String gender = dato[0];
            String name = dato[1];
			String height = dato[2];
	 		String hair_color = dato[3];
	 		String eye_color = dato[4];
	 		String homeworld =  dato[5];
	 		String url= dato[6];
            String idPerson = dato[7];
            
            Contact contacto = new Contact();
        	contacto.LastName = name;
            contacto.Name__c = name;
    		contacto.gender__c = gender;
    		contacto.height__c = height;
    		contacto.haircolor__c = hair_color;
        	contacto.eyecolor__c = eye_color;
    		contacto.homeworld__c = homeworld;
    		contacto.url__c = url;
    		contacto.idcharacter__c = idPerson;
            
            // try catch para evitar duplicados con un upsert
            // se comprueba con el campo idcharacter__c ya que tiene que ser unico por personaje (porq es el id al cual pertenece)
            // idcharacter__c; lo setee como clave externa para poder usarlo con el upsert como parametro de comparacion.
            // TAMBIEN pude haber hecho una peticion al servidor para recuperar los ID, si existia, lo actualizaba y daba el mensaje
            // (El contacto ya existia, se actualizo) y si el id no exisitia ('El archivo fue subido al servidor') para mayor feedback
            // pero en este caso el codigo es mas corto (menos recursos) y hace lo que se pidio. 
            try {

    			upsert contacto idcharacter__c;
                complete = 'El archivo fue subido al servidor';
				
			} catch (DmlException e) {
				// Si hay un error, la variable complete guarda el error del systema y se la manda al controlador para mostrarsela
				// al usuario (tmb le puedo poner "Error en carga/Datos duplicados") pero me parecio mas conveniente el mensaje completo
				// ya que es para que lo vean ustedes, no usuarios comunes.
    			System.debug(e.getMessage());
                complete = e.getMessage();
                //complete = 'El esta duplicado/fallo en la carga al servidor';
			}
       
            return complete ;
        }     
    
    		
    
}