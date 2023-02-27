@isTest
public class AccountProcessorTest {
    public static testMethod void TestAccountProcessorTest() {
        Account a = new Account();
        a.Name = 'Leon';
        insert a;
            
        Contact person = new Contact();
        person.LastName = 'Perez';
        person.FirstName = 'Jose';
        person.AccountId = a.Id;
        insert person;
        
        set<Id> sets = new Set<Id>() ;
        sets.add(a.Id);
        
        
        Test.startTest();
        AccountProcessor.countContacts(sets);
        Test.stopTest();
        
        Account prueba = [SELECT Id, Number_of_Contacts__c FROM Account WHERE Id = :a.Id LIMIT 1];
        system.assertEquals(Integer.valueOf(prueba.Number_of_Contacts__c), 1);
    }
}