global class AccountProcessor {
	@future
    public static void countContacts (SET<id> setId){
        List<Account> cuenta = [SELECT Id, Number_of_Contacts__c, (SELECT Id FROM Contacts) FROM Account WHERE id IN :setId];
        for(Account acct : cuenta){
            List<Contact> contacto = acct.Contacts;
            acct.Number_of_Contacts__c = contacto.size();
        }
        update cuenta;
    }
}