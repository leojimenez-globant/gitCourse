public with sharing class AccountTriggerHandler {
    public static void CreateAccounts (List<Account> accs) {
        
        for(Account acc: accs){
            acc.ShippingState = acc.BillingState;
         }
         
        
    }
}