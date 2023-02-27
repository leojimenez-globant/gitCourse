@isTest
public class leadDuplicatedEmailTest {
	static testMethod void duplicatedEmail(){
        
        Boolean result = false;
		
        Lead leadTest = new Lead();
        
        leadtest.LastName = 'Jimenez';
        leadtest.Company = 'Mia';
        leadtest.Status = 'Working - Contacted';
        leadtest.Email = 'javier@gmail.com';
        
        insert leadtest;
        
        Lead leadTest2 = new Lead();
        
        leadtest2.LastName = 'Jimenes';
        leadtest2.Company = 'Miaa';
        leadtest2.Status = 'Working - Contacted';
        leadtest2.Email = 'leonardo@gmail.com';
        
        insert leadtest2;
        
        Lead leadtestUp = [SELECT Email FROM Lead WHERE LastName = 'Jimenes'];
        
                
        leadtestUp.Email = 'javier@gmail.com';
 
        try{
            update leadtestUp;
        }catch(DmlException ex){ result = true;}

        System.assert(result);
        
        
    }
}