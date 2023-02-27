@isTest
public class LeadProcessorTest {
     @testSetup
    static void setup(){
     	List<Lead> leads = new List<Lead>();
        for (Integer i=0; i<=100 ; i++){
            leads.add(new Lead(FirstName = 'Lead '+i,
                               LastName = 'Lead '+i,
                               LeadSource = 'Algo ' +i,
                               Company = 'LeoCompany'));
        }
        system.debug(leads);
        insert leads;
    }


    static testMethod void test(){
        Test.startTest();
        LeadProcessor cand = new LeadProcessor();
        Id batchId = Database.executeBatch(cand);
        Test.stopTest();
        System.assertNotEquals(200, [SELECT count() FROM Lead WHERE LeadSource = 'Dreamforce']);
    }
    
}