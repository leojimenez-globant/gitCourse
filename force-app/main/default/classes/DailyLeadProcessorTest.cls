@isTest
private class DailyLeadProcessorTest {
	@testSetup
     static void setup(){
        List<Lead> leadl = new List<Lead>();
        for (Integer i=0; i<200; i++){
            Lead ld = new Lead (Company='Nose '+i, LastName= 'Jim',Status='Working');
            leadl.add(ld);
        }
        
        insert leadl;
        
        
       
    }
    
    
    static testMethod void DailyLEadProcessorTest(){
        String sch = '0 0 0 15 3 ? 2022';
        Test.startTest();
        String jobId = System.Schedule('SchedulableApexTest', sch, new DailyLeadProcessor());
        
        List<Lead> listofLead = [SELECT Id FROM Lead WHERE LeadSource = null LIMIT 200];
        system.assertEquals(200, listofLead.size());
        
        Test.stopTest();
        
       }
    
}