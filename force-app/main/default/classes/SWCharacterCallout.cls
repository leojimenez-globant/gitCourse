public with sharing class SWCharacterCallout {
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> findCharacter(String num){
        String id = num;
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://swapi.dev/api/people/' + id);
        request.setMethod('GET');
        request.setHeader('Content-Type','application/json');
        request.setHeader('Accept','application/json');
        HttpResponse response = http.send(request);

        Map<String, Object> personaje = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        System.debug(string.valueOf(personaje.get('name')));  
        return personaje;

    }
}