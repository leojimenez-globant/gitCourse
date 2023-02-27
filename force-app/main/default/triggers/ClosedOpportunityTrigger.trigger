trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
    List<Task> taskList = new List<Task> ();

    for(Opportunity opp : [SELECT Id,OwnerId  FROM Opportunity WHERE StageName = 'Closed Won' AND Id IN: trigger.new]){
        taskList.add( new Task(Subject='Follow Up Test Task',
                                 Priority = 'Normal',
                                 Status = 'Completed',
                                 WhatId = opp.Id,
                                 OwnerId = opp.OwnerId));
        
     }

     

     if(taskList.size() > 0){
         if(trigger.isUpdate){
             update taskList;
         }
         if(trigger.isInsert){
             insert taskList;
         }
     }
}