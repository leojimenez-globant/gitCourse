@isTest
public with sharing class createTaskFromLeadAndUpdateOnlyThatTest {
    @TestSetup
    static void setup(){
        
        Lead leadTest = new Lead();

        leadTest.LastName = 'LeonardoJimenez';
        leadTest.Company = 'Mia';
        leadTest.Status = 'Working - Contacted';
        leadTest.Email = 'loejimenez88@gmail.com';
        leadTest.Descripcion_Personalizada__c = 'Hola';
        leadTest.Texto_Auxiliar__c = 'Como estas?';

        insert leadTest;

        Lead leadSetup = [SELECT Id, Descripcion_Personalizada__c, OwnerId FROM Lead WHERE LastName = 'LeonardoJimenez'];
        

        //Task de prueba para comprobar que no cambia junto con el creado por el trigger
        Task taskPrueba = new Task ();
        taskPrueba.OwnerId = leadSetup.OwnerId;
        taskPrueba.Status = 'In Progress';
        taskPrueba.Subject = 'Email';
        taskPrueba.WhoId = leadSetup.Id;
        taskPrueba.Priority = 'Normal';
        taskPrueba.Descripcion_Personalizada__c = 'Jojo';
        taskPrueba.Texto_Auxiliar__c = 'Javier';
        insert taskPrueba;

        Task taskSetUp =[SELECT id, Descripcion_Personalizada__c , Texto_Auxiliar__c 
                        FROM Task 
                        WHERE Texto_Auxiliar__c = 'Javier'];

    }

    @isTest
    static void createTaskFromLeadTest(){
        
        Lead leadSetup = [SELECT Id, Descripcion_Personalizada__c FROM Lead WHERE LastName = 'LeonardoJimenez'];

        test.startTest();
        
        List<Task> taskTest = [SELECT Id FROM Task WHERE WhoId = :leadSetup.Id AND Primero_Creado__c = 'Si'];
        test.stopTest();
       
        System.assertEquals(1, taskTest.size());
    }

    @isTest
    static void updateAssociatedTaskFromLead(){
        
        Lead leadToUpdate = [SELECT Id, Descripcion_Personalizada__c, Texto_Auxiliar__c FROM Lead WHERE LastName = 'LeonardoJimenez'];
        leadToUpdate.Descripcion_Personalizada__c = 'Holas';
        leadToUpdate.Texto_Auxiliar__c = 'Buenas';
        leadToUpdate.Email = 'leojimenez88@gmail.com';
        test.startTest();
        update leadToUpdate;
        Task taskToUpdate = [SELECT Descripcion_Personalizada__c, Texto_Auxiliar__c FROM Task WHERE WhoId = :leadToUpdate.Id AND Primero_Creado__c = 'Si' ];
        Task taskNotToUpdate =[SELECT id, Descripcion_Personalizada__c , Texto_Auxiliar__c FROM Task WHERE Texto_Auxiliar__c = 'Javier'];
        test.stopTest();

        System.assertEquals('Holas', taskToUpdate.Descripcion_Personalizada__c, 'La descripcion del task no es igual (update)');
        System.assertEquals('Buenas', taskToUpdate.Texto_Auxiliar__c, 'El Texto auxiliar del task no es igual (update)');

        System.assertEquals('Jojo', taskNotToUpdate.Descripcion_Personalizada__c, 'La descripcion del segundo task fue modificada');
        System.assertEquals('Javier', taskNotToUpdate.Texto_Auxiliar__c, 'El Texto del segundo task fue modificado');

    }
}