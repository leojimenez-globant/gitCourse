@isTest
public with sharing class AccountTriggerTest {
    @isTest
    static void BillingStateMusBeEqualsToShippingState() {
        List<Account> lAccTest = new List<Account>();

        for(Integer i=0; i < 200; i++){
            Account acct = new Account(Name='Test Account ' + i, BillingState = 'CA');
            lAccTest.add(acct);
        }

        test.startTest();
        insert lAccTest;
        test.stopTest();

        List<Account> verifyAccts = [SELECT Id, ShippingState  FROM Account];
        for(Account accc : verifyAccts){
            System.assertEquals('CA' , accc.ShippingState , 'BillingState y ShippingState son diferentes');
        }
        
        
        
    }
}