public class MessageCreateController {
    
    
    public List<SelectOption> listOpc_Acc{get; set;}
    public List<String> list_Acc{get; set;}
    public String texto{get; set;}
	public List<Mensaje__c> messageToInsert = new List<Mensaje__c>();
        
    public MessageCreateController(){
        
        listOpc_Acc = new List<SelectOption>();
        list_Acc = new List<String>();
        List<Account> accs = [SELECT Name FROM Account LIMIT 10];
        
        for(Account acc: accs){
            listOpc_Acc.add(new SelectOption(acc.Id, acc.Name));
        }
    }
    
    public void crearMensaje(){
        
        if (!list_Acc.isEmpty() && !String.isBlank(texto)){
            messageToInsert = new List<Mensaje__c>();
            for (String cuenta :list_Acc){
            	Mensaje__c	mensaje = new Mensaje__c();
            	mensaje.Descripcion__c = texto;
            	mensaje.Related_Account__c = cuenta;
            	messageToInsert.add(mensaje);
        	}
            
            //insert(messageToInsert);
            Database.SaveResult[] srList = Database.insert(messageToInsert, false);
			
            for(Database.SaveResult sr: srList){
                if(sr.isSuccess()){
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Se agregaron los mensajes : '+ sr.getId())); 
                } else {
                    for (Database.Error err : sr.getErrors()){
                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Ocurrieron los siguientes errores '+ err.getStatusCode() +':' +err.getMessage() +': En :'+err.getFields() ));  
                    }
                }
                
                
            }
            
        } else if(String.isBlank(texto)){
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Ingrese el un texto'));
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Seleccione al menos una cuenta'));
        }
        
    }        
}