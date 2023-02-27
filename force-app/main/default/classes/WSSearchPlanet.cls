public with sharing class WSSearchPlanet {

    private static final SwaggerScanner__c SERVICE_CONFIG = SwaggerScanner__c.getInstance();
    static String url = SERVICE_CONFIG.Url__c;
    static String type = SERVICE_CONFIG.Type__c;
    static String user = SERVICE_CONFIG.User__c;
    static String pass = SERVICE_CONFIG.Pass__c;
    static Integer count;
    static String acessCodeQ;
    static String caseIdQ;

    @AuraEnabled
    public static String searchPlanetCallOut(String acesscode, String caseId){
        System.debug(caseId);
        System.debug(acesscode);
        caseIdQ = caseId;
        acessCodeQ = acesscode;
        count  = Integer.valueOf(SERVICE_CONFIG.retries__c);
        RestWS ws = makeRequest(acessCodeQ);
        searchPlanet resp = (searchPlanet) ws.invoke(new searchPlanet());
        System.debug(resp);
        return resp.message;  
    }

    @Future(callout=true)
    public static void searchPlanetCallOutRetries(String acessCodeP, Integer countP, String caseIdP){
        count  = countP;
        acessCodeQ = acessCodeP;
        caseIdQ = caseIdP;
        System.debug('Contador:'+ count);
        System.debug('acessCodeP:'+ acessCodeQ);
        System.debug('caseIdQ:'+ caseIdQ);
        if(count >= 0){
            System.debug('Nueva llamada');
            RestWS ws = makeRequest(acessCodeQ);
            searchPlanet resp = (searchPlanet) ws.invoke(new searchPlanet());
            System.debug(resp);
        } 
    }

    public static RestWS makeRequest(String acessCode){
        List<WSParameter> headerParams = new List<WSParameter>();
        WSParameter accept = new WSParameter('accept','application/json', true);
        Blob headerValue = Blob.valueOf(user +':'+pass);
        WSParameter authorization = new WSParameter('authorization',type+' '+ EncodingUtil.base64Encode(headerValue), true);
        headerParams.add(accept);
        headerParams.add(authorization);
        RestWS ws = new RestWS(url+acesscode,'GET',null,'',headerParams);
        return ws;
    }

    public class searchPlanet extends WSResult{
        public override void processResponse(HttpResponse response) {
            Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            message = String.valueOf(m.get('found'));
            Case caseToUpdate = [SELECT id, Status, Found_Yoda__c, Successful__c FROM Case WHERE Id = :caseIdQ];
            System.debug(caseToUpdate);
            caseToUpdate.Status = 'Closed';
            caseToUpdate.Successful__c = true;
            caseToUpdate.Found_Yoda__c = (Boolean)m.get('found');
            Database.SaveResult saveResultList = Database.update(caseToUpdate);
            if(saveResultList.isSuccess()) {
                System.debug('Se actualizo con exito');
            }
             else {
                for(Database.Error err : saveResultList.getErrors()) {
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug(err.getFields()); 
                }
            }
            
        }
 
		public override void processErrorResponse(HttpResponse response) {
            Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            message = String.valueOf(m.get('error'));
            System.debug('Encolar '+count);
            ID jobID = System.enqueueJob(new scheduleSearchPlanet(acessCodeQ,count,caseIdQ));   
		}
    }
}