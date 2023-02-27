trigger OrderEventTrigger on Order_Event__e (after insert) {

    List<Task> taskToInsert = new List<Task>();
    
   
    
    for(Order_Event__e event: Trigger.New){
        
       if ( event.Has_Shipped__c == true ) {
           
           Task taskToAdd = new Task();
           taskToAdd.Priority = 'Medium';
           taskToAdd.Subject = 'Follow up on shipped order ' + event.Order_Number__c;
           taskToAdd.OwnerId = event.CreatedById;
           taskToAdd.Status = 'In Progress';
           
           taskToInsert.add(taskToAdd);
       }
    }
    
    if(taskToInsert.size() > 0){
        insert taskToInsert; 
    }

}