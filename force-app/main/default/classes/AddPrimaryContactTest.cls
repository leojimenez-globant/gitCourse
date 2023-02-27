@isTest
public class AddPrimaryContactTest {
	@isTest static void testList(){
        List<Account> cuentas = new List<Account>(); 
        for(Integer i=0; i<50; i++){
            cuentas.add( new Account(Name='Leo '+i, BillingState = 'NY'));
        }
       
        for(Integer j=0; j<50; j++){
            cuentas.add( new Account(Name='Leon '+j, BillingState = 'CA'));
        }
        insert cuentas;
        
        Contact co = new Contact();
        co.FirstName = 'Leonn';
        co.LastName = 'ardo';
        insert co;
        
        String stado = 'CA';
        
        AddPrimaryContact testeo = new AddPrimaryContact(co,stado);
        Test.startTest();
        System.enqueueJob(testeo);
        Test.stopTest();
        
        
    }
}