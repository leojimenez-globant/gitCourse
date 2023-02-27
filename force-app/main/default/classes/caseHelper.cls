public with sharing class caseHelper {
    public static void addPlanetToCase(List<Case> listCases) {
        List<String> planetsCode = new List<String>();
        List<String> caseEmails = new List<String>();
        Map<String, String> mapPlanetAccessCode = new Map<String, String>();

        

        for(Case caseToAddPlanet : listCases) {
            String planetCode = caseToAddPlanet.Description.removeStart('Código de acceso al sistema de escaneo interplanetario: ');
            planetsCode.add(planetCode);
            caseEmails.add(caseToAddPlanet.SuppliedEmail);
        }
        
        for( PlanetsAcessCode__mdt planetMetadata : [SELECT AccessCode__c, External_id__c FROM PlanetsAcessCode__mdt WHERE External_id__c IN :planetsCode]){
            if(!mapPlanetAccessCode.containsKey(planetMetadata.External_id__c)){
                mapPlanetAccessCode.put(planetMetadata.External_id__c,planetMetadata.AccessCode__c);
            }
        }

        Map<String, Map<String, Id>> mapPlanetNameCodeIdSF = new Map<String, Map<String, Id>>();
        for(Planet__c planetSF : [SELECT Id, Name, External_id__c FROM Planet__c WHERE External_id__c IN : planetsCode]){
            if(!mapPlanetNameCodeIdSF.containsKey(planetSF.Name)){
                mapPlanetNameCodeIdSF.put(planetSF.Name, new Map<String, Id>{planetSF.External_id__c => planetSF.Id});
            }
        }
        
        Map<String,Id> mapContactEmailIdSF = new Map<String, Id>();
        for(Contact contacto : [SELECT Id, Email FROM Contact WHERE Email IN :caseEmails]){
            if(!mapContactEmailIdSF.containsKey(contacto.Email)){
                mapContactEmailIdSF.put(contacto.Email, contacto.Id);
            }
        }

        for(Case caseUpdate : listCases){
            String planetName = caseUpdate.Subject.removeStart('Solicitud de escaneo - ');
            String planetCode = caseUpdate.Description.removeStart('Código de acceso al sistema de escaneo interplanetario: ');
            if(mapPlanetNameCodeIdSF.containsKey(planetName)){//Comprobamos que el planeta exista en SF.
                if(mapPlanetNameCodeIdSF.get(planetName).containsKey(planetCode)){ //Comprobamos que el nombre del Planeta coincida con el Codigo en SF.
                    if(mapPlanetAccessCode.containsKey(planetCode)){ // Compprobamos que exista la metadata.
                        String accessCode = mapPlanetAccessCode.get(planetCode);
                        if(mapContactEmailIdSF.containsKey(caseUpdate.SuppliedEmail)){ // Comprobamos que el contacto del caso exista en SF.
                            caseUpdate.Planet__c = mapPlanetNameCodeIdSF.get(planetName).get(planetCode);
                            caseUpdate.ContactId = mapContactEmailIdSF.get(caseUpdate.SuppliedEmail);
                            caseUpdate.Planet_Acess_Code__c = accessCode;
                            PlanetaryCase__e planetaryEvent = new PlanetaryCase__e(
                                Refresh__c	=true);
                                Database.SaveResult sr = EventBus.publish(planetaryEvent);
                        }else{
                            caseUpdate.addError(' El contacto del caso no esta almacenado en SF');
                        }
                    } else {
                        caseUpdate.addError('No existe Metadata para el planeta del caso');
                    } 
                } else {
                    caseUpdate.addError('El nombre del planeta no coincide con el codigo almacenado en SF');
                } 
            }else {
                caseUpdate.addError('El planeta no se encuentra en SF');
            }
        }

        System.debug('Sigue aunq haya tirado error');
    }

    @AuraEnabled
    public static List<WrapperCases> retrieveListCases(){
        List<WrapperCases> wrapperListToReturn = new List<WrapperCases>();

        for(Case caso : [   SELECT Id,CaseNumber,Subject, Status, SuppliedEmail, Contact.Name, ContactId, CreatedDate, Planet_Acess_Code__c 
                            FROM Case 
                            WHERE IsClosed = false AND Origin = 'Email' AND SuppliedEmail = 'newbone3@gmail.com'
                            ORDER BY CreatedDate 
                            ASC
                            LIMIT 5]){
            System.debug(caso);
            WrapperCases wrapperToReturn = new WrapperCases(
                caso.subject,
                caso.status,
                caso.suppliedEmail,
                caso.Contact.Name,
                '/'+caso.ContactId,
                '/'+caso.id,
                caso.CaseNumber,
                caso.Planet_Acess_Code__c
            );
            wrapperListToReturn.add(wrapperToReturn);
        }
        return wrapperListToReturn;
    }

    public class WrapperCases{
        @AuraEnabled
        public String caseId { get;set;}
        @AuraEnabled
        public String caseNumber { get;set;}
        @AuraEnabled
        public String subject { get;set;}
        @AuraEnabled
        public String status { get;set;}
        @AuraEnabled
        public String email { get;set;}
        @AuraEnabled
        public String contact { get;set;}
        @AuraEnabled
        public String contactId { get;set;}
        @AuraEnabled
        public String accesscode { get;set;}
        public WrapperCases(String subject, String status, String email, String contact, String contactId, String caseId, String caseNumber, String accesscode){
            this.subject = subject;
            this.status = status;
            this.email = email;
            this.contact = contact;
            this.contactId = contactId;
            this.caseId = caseId;
            this.caseNumber = caseNumber;
            this.accesscode = accesscode;
        }
    }
}