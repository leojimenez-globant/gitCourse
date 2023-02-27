@isTest
public with sharing class updateAssociatedCaseTest {
    @TestSetup
    static void makeData(){
        
        Case caseTest = new Case();
        caseTest.Status = 'New';
        caseTest.Origin = 'Phone';
        caseTest.Resultado__c = 'Hola';
        insert caseTest;


        Case caseTest2 = new Case();
        caseTest2.Status = 'Working';
        caseTest2.Origin = 'Web';
        caseTest2.Case_related__c = caseTest.Id;
        caseTest2.Resultado__c = 'Hi';
        insert caseTest2;

    }

    @isTest
    static void updateResultField(){
        
        Case caseUpdatedTest1 = [SELECT Id , Resultado__c FROM Case WHERE Status = 'New'];
        caseUpdatedTest1.Resultado__c = 'Hello';
        
        test.startTest();
        
        update caseUpdatedTest1;

        Case caseUpdatedTest2 = [SELECT Id , Resultado__c FROM Case WHERE Case_related__c = :caseUpdatedTest1.Id ];

        test.stopTest();

        System.assertEquals('Hello', caseUpdatedTest2.Resultado__c, 'El campo resultado no se actualizo');

    }

    @isTest
    static void updateResultFieldNull(){
        
        Case caseUpdatedTest1 = [SELECT Id , Resultado__c FROM Case WHERE Status = 'New'];
        caseUpdatedTest1.Resultado__c = null;

        test.startTest();
        
        update caseUpdatedTest1;

        Case caseUpdatedTest2 = [SELECT Id , Resultado__c FROM Case WHERE Case_related__c = :caseUpdatedTest1.Id ];

        test.stopTest();
        System.assertEquals(null, caseUpdatedTest2.Resultado__c, 'El campo resultado no se actualizo a nulo');

    }
}