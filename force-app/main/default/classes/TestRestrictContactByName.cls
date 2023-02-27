@isTest
public with sharing class TestRestrictContactByName {
    @isTest
    
    static void ContactDiferentLastNameInvalidNameMustSucess() {
        Contact contactTest = new Contact ();
        contactTest.LastName = 'Jimenez';
        
        test.startTest();
        Database.SaveResult result = Database.insert(contactTest,false);
        test.stopTest();

        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
        
    }

    @isTest
    static void ContactInsertWhitLastNameInvalidMustFail(){
        Contact contactTest = new Contact ();
        contactTest.LastName = 'INVALIDNAME';
        
        test.startTest();
        Database.SaveResult result = Database.insert(contactTest,false);
        test.stopTest();

        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('The Last Name "INVALIDNAME" is not allowed for DML',
                             result.getErrors()[0].getMessage());
    }
    @isTest
    static void ContactUpdateWhitLastNameInvalidMustFail(){
        Contact contactTest = new Contact ();
        contactTest.LastName = 'Jimenez';
        insert contactTest;
        
        Contact cTest2 = [SELECT LastName FROM Contact];
        cTest2.LastName = 'INVALIDNAME';

        test.startTest();
        Database.SaveResult result = Database.update(cTest2,false);
        test.stopTest();

        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('The Last Name "INVALIDNAME" is not allowed for DML',
                             result.getErrors()[0].getMessage());
    }
}