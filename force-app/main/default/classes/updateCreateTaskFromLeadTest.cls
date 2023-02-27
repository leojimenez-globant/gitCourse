@isTest
public with sharing class updateCreateTaskFromLeadTest {
    static testMethod void updateCreateTaskFromLeadTest() {
        
        //1° CREAR LEAD
        Lead leadTest = new Lead();

        leadTest.LastName = 'LeonardoJimenez';
        leadTest.Company = 'Mia';
        leadTest.Status = 'Working - Contacted';
        leadTest.Email = 'loejimenez88@gmail.com';
        leadTest.Descripcion_Personalizada__c = 'Hola';
        leadTest.Texto_Auxiliar__c = 'Como estas?';

        insert leadTest;

        
        
        //2° VERIFICAR SI SE CREO EL TASK ASOCIADO A DICHO LEAD
        Lead leadBD = [SELECT id, Descripcion_Personalizada__c FROM Lead WHERE LastName = 'LeonardoJimenez'];
        Task taskTest = [SELECT WhoId FROM Task];
        Id taskID = taskTest.Id;

        System.assertEquals(taskTest.WhoId,leadBD.Id);
           //Una vez insertado el lead en la DB creamos un segundo task asociado al ID del lead creado.
        Task taskPrueba = new Task ();
        taskPrueba.OwnerId = leadBD.OwnerId;
        taskPrueba.Status = 'In Progress';
        taskPrueba.Subject = 'Email';
        taskPrueba.WhoId = leadBD.Id;
        taskPrueba.Priority = 'Normal';
        taskPrueba.Texto_Auxiliar__c = 'Javier';
        insert taskPrueba;

        task taskPruebaID = [SELECT Id FROM Task WHERE Texto_Auxiliar__c = 'Javier' LIMIT 1];
        
        //3° MODIFICAR CAMPO EN LEAD Y VER QUE SE MODIFIQUE EN TASK
        leadBD.Descripcion_Personalizada__c = 'HolaAAAA';
        
        update leadBD;

        Lead leadBD2 = [SELECT Descripcion_Personalizada__c, Texto_Auxiliar__c FROM Lead WHERE LastName = 'LeonardoJimenez'];
        Task taskTest2 = [SELECT Descripcion_Personalizada__c FROM Task WHERE WhoId = :leadBD2.Id];

        System.assertEquals(taskTest2.Descripcion_Personalizada__c,leadBD2.Descripcion_Personalizada__c);


        leadBD2.Texto_Auxiliar__c = 'How are you?';
        
        update leadBD;

        Lead leadBD3 = [SELECT Texto_Auxiliar__c FROM Lead WHERE LastName = 'LeonardoJimenez'];
        Task taskTest3 = [SELECT Texto_Auxiliar__c FROM Task WHERE WhoId = :leadBD2.Id];

        System.assertEquals(taskTest3.Texto_Auxiliar__c,leadBD3.Texto_Auxiliar__c);

        // VER QUE SOLO SE HAYA MODIFICADO EL TASK CREADO JUNTO CON EL LEAD

        Task taskControl = [SELECT Descripcion_Personalizada__c, Texto_Auxiliar__c FROM Task WHERE Id = :taskPruebaID.Id];
        System.assertNotEquals(taskControl.Descripcion_Personalizada__c, 'HolaAAAA');
        System.assertNotEquals(taskControl.Texto_Auxiliar__c, 'How are you?');
    }
}