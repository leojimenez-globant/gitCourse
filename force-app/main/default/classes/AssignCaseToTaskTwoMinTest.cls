@isTest
public with sharing class AssignCaseToTaskTwoMinTest {
    @TestSetup
    static void setup(){
        
        Contact contactTest = new Contact();
        contactTest.LastName = 'Jimenez';
        insert contactTest;

        Contact contactDB = [SELECT Id, OwnerId FROM Contact WHERE LastName = 'Jimenez'];

        Task taskTest = new Task();
        taskTest.OwnerId = contactDB.OwnerId;
        taskTest.Status = 'In Progress';
        taskTest.Subject = 'Email';
        taskTest.WhoId = contactDB.Id;
        taskTest.Priority = 'Normal';
        insert taskTest;

        Case caseTest = new Case();
        caseTest.Status = 'Working';
        caseTest.Origin = 'Phone';
        caseTest.ContactId = contactDB.Id;
        insert caseTest;
    }

    @isTest
    static void assignCaseToTask(){

        Case caseT = [SELECT Id, ContactId, CreatedDate FROM Case WHERE Origin = 'Phone'];
        Task taskT = [SELECT WhatId, WhoId, CreatedDate FROM Task WHERE Status = 'In Progress'];

        test.startTest();
        
        Integer tiempo = caseT.CreatedDate.minute() - taskT.CreatedDate.minute();

        System.assertEquals(taskT.WhatId , caseT.Id , 'El caso no se vinculo con el Task');
        System.assert(tiempo < 3, 'Tiempo de creacion del task mayor a 2 min');        
        System.assertEquals(caseT.ContactId , taskT.WhoId , 'El task y el case no pertenece al mismo contacto');
        
        test.stopTest();


    }

    @isTest
    static void assingFailedFourMinutes(){

        Contact contactDB2 = [SELECT Id, OwnerId FROM Contact WHERE LastName = 'Jimenez'];

        Task taskTest2 = new Task();
        taskTest2.OwnerId = contactDB2.OwnerId;
        taskTest2.Status = 'Completed';
        taskTest2.Subject = 'Email';
        taskTest2.WhoId = contactDB2.Id;
        taskTest2.Priority = 'Normal';
        insert taskTest2;

        Case caseTest2 = new Case();
        caseTest2.Status = 'Working';
        caseTest2.Origin = 'Email';
        caseTest2.ContactId = contactDB2.Id;
        
        Task taskFourMinutes = [SELECT Id, WhatId, WhoId, CreatedDate FROM Task WHERE Status = 'Completed'];

        Integer fourMin = taskFourMinutes.CreatedDate.minute() - 4; 

        Test.setCreatedDate(taskTest2.Id , DateTime.newInstance(1999, 2, 11, 8, fourMin, 16));
      
        test.startTest();
        insert caseTest2;
        Task taskT2 = [SELECT Id, WhatId, WhoId, CreatedDate FROM Task WHERE Status = 'Completed'];
        
        Case caseT2 = [SELECT Id, ContactId, CreatedDate FROM Case WHERE Origin = 'Email'];

        Integer tempo = caseT2.CreatedDate.minute() - taskT2.CreatedDate.minute();


        System.assertNotEquals(taskT2.WhatId, caseT2.Id, 'Se asocio el case con el task que no tendria que pasar');
        test.stopTest();
    }
}