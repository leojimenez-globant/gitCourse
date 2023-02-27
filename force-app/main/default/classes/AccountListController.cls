public with sharing class AccountListController {
    @AuraEnabled
    public static List<SelectOptionClass> getCasesList(String caseId) {
        List<SelectOptionClass> opcList = new List<SelectOptionClass>();
        String caseI = caseId;
        List<String> statusOpc = new List<String>{ 'New' , 'Working' , 'Escalated'};
        List<Case> acc =  [SELECT Id, CaseNumber FROM Case WHERE AccountId = :caseI AND Status IN :statusOpc ORDER BY CaseNumber ASC];
        for(Case a: acc){
            opcList.add(new SelectOptionClass(a.Id,a.CaseNumber));
        }
        
        return opcList;
    }
    
    @AuraEnabled
    public static List<Case> getCaseToClose(List<String> casesIds) {
        List<Case> caseL = new List<Case>();
        List<String> caseIds = casesIds; 
        
        for (Case c : [SELECT Id,Reason_for_closing__c, CaseNumber, Status	FROM Case WHERE Id IN :caseIds]){
        caseL.add(c);
    	}
        
        return caseL;
        
    }
    
   @AuraEnabled
    public static void updateCase (Case casse){
        update(casse);
    }
}