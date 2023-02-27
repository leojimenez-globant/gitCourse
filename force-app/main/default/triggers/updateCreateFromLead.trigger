trigger updateCreateFromLead on Lead (after insert, after update) {
    
    List<Task> lTaskt = new  List<Task>();
    Task newTask;
    
    if (Trigger.isAfter){
        if(Trigger.isInsert){
            for(Lead l: Trigger.new){
                newTask = new Task ();
                newTask.OwnerId = l.OwnerId;
                newTask.Status = 'In Progress';
                newTask.Subject = 'Email';
                newTask.WhoId = l.Id;
                newTask.Priority = 'Normal';
                newTask.Descripcion_Personalizada__c = l.Descripcion_Personalizada__c;
                newTask.Texto_Auxiliar__c = l.Texto_Auxiliar__c;
                newTask.Primero_Creado__c = 'Si';
                lTaskt.add(newTask);
                
            }
            if (!lTaskt.isEmpty())
                insert newTask;
        }   
       //if (Trigger.isUpdate){
            List<Task> TasktUp = new  List<Task>();            
            List<Task> taskToUpdate = [SELECT Descripcion_Personalizada__c, Texto_Auxiliar__c
                                       FROM Task 
                                       WHERE WhoId 
                                       IN :Trigger.New 
                                       AND Primero_Creado__c = 'Si'];

            for (Lead leadupdated : Trigger.new){
               for( Task taskupdated : taskToUpdate){
                    taskupdated.Descripcion_Personalizada__c = leadupdated.Descripcion_Personalizada__c;
                    taskupdated.Texto_Auxiliar__c = leadupdated.Texto_Auxiliar__c;
                    TasktUp.add(taskupdated);
                    
               } 
                if (!TasktUp.isEmpty())
                	update TasktUp;
            }
       // }
    }


}