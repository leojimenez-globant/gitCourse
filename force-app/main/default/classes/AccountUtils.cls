public with sharing class AccountUtils {
    
    public static List<Account> accountsByState (String abr) {
        
        List<Account> lAcc = [SELECT Id, Name FROM Account WHERE BillingState =: abr];

        return lAcc;

    }
}