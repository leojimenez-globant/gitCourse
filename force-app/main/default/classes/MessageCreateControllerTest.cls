@isTest
public with sharing class MessageCreateControllerTest {
    
    @TestSetup
    static void makeData(){
        
        Account accTest = new Account();
        accTest.Name = 'Leonardo';
        accTest.Support_Tier__c	= 'Gold';

        insert accTest;

        
    }
	
    @isTest
    static void checkIfAccountSelectedHasTheCostumMessage(){
        MessageCreateController con = new MessageCreateController();
        con.texto = 'Blablabla';
        
        //Llenar la variable list_Acc con los Id de las cuentas (simulando la seleccion de las mismas)
        List<Account> accList = [SELECT Id FROM Account];

        for(Account a : accList){
            con.list_Acc.add(a.Id);
        }

        test.startTest();
            con.crearMensaje();
        test.stopTest();

        List<Mensaje__c> messageTest = [SELECT Descripcion__c FROM Mensaje__c WHERE Related_Account__c IN :con.list_Acc ];

        System.assert(messageTest.size() != 0, 'El mensaje no se asocio correctamente');
        for(Mensaje__c m : messageTest){
            System.assertEquals(con.texto, m.Descripcion__c, 'El mensaje no es el correcto');
        }
        
    }
    @isTest
    static void messageShouldntAssosiatedIfTextAreEmptySpacedNull(){
        MessageCreateController con = new MessageCreateController();
        // Cambiar el texto por null, vacio o espacios para comprobar todas las posibilidades
        con.texto = '';

        //Llenar la variable list_Acc con los Id de las cuentas (simulando la seleccion de las mismas)
        List<Account> accList = [SELECT Id FROM Account];

        for(Account a : accList){
            con.list_Acc.add(a.Id);
        }

        test.startTest();
            con.crearMensaje();
        test.stopTest();

        List<Mensaje__c> messageTest = [SELECT Descripcion__c FROM Mensaje__c WHERE Related_Account__c IN :con.list_Acc ];

        System.assert(messageTest.size() == 0, 'El mensaje se asocio con un mensaje vacio');

    }


    @isTest
    static void checkAccountsAreNotSelectedMessageIsNotCreated(){

        MessageCreateController con = new MessageCreateController();
        con.texto = 'blabla';

        
        //No se obtiene lista de cuentas simulando que no se haya seleccionado ninguna
        // List<Account> accList = [SELECT Id FROM Account];

        
        test.startTest();
            con.crearMensaje();
        test.stopTest();

        List<Mensaje__c> messageTest = [SELECT Descripcion__c FROM Mensaje__c WHERE Related_Account__c IN :con.list_Acc ];

        System.assert(messageTest.size() == 0, 'El mensaje fue creado sin cuentas seleccionadas');

    }

    @isTest
    static void throwExceptionInDB(){
        MessageCreateController con = new MessageCreateController();
        //String con las de 255 characters para que tire error el upsert ya que el field del objeto es max 255 chr.
        con.texto = 'blablablablblablablablblablablablblablablablblablablablblablablablblablablablblablablablblablablablblablablablblablablablblablablablblablablablblablablablblablablablblablablablblablablablblabla'
        +'blablblablablablblablablablblablablablblablablablblablablablblablablablblablablabl';
        
        //Llenar la variable list_Acc con los Id de las cuentas (simulando la seleccion de las mismas)
        List<Account> accList = [SELECT Id FROM Account];

        for(Account a : accList){
            con.list_Acc.add(a.Id);
        }

        test.startTest();
            con.crearMensaje();
        test.stopTest();

        List<Mensaje__c> messageTest = [SELECT Descripcion__c FROM Mensaje__c WHERE Related_Account__c IN :con.list_Acc ];

        System.assert(messageTest.size() == 0, 'La base de datos no tiro error');


    }

}