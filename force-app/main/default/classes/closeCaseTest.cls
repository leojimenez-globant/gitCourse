@isTest
public with sharing class closeCaseTest {
    
    @TestSetup
    static void makeData(){
        
        Account acc1 = new Account(Name='Leonardo');
        insert acc1;

        Case case1 = new Case(Status = 'Working');
        case1.AccountId = acc1.Id;
        case1.Origin = 'Phone';
        insert case1;

        Case case2 = new Case(Status = 'New');
        case2.AccountId = acc1.Id;
        case2.Origin = 'Phone';
        insert case2;

        Case case3 = new Case(Status = 'New');
        case3.AccountId = acc1.Id;
        case3.Origin = 'Phone';
        insert case3;
    }

    @isTest
    static void retriveCasesFromAnAccount(){
        

        Account accTest = [SELECT Id FROM Account WHERE Name='Leonardo'];
        String accTestId = String.valueOf(accTest.Id);
        List<String> Lstring = new List<String>();
        Lstring.add(accTestId);

        Case caseTest = [SELECT Id FROM Case WHERE Status = 'Working'];

        test.startTest();
            List<SelectOptionClass> lOpc = AccountListController.getCasesList(accTestId);
        test.stopTest();

        System.assertEquals(caseTest.Id, lOpc[0].value, 'No se recuperaron casos');
    } 

    @isTest
    static void SelectedCaseShouldBeClosedWithReason(){
        

        Account accTest = [SELECT Id FROM Account WHERE Name='Leonardo'];
        String accTestId = String.valueOf(accTest.Id);
        List<String> Lstring = new List<String>();
       
        List<SelectOptionClass> lOpc = AccountListController.getCasesList(accTestId);
        
        for(SelectOptionClass sOp: lOpc){
            Lstring.add(sOp.value);
        }
        
        test.startTest();
            List<Case> caseTest = AccountListController.getCaseToClose(Lstring);
            for(Case cCase :caseTest){
                cCase.Reason_for_closing__c = 'Nose';
                cCase.Status = 'Closed';
                AccountListController.updateCase(cCase);
            }
        test.stopTest();

        List<Case> caseTest2 = AccountListController.getCaseToClose(Lstring);

        for (Case c: caseTest2) {
            System.assertEquals('Closed', c.Status, 'Los Casos no fueron cerrados');
            System.assertEquals('Nose', c.Reason_for_closing__c, 'Se cerro sin ingresar motivo');
        }
    }
    
}